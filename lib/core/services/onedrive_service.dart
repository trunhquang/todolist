import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_onedrive/flutter_onedrive.dart' as od;
import 'package:flutter_onedrive/token.dart' as od_token;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../../app/constants/app_constants.dart';

class OneDriveService {
  static OneDriveService? _instance;
  static OneDriveService get instance => _instance ??= OneDriveService._();
  
  OneDriveService._();

  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  od.OneDrive? _oneDrive;
  bool _isInitialized = false;
  String? _accessToken;
  final String _baseUrl = 'https://graph.microsoft.com/v1.0';

  // Initialize OneDrive service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Try to read any existing tokens
      _accessToken = await _secureStorage.read(key: 'onedrive_access_token');
      // Initialize flutter_onedrive with a token manager bridged to our storage
      _oneDrive = od.OneDrive(
        clientID: AppConstants.oneDriveClientId,
        redirectURL: 'msauth.${AppConstants.appName}://auth',
        scopes: 'offline_access https://graph.microsoft.com/Files.ReadWrite.All',
        tokenManager: _AppAuthTokenManager(_secureStorage),
      );
      _isInitialized = true;
    } catch (e) {
      throw OneDriveException(
        message: 'Failed to initialize OneDrive service: ${e.toString()}',
      );
    }
  }

  // Authenticate user
  Future<bool> authenticate() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final authorizationEndpoint = 'https://login.microsoftonline.com/${AppConstants.oneDriveTenantId}/oauth2/v2.0/authorize';
      final tokenEndpoint = 'https://login.microsoftonline.com/${AppConstants.oneDriveTenantId}/oauth2/v2.0/token';
      final redirectUrl = 'msauth.${AppConstants.appName}://auth';
      final clientId = AppConstants.oneDriveClientId;
      final scopes = <String>[
        'openid',
        'profile',
        'offline_access',
        'https://graph.microsoft.com/User.Read',
        'https://graph.microsoft.com/Files.ReadWrite.All',
      ];

      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
            tokenEndpoint: 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
          ),
          scopes: scopes,
          preferEphemeralSession: false,
          promptValues: ['select_account'],
        ),
      );

      if (result != null && result.accessToken != null) {
        _accessToken = result.accessToken;
        await _secureStorage.write(key: 'onedrive_access_token', value: _accessToken);
        if (result.refreshToken != null) {
          await _secureStorage.write(key: 'onedrive_refresh_token', value: result.refreshToken);
        }
        return true;
      }
      return false;
    } catch (e) {
      throw AuthenticationException(
        message: 'OneDrive authentication failed: ${e.toString()}',
      );
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => _accessToken != null;

  // Sign out
  Future<void> signOut() async {
    if (!_isInitialized) return;

    try {
      // Clear tokens; next operation will re-authenticate
      _accessToken = null;
      await _secureStorage.delete(key: 'onedrive_access_token');
      await _secureStorage.delete(key: 'onedrive_refresh_token');
    } catch (e) {
      throw OneDriveException(
        message: 'Failed to sign out: ${e.toString()}',
      );
    }
  }

  // Get access token
  Future<String?> getAccessToken() async {
    if (_accessToken != null) {
      return _accessToken;
    }

    if (await authenticate()) {
      return _accessToken;
    }

    return null;
  }

  // Make authenticated HTTP request
  Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final token = await getAccessToken();
    if (token == null) {
      throw UnauthorizedException(message: 'No access token available');
    }

    final url = '$_baseUrl$endpoint';
    final requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      ...?headers,
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(Uri.parse(url), headers: requestHeaders);
      case 'POST':
        return await http.post(
          Uri.parse(url),
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          Uri.parse(url),
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(Uri.parse(url), headers: requestHeaders);
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }
  }

  // Create folder
  Future<Map<String, dynamic>> createFolder(String name, {String? parentId}) async {
    try {
      // Prefer flutter_onedrive SDK at root
      if (parentId == null && _oneDrive != null) {
        final resp = await _oneDrive!.createDirectory(name, isAppFolder: false);
        if (resp.isSuccess == true) {
          final body = resp.body ?? '';
          return jsonDecode(body.isNotEmpty ? body : '{"name":"$name"}');
        }
      }

      // Fallback to Graph HTTP
      final endpoint = parentId != null 
          ? '/me/drive/items/$parentId/children'
          : '/me/drive/root/children';
      
      final body = {
        'name': name,
        'folder': {},
        '@microsoft.graph.conflictBehavior': 'rename',
      };

      final response = await _makeRequest('POST', endpoint, body: body);
      
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      throw ServerException(
        message: 'Failed to create folder: ${response.body}',
        code: response.statusCode.toString(),
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to create folder: ${e.toString()}',
      );
    }
  }

  // Upload file
  Future<Map<String, dynamic>> uploadFile(
    String fileName,
    List<int> fileContent, {
    String? parentId,
    String? contentType,
  }) async {
    try {
      // Prefer flutter_onedrive SDK for root uploads
      if (parentId == null && _oneDrive != null) {
        final resp = await _oneDrive!.push(
          Uint8List.fromList(fileContent),
          '/$fileName',
          isAppFolder: false,
        );
        if (resp.isSuccess == true) {
          final body = resp.body ?? '';
          return jsonDecode(body.isNotEmpty ? body : '{"name":"$fileName"}');
        }
      }

      // Fallback to Graph HTTP
      final endpoint = parentId != null 
          ? '/me/drive/items/$parentId:/$fileName:/content'
          : '/me/drive/root:/$fileName:/content';

      final headers = contentType != null 
          ? {'Content-Type': contentType}
          : null;

      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer ${await getAccessToken()}',
          ...?headers,
        },
        body: fileContent,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      throw ServerException(
        message: 'Failed to upload file: ${response.body}',
        code: response.statusCode.toString(),
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw UploadException(
        message: 'Failed to upload file: ${e.toString()}',
      );
    }
  }

  // Download file
  Future<List<int>> downloadFile(String fileId) async {
    try {
      final endpoint = '/me/drive/items/$fileId/content';
      final response = await _makeRequest('GET', endpoint);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw ServerException(
          message: 'Failed to download file: ${response.body}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw DownloadException(
        message: 'Failed to download file: ${e.toString()}',
      );
    }
  }

  // Get file info
  Future<Map<String, dynamic>> getFileInfo(String fileId) async {
    try {
      final endpoint = '/me/drive/items/$fileId';
      final response = await _makeRequest('GET', endpoint);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerException(
          message: 'Failed to get file info: ${response.body}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to get file info: ${e.toString()}',
      );
    }
  }

  // List files in folder
  Future<List<Map<String, dynamic>>> listFiles({String? folderId}) async {
    try {
      if (folderId == null && _oneDrive != null) {
        final files = await _oneDrive!.listFiles('', isAppFolder: false);
        return files.map((f) => {
          'name': f.name,
          'id': f.id,
          'size': f.size,
              'folder': f.isFolder ? {} : null,
        }).toList();
      }

      final endpoint = folderId != null 
          ? '/me/drive/items/$folderId/children'
          : '/me/drive/root/children';
      
      final response = await _makeRequest('GET', endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      }
      throw ServerException(
        message: 'Failed to list files: ${response.body}',
        code: response.statusCode.toString(),
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to list files: ${e.toString()}',
      );
    }
  }

  // Delete file
  Future<void> deleteFile(String fileId) async {
    try {
      final endpoint = '/me/drive/items/$fileId';
      final response = await _makeRequest('DELETE', endpoint);

      if (response.statusCode != 204) {
        throw ServerException(
          message: 'Failed to delete file: ${response.body}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to delete file: ${e.toString()}',
      );
    }
  }

  // Backup app data to OneDrive
  Future<Map<String, dynamic>> backupAppData(Map<String, dynamic> data) async {
    try {
      // Create backup folder if it doesn't exist
      final backupFolderName = 'TodoList_Backups';
      final backupFolder = await _createOrGetBackupFolder(backupFolderName);

      // Generate backup file name with timestamp
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final fileName = 'backup_$timestamp.json';

      // Convert data to JSON
      final jsonData = jsonEncode(data);
      final fileContent = utf8.encode(jsonData);

      // Upload backup file
      final uploadedFile = await uploadFile(
        fileName,
        fileContent,
        parentId: backupFolder['id'],
        contentType: 'application/json',
      );

      return uploadedFile;
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to backup app data: ${e.toString()}',
      );
    }
  }

  // Restore app data from OneDrive
  Future<Map<String, dynamic>> restoreAppData(String fileId) async {
    try {
      // Download backup file
      final fileContent = await downloadFile(fileId);
      final jsonString = utf8.decode(fileContent);
      
      // Parse JSON data
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return data;
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to restore app data: ${e.toString()}',
      );
    }
  }

  // List backup files
  Future<List<Map<String, dynamic>>> listBackupFiles() async {
    try {
      final backupFolderName = 'TodoList_Backups';
      final backupFolder = await _createOrGetBackupFolder(backupFolderName);
      
      final files = await listFiles(folderId: backupFolder['id']);
      
      // Filter only JSON backup files
      return files.where((file) => 
        file['name']?.toString().endsWith('.json') == true &&
        file['name']?.toString().startsWith('backup_') == true
      ).toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to list backup files: ${e.toString()}',
      );
    }
  }

  // Create or get backup folder
  Future<Map<String, dynamic>> _createOrGetBackupFolder(String folderName) async {
    try {
      // First, try to find existing folder
      final rootFiles = await listFiles();
      final existingFolder = rootFiles.firstWhere(
        (file) => file['name'] == folderName && file['folder'] != null,
        orElse: () => {},
      );

      if (existingFolder.isNotEmpty) {
        return existingFolder;
      }

      // Create new folder if not found
      return await createFolder(folderName);
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to create or get backup folder: ${e.toString()}',
      );
    }
  }

  // Get user info
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await _makeRequest('GET', '/me');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerException(
          message: 'Failed to get user info: ${response.body}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to get user info: ${e.toString()}',
      );
    }
  }

  // Check storage quota
  Future<Map<String, dynamic>> getStorageQuota() async {
    try {
      final response = await _makeRequest('GET', '/me/drive');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'total': data['quota']?['total'],
          'used': data['quota']?['used'],
          'remaining': data['quota']?['remaining'],
        };
      } else {
        throw ServerException(
          message: 'Failed to get storage quota: ${response.body}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to get storage quota: ${e.toString()}',
      );
    }
  }
}

class _AppAuthTokenManager implements od_token.ITokenManager {
  final FlutterSecureStorage secureStorage;
  static const String _expireKey = "__tokenExpire";
  static const String _accessTokenKey = "onedrive_access_token";
  static const String _refreshTokenKey = "onedrive_refresh_token";

  _AppAuthTokenManager(this.secureStorage);

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<void> saveTokenResp(dynamic resp) async {
    try {
      final accessToken = resp?.accessToken as String?;
      final refreshToken = resp?.refreshToken as String?;
      final expiration = resp?.expiration?.toString();
      if (accessToken != null) {
        await secureStorage.write(key: _accessTokenKey, value: accessToken);
      }
      if (refreshToken != null) {
        await secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      }
      if (expiration != null) {
        await secureStorage.write(key: _expireKey, value: expiration);
      }
    } catch (_) {}
  }

  @override
  Future<void> clearStoredToken() async {
    await Future.wait([
      secureStorage.delete(key: _accessTokenKey),
      secureStorage.delete(key: _refreshTokenKey),
      secureStorage.delete(key: _expireKey),
    ]);
  }
}

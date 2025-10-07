import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_onedrive/flutter_onedrive.dart' as od;
import 'package:flutter_onedrive/token.dart' as od_token;

import '../errors/exceptions.dart';
import '../../app/constants/app_constants.dart';

class OneDriveService {
  factory OneDriveService() => _instance ??= OneDriveService._();
  OneDriveService._();

  static OneDriveService? _instance;

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
        message: 'Failed to initialize OneDrive service: $e',
      );
    }
  }

  // Authenticate user
  Future<bool> authenticate() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // const authorizationEndpoint = 'https://login.microsoftonline.com/${AppConstants.oneDriveTenantId}/oauth2/v2.0/authorize';
      // const tokenEndpoint = 'https://login.microsoftonline.com/${AppConstants.oneDriveTenantId}/oauth2/v2.0/token';
      const redirectUrl = 'msauth.${AppConstants.appName}://auth';
      const clientId = AppConstants.oneDriveClientId;
      const scopes = <String>[
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
        message: 'OneDrive authentication failed: $e',
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
        message: 'Failed to sign out: $e',
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
      throw const UnauthorizedException(message: 'No access token available');
    }

    final url = '$_baseUrl$endpoint';
    final requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      ...?headers,
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return http.get(Uri.parse(url), headers: requestHeaders);
      case 'POST':
        return http.post(
          Uri.parse(url),
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return http.put(
          Uri.parse(url),
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return http.delete(Uri.parse(url), headers: requestHeaders);
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }
  }

  // Create folder
  Future<Map<String, dynamic>> createFolder(String name, {String? parentId}) async {
    try {
      // Prefer flutter_onedrive SDK at root
      if (parentId == null && _oneDrive != null) {
        final resp = await _oneDrive!.createDirectory(name);
        if (resp.isSuccess) {
          final body = resp.body ?? '';
          final decoded = jsonDecode(body.isNotEmpty ? body : '{"name":"$name"}') as Map<String, dynamic>;
          return Map<String, dynamic>.from(decoded);
        }
      }

      // Fallback to Graph HTTP
      final endpoint = parentId != null 
          ? '/me/drive/items/$parentId/children'
          : '/me/drive/root/children';
      
      final body = <String, dynamic>{
        'name': name,
        'folder': <String, dynamic>{},
        '@microsoft.graph.conflictBehavior': 'rename',
      };

      final response = await _makeRequest('POST', endpoint, body: body);
      
      if (response.statusCode == 201) {
        return Map<String, dynamic>.from(jsonDecode(response.body) as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to create folder: ${response.body}',
        code: response.statusCode.toString(),
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to create folder: $e',
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
        );
        if (resp.isSuccess) {
          final body = resp.body ?? '';
          final decoded = jsonDecode(body.isNotEmpty ? body : '{"name":"$fileName"}') as Map<String, dynamic>;
          return Map<String, dynamic>.from(decoded);
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
        return Map<String, dynamic>.from(jsonDecode(response.body) as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to upload file: ${response.body}',
        code: response.statusCode.toString(),
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw UploadException(
        message: 'Failed to upload file: $e',
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
        message: 'Failed to download file: $e',
      );
    }
  }

  // Get file info
  Future<Map<String, dynamic>> getFileInfo(String fileId) async {
    try {
      final endpoint = '/me/drive/items/$fileId';
      final response = await _makeRequest('GET', endpoint);

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
      } else {
        throw ServerException(
          message: 'Failed to get file info: ${response.body}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to get file info: $e',
      );
    }
  }

  // List files in folder
  Future<List<Map<String, dynamic>>> listFiles({String? folderId}) async {
    try {
      if (folderId == null && _oneDrive != null) {
        final files = await _oneDrive!.listFiles('');
        return files.map((f) => <String, dynamic>{
          'name': f.name,
          'id': f.id,
          'size': f.size,
              'folder': f.isFolder ? <String, dynamic>{} : null,
        }).toList();
      }

      final endpoint = folderId != null 
          ? '/me/drive/items/$folderId/children'
          : '/me/drive/root/children';
      
      final response = await _makeRequest('GET', endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final items = (data['value'] as List?) ?? <dynamic>[];
        return items
            .whereType<Map<String, dynamic>>()
            .map(Map<String, dynamic>.from)
            .toList();
      }
      throw ServerException(
        message: 'Failed to list files: ${response.body}',
        code: response.statusCode.toString(),
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to list files: $e',
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
        message: 'Failed to delete file: $e',
      );
    }
  }

  // Backup app data to OneDrive
  Future<Map<String, dynamic>> backupAppData(Map<String, dynamic> data) async {
    try {
      // Create backup folder if it doesn't exist
      const backupFolderName = 'TodoList_Backups';
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
        parentId: backupFolder['id']?.toString(),
        contentType: 'application/json',
      );

      return uploadedFile;
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to backup app data: $e',
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
        message: 'Failed to restore app data: $e',
      );
    }
  }

  // List backup files
  Future<List<Map<String, dynamic>>> listBackupFiles() async {
    try {
      const backupFolderName = 'TodoList_Backups';
      final backupFolder = await _createOrGetBackupFolder(backupFolderName);
      
      final files = await listFiles(folderId: backupFolder['id']?.toString());
      
      // Filter only JSON backup files
      return files.where((file) => 
        (file['name']?.toString().endsWith('.json') ?? false) &&
        (file['name']?.toString().startsWith('backup_') ?? false)
      ).toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to list backup files: $e',
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
        orElse: () => <String, dynamic>{},
      );

      if (existingFolder.isNotEmpty) {
        return existingFolder;
      }

      // Create new folder if not found
      return await createFolder(folderName);
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to create or get backup folder: $e',
      );
    }
  }

  // Get user info
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await _makeRequest('GET', '/me');
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
      } else {
        throw ServerException(
          message: 'Failed to get user info: ${response.body}',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw OneDriveException(
        message: 'Failed to get user info: $e',
      );
    }
  }

  // Check storage quota
  Future<Map<String, dynamic>> getStorageQuota() async {
    try {
      final response = await _makeRequest('GET', '/me/drive');
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
        final quota = data['quota'] is Map
            ? (data['quota'] as Map).cast<String, dynamic>()
            : <String, dynamic>{};
        return <String, dynamic>{
          'total': quota['total'],
          'used': quota['used'],
          'remaining': quota['remaining'],
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
        message: 'Failed to get storage quota: $e',
      );
    }
  }
}

class _AppAuthTokenManager implements od_token.ITokenManager {
  _AppAuthTokenManager(this.secureStorage);

  final FlutterSecureStorage secureStorage;
  static const String _expireKey = '__tokenExpire';
  static const String _accessTokenKey = 'onedrive_access_token';
  static const String _refreshTokenKey = 'onedrive_refresh_token';

  @override
  Future<String?> getAccessToken() async {
    return secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<void> saveTokenResp(dynamic resp) async {
    try {
      final map = resp is Map
          ? resp.cast<String, dynamic>()
          : resp is Object
              ? <String, dynamic>{
                  'accessToken': (resp as dynamic).accessToken as String?,
                  'refreshToken': (resp as dynamic).refreshToken as String?,
                  'expiration': (resp as dynamic).expiration,
                }
              : <String, dynamic>{};
      final accessToken = map['accessToken'] as String?;
      final refreshToken = map['refreshToken'] as String?;
      final expiration = map['expiration']?.toString();
      if (accessToken != null) {
        await secureStorage.write(key: _accessTokenKey, value: accessToken);
      }
      if (refreshToken != null) {
        await secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      }
      if (expiration != null) {
        await secureStorage.write(key: _expireKey, value: expiration);
      }
    } on Exception catch (_) {}
  }

  @override
  Future<void> clearStoredToken() async {
    await Future.wait(<Future<void>>[
      secureStorage.delete(key: _accessTokenKey),
      secureStorage.delete(key: _refreshTokenKey),
      secureStorage.delete(key: _expireKey),
    ]);
  }
}

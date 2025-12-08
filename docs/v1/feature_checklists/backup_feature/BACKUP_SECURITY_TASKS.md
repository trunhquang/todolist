# Backup Security: Encryption, Checksum, Retention/Auto-Cleanup - Task List & Implementation Steps

## Overview
This document lists all tasks required to implement the **Backup Security** feature. Currently, this feature is **MISSING** - Not implemented. Backup security should include: file encryption (mã hóa file backup), checksum signing (ký checksum), retention policy (retention), and auto-cleanup (auto-cleanup).

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `BackupService` exists with `exportDataToOneDrive()` method (but empty)
- ✅ `OneDriveService` exists with `backupAppData()` method
- ✅ `CredentialService` exists and uses `FlutterSecureStorage` for secure storage
- ✅ `StorageService` exists for local storage
- ✅ Some secure storage infrastructure exists

### What's Missing/Broken:
- ⛔ No backup file encryption
- ⛔ No backup file decryption
- ⛔ No checksum calculation
- ⛔ No checksum signing
- ⛔ No checksum verification
- ⛔ No retention policy
- ⛔ No auto-cleanup functionality
- ⛔ No encryption key management
- ⛔ No signature verification

---

## Task List

### Task 1: Add Encryption Package and Create Encryption Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Add encryption package to pubspec.yaml and create encryption service for backup file encryption/decryption.

**Files to Create/Modify**:
- `pubspec.yaml` (add encryption package)
- `lib/core/services/encryption_service.dart` (new file)

**Dependencies**:
- None

**Implementation Steps**:

1. **Add encryption package to pubspec.yaml**:
   ```yaml
   dependencies:
     encrypt: ^5.0.3  # For AES encryption
     # OR
     pointycastle: ^3.7.3  # For more advanced encryption
   ```

2. **Create EncryptionService**:
   ```dart
   // lib/core/services/encryption_service.dart
   import 'dart:convert';
   import 'dart:math';
   import 'package:encrypt/encrypt.dart' as encrypt;
   import 'package:flutter_secure_storage/flutter_secure_storage.dart';
   
   class EncryptionService {
     factory EncryptionService() => _instance ??= EncryptionService._();
     EncryptionService._();
     static EncryptionService? _instance;
     
     final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
     static const String _encryptionKeyKey = 'backup_encryption_key';
     
     /// Generate encryption key
     Future<encrypt.Key> _generateKey() async {
       final key = encrypt.Key.fromSecureRandom(32); // AES-256
       return key;
     }
     
     /// Get or create encryption key
     Future<encrypt.Key> _getOrCreateKey() async {
       try {
         final keyString = await _secureStorage.read(key: _encryptionKeyKey);
         if (keyString != null && keyString.isNotEmpty) {
           return encrypt.Key.fromBase64(keyString);
         }
         
         // Generate new key
         final key = await _generateKey();
         await _secureStorage.write(
           key: _encryptionKeyKey,
           value: key.base64,
         );
         return key;
       } catch (e) {
         throw Exception('Failed to get encryption key: $e');
       }
     }
     
     /// Encrypt data
     Future<Uint8List> encryptData(Uint8List data) async {
       try {
         final key = await _getOrCreateKey();
         final iv = encrypt.IV.fromSecureRandom(16); // AES block size
         
         final encrypter = encrypt.Encrypter(encrypt.AES(key));
         final encrypted = encrypter.encryptBytes(data, iv: iv);
         
         // Combine IV and encrypted data
         final result = Uint8List(iv.bytes.length + encrypted.bytes.length);
         result.setRange(0, iv.bytes.length, iv.bytes);
         result.setRange(iv.bytes.length, result.length, encrypted.bytes);
         
         return result;
       } catch (e) {
         throw Exception('Failed to encrypt data: $e');
       }
     }
     
     /// Decrypt data
     Future<Uint8List> decryptData(Uint8List encryptedData) async {
       try {
         final key = await _getOrCreateKey();
         
         // Extract IV and encrypted data
         final iv = encrypt.IV(encryptedData.sublist(0, 16));
         final encrypted = encrypt.Encrypted(encryptedData.sublist(16));
         
         final encrypter = encrypt.Encrypter(encrypt.AES(key));
         final decrypted = encrypter.decryptBytes(encrypted, iv: iv);
         
         return Uint8List.fromList(decrypted);
       } catch (e) {
         throw Exception('Failed to decrypt data: $e');
       }
     }
     
     /// Encrypt string
     Future<String> encryptString(String data) async {
       final bytes = utf8.encode(data);
       final encrypted = await encryptData(Uint8List.fromList(bytes));
       return base64Encode(encrypted);
     }
     
     /// Decrypt string
     Future<String> decryptString(String encryptedData) async {
       final bytes = base64Decode(encryptedData);
       final decrypted = await decryptData(bytes);
       return utf8.decode(decrypted);
     }
   }
   ```

**Expected Results**:
- ✅ Encryption package is added to pubspec.yaml
- ✅ EncryptionService exists
- ✅ Service can encrypt/decrypt data
- ✅ Encryption key is stored securely
- ✅ AES-256 encryption is used

**Testing**:
- Test encryption/decryption of data
- Test encryption key generation and storage
- Test error handling
- Verify encryption is secure

---

### Task 2: Integrate Encryption with Backup Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Integrate encryption service with BackupService to encrypt backup files before upload.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Task 1 (EncryptionService)

**Implementation Steps**:

1. **Add EncryptionService to BackupService**:
   ```dart
   // In lib/core/services/backup_service.dart
   import 'encryption_service.dart';
   
   class BackupService {
     final EncryptionService _encryptionService = EncryptionService();
     
     // ... existing code ...
   }
   ```

2. **Add encryption to backup process**:
   ```dart
   Future<void> exportDataToOneDrive({
     BackupScope? scope,
     bool encrypt = true, // Enable encryption by default
   }) async {
     try {
       final userId = _storage.getUserId();
       final workspaceId = _storage.getWorkspaceId();
       
       if (userId == null || workspaceId == null || workspaceId.isEmpty) {
         throw const UnknownFailure(message: 'User or workspace not found');
       }
       
       // Build backup payload
       final payload = await _buildBackupPayload(
         workspaceId: workspaceId,
         scope: scope ?? const BackupScope(),
       );
       
       // Convert to JSON
       final jsonString = jsonEncode(payload);
       final jsonBytes = utf8.encode(jsonString);
       
       // Encrypt if enabled
       Uint8List backupData;
       String fileExtension = '.json';
       
       if (encrypt) {
         backupData = await _encryptionService.encryptData(jsonBytes);
         fileExtension = '.enc.json'; // Encrypted JSON
         Get.log('Backup data encrypted');
       } else {
         backupData = Uint8List.fromList(jsonBytes);
       }
       
       // Create backup metadata
       final backupMetadata = {
         'workspaceId': workspaceId,
         'exportedAt': DateTime.now().toIso8601String(),
         'encrypted': encrypt,
         'version': '1.0',
       };
       
       // Upload to OneDrive
       await _oneDrive.backupAppData(
         backupData,
         metadata: backupMetadata,
         fileExtension: fileExtension,
       );
       
       Get.log('Backup completed successfully');
     } catch (e) {
       Get.log('Backup failed: $e');
       rethrow;
     }
   }
   ```

3. **Update OneDriveService to support encrypted files**:
   ```dart
   // In lib/core/services/onedrive_service.dart
   Future<Map<String, dynamic>> backupAppData(
     dynamic data, {
     Map<String, dynamic>? metadata,
     String fileExtension = '.json',
   }) async {
     // ... existing code ...
     
     // Handle encrypted data
     Uint8List fileContent;
     if (data is Uint8List) {
       fileContent = data;
     } else if (data is Map<String, dynamic>) {
       final jsonString = jsonEncode(data);
       fileContent = utf8.encode(jsonString);
     } else {
       throw OneDriveException(message: 'Invalid data type for backup');
     }
     
     // Upload file
     final uploadedFile = await uploadFile(
       fileName,
       fileContent,
       parentId: backupFolder['id']?.toString(),
       contentType: fileExtension.contains('.enc') 
           ? 'application/octet-stream' 
           : 'application/json',
     );
     
     return uploadedFile;
   }
   ```

**Expected Results**:
- ✅ Encryption is integrated with backup process
- ✅ Backup files are encrypted before upload
- ✅ Encrypted files have appropriate file extension
- ✅ Backup metadata indicates encryption status

**Testing**:
- Test backup with encryption enabled
- Test backup with encryption disabled
- Verify encrypted files are created
- Verify encrypted files can be decrypted

---

### Task 3: Integrate Decryption with Restore Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Integrate decryption service with restore process to decrypt backup files during restore.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Task 1 (EncryptionService)
- Task 2 (Encryption integration)

**Implementation Steps**:

1. **Add decryption to restore process**:
   ```dart
   Future<Map<String, dynamic>> restoreBackup(String fileId) async {
     try {
       // Download backup file
       final fileContent = await _oneDrive.downloadFile(fileId);
       
       // Get backup metadata (if available)
       final backupMetadata = await _getBackupMetadata(fileId);
       final isEncrypted = backupMetadata['encrypted'] == true;
       
       Uint8List decryptedData;
       
       if (isEncrypted) {
         // Decrypt backup file
         decryptedData = await _encryptionService.decryptData(fileContent);
         Get.log('Backup data decrypted');
       } else {
         decryptedData = fileContent;
       }
       
       // Parse JSON
       final jsonString = utf8.decode(decryptedData);
       final data = jsonDecode(jsonString) as Map<String, dynamic>;
       
       return data;
     } catch (e) {
       Get.log('ERROR: Failed to restore backup: $e');
       if (e.toString().contains('decrypt')) {
         throw const UnknownFailure(
           message: 'Failed to decrypt backup file. Encryption key may be missing or incorrect.',
         );
       }
       rethrow;
     }
   }
   ```

2. **Add method to get backup metadata**:
   ```dart
   Future<Map<String, dynamic>> _getBackupMetadata(String fileId) async {
     try {
       // Try to get metadata from file name or separate metadata file
       // For now, check file extension
       final backupFiles = await listBackups();
       final backupFile = backupFiles.firstWhere(
         (file) => file['id'] == fileId,
         orElse: () => {},
       );
       
       final fileName = backupFile['name']?.toString() ?? '';
       final isEncrypted = fileName.endsWith('.enc.json');
       
       return {
         'encrypted': isEncrypted,
       };
     } catch (e) {
       Get.log('ERROR: Failed to get backup metadata: $e');
       return {'encrypted': false};
     }
   }
   ```

**Expected Results**:
- ✅ Decryption is integrated with restore process
- ✅ Encrypted backup files are decrypted during restore
- ✅ Decryption errors are handled gracefully
- ✅ Error messages are clear

**Testing**:
- Test restore with encrypted backup
- Test restore with unencrypted backup
- Test restore with wrong encryption key
- Verify decryption works correctly

---

### Task 4: Create Checksum Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Create service for calculating and verifying checksums (SHA-256) for backup files.

**Files to Create**:
- `lib/core/services/checksum_service.dart` (new file)

**Dependencies**:
- `crypto` package (usually included in Flutter)

**Implementation Steps**:

1. **Add crypto package to pubspec.yaml** (if not already included):
   ```yaml
   dependencies:
     crypto: ^3.0.3
   ```

2. **Create ChecksumService**:
   ```dart
   // lib/core/services/checksum_service.dart
   import 'dart:convert';
   import 'dart:typed_data';
   import 'package:crypto/crypto.dart';
   
   class ChecksumService {
     factory ChecksumService() => _instance ??= ChecksumService._();
     ChecksumService._();
     static ChecksumService? _instance;
     
     /// Calculate SHA-256 checksum for data
     String calculateChecksum(Uint8List data) {
       final bytes = sha256.convert(data).bytes;
       return base64Encode(bytes);
     }
     
     /// Calculate SHA-256 checksum for string
     String calculateChecksumForString(String data) {
       final bytes = utf8.encode(data);
       return calculateChecksum(Uint8List.fromList(bytes));
     }
     
     /// Verify checksum
     bool verifyChecksum(Uint8List data, String expectedChecksum) {
       final calculatedChecksum = calculateChecksum(data);
       return calculatedChecksum == expectedChecksum;
     }
     
     /// Verify checksum for string
     bool verifyChecksumForString(String data, String expectedChecksum) {
       final bytes = utf8.encode(data);
       return verifyChecksum(Uint8List.fromList(bytes), expectedChecksum);
     }
   }
   ```

**Expected Results**:
- ✅ ChecksumService exists
- ✅ Service can calculate SHA-256 checksum
- ✅ Service can verify checksum
- ✅ Checksum is base64 encoded

**Testing**:
- Test checksum calculation
- Test checksum verification
- Test checksum with different data
- Verify checksum detects data corruption

---

### Task 5: Integrate Checksum with Backup Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Integrate checksum service with BackupService to calculate and store checksum for backup files.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Task 4 (ChecksumService)

**Implementation Steps**:

1. **Add ChecksumService to BackupService**:
   ```dart
   // In lib/core/services/backup_service.dart
   import 'checksum_service.dart';
   
   class BackupService {
     final ChecksumService _checksumService = ChecksumService();
     
     // ... existing code ...
   }
   ```

2. **Add checksum calculation to backup process**:
   ```dart
   Future<void> exportDataToOneDrive({
     BackupScope? scope,
     bool encrypt = true,
     bool calculateChecksum = true,
   }) async {
     // ... build payload and encrypt ...
     
     // Calculate checksum
     String? checksum;
     if (calculateChecksum) {
       checksum = _checksumService.calculateChecksum(backupData);
       Get.log('Backup checksum calculated: $checksum');
     }
     
     // Create backup metadata with checksum
     final backupMetadata = {
       'workspaceId': workspaceId,
       'exportedAt': DateTime.now().toIso8601String(),
       'encrypted': encrypt,
       'checksum': checksum,
       'checksumAlgorithm': 'SHA-256',
       'version': '1.0',
     };
     
     // Upload to OneDrive
     await _oneDrive.backupAppData(
       backupData,
       metadata: backupMetadata,
       fileExtension: fileExtension,
     );
     
     // Store checksum separately (optional, for verification)
     if (checksum != null) {
       await _storeChecksum(fileId, checksum);
     }
   }
   ```

3. **Add method to store checksum**:
   ```dart
   Future<void> _storeChecksum(String fileId, String checksum) async {
     try {
       // Store checksum in Firebase or local storage
       await _storage.setString('backup_checksum_$fileId', checksum);
     } catch (e) {
       Get.log('WARNING: Failed to store checksum: $e');
       // Don't throw - checksum storage failure shouldn't break backup
     }
   }
   ```

**Expected Results**:
- ✅ Checksum is calculated for backup files
- ✅ Checksum is stored with backup metadata
- ✅ Checksum algorithm is specified (SHA-256)
- ✅ Checksum is stored for verification

**Testing**:
- Test checksum calculation during backup
- Test checksum storage
- Verify checksum is correct
- Test backup with checksum disabled

---

### Task 6: Integrate Checksum Verification with Restore Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Integrate checksum verification with restore process to verify backup file integrity.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Task 4 (ChecksumService)
- Task 5 (Checksum integration)

**Implementation Steps**:

1. **Add checksum verification to restore process**:
   ```dart
   Future<Map<String, dynamic>> restoreBackup(String fileId) async {
     try {
       // Download backup file
       final fileContent = await _oneDrive.downloadFile(fileId);
       
       // Get backup metadata
       final backupMetadata = await _getBackupMetadata(fileId);
       final expectedChecksum = backupMetadata['checksum']?.toString();
       
       // Verify checksum if available
       if (expectedChecksum != null && expectedChecksum.isNotEmpty) {
         final isValid = _checksumService.verifyChecksum(
           fileContent,
           expectedChecksum,
         );
         
         if (!isValid) {
           Get.log('ERROR: Backup file checksum verification failed');
           throw const UnknownFailure(
             message: 'Backup file integrity check failed. File may be corrupted.',
           );
         }
         
         Get.log('Backup file checksum verified');
       }
       
       // Decrypt if encrypted
       final isEncrypted = backupMetadata['encrypted'] == true;
       Uint8List decryptedData;
       
       if (isEncrypted) {
         decryptedData = await _encryptionService.decryptData(fileContent);
       } else {
         decryptedData = fileContent;
       }
       
       // Parse JSON
       final jsonString = utf8.decode(decryptedData);
       final data = jsonDecode(jsonString) as Map<String, dynamic>;
       
       return data;
     } catch (e) {
       Get.log('ERROR: Failed to restore backup: $e');
       rethrow;
     }
   }
   ```

2. **Update _getBackupMetadata to include checksum**:
   ```dart
   Future<Map<String, dynamic>> _getBackupMetadata(String fileId) async {
     try {
       final backupFiles = await listBackups();
       final backupFile = backupFiles.firstWhere(
         (file) => file['id'] == fileId,
         orElse: () => {},
       );
       
       final fileName = backupFile['name']?.toString() ?? '';
       final isEncrypted = fileName.endsWith('.enc.json');
       
       // Get checksum from storage
       final checksum = _storage.getString('backup_checksum_$fileId');
       
       return {
         'encrypted': isEncrypted,
         'checksum': checksum,
         'checksumAlgorithm': checksum != null ? 'SHA-256' : null,
       };
     } catch (e) {
       Get.log('ERROR: Failed to get backup metadata: $e');
       return {'encrypted': false};
     }
   }
   ```

**Expected Results**:
- ✅ Checksum verification is integrated with restore process
- ✅ Backup file integrity is verified before restore
- ✅ Corrupted backup files are detected
- ✅ Restore is prevented if checksum verification fails

**Testing**:
- Test restore with valid checksum
- Test restore with invalid checksum
- Test restore with corrupted backup file
- Verify checksum verification works correctly

---

### Task 7: Create Backup Retention Policy Service

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service for managing backup retention policies and auto-cleanup.

**Files to Create**:
- `lib/core/services/backup_retention_service.dart` (new file)
- `lib/core/constants/backup_constants.dart` (add retention constants)

**Dependencies**:
- `BackupService` for listing and deleting backups

**Implementation Steps**:

1. **Add retention policy constants**:
   ```dart
   // In lib/core/constants/backup_constants.dart
   class BackupRetentionPolicy {
     static const String keepLatestN = 'keep_latest_n';
     static const String keepByDateRange = 'keep_by_date_range';
     static const String keepAll = 'keep_all';
   }
   
   class BackupRetentionDefaults {
     static const int defaultRetentionDays = 90;
     static const int defaultKeepLatestN = 10;
   }
   ```

2. **Create BackupRetentionService**:
   ```dart
   // lib/core/services/backup_retention_service.dart
   import 'package:get/get.dart';
   import 'backup_service.dart';
   import 'storage_service.dart';
   import '../constants/backup_constants.dart';
   
   class BackupRetentionService {
     factory BackupRetentionService() => _instance ??= BackupRetentionService._();
     BackupRetentionService._();
     static BackupRetentionService? _instance;
     
     final BackupService _backupService = BackupService();
     final StorageService _storage = StorageService();
     
     static const String _retentionPolicyKey = 'backup_retention_policy';
     static const String _retentionDaysKey = 'backup_retention_days';
     static const String _keepLatestNKey = 'backup_keep_latest_n';
     static const String _autoCleanupEnabledKey = 'backup_auto_cleanup_enabled';
     
     /// Get retention policy
     Map<String, dynamic> getRetentionPolicy() {
       return {
         'policy': _storage.getString(_retentionPolicyKey) ?? BackupRetentionPolicy.keepByDateRange,
         'retentionDays': _storage.getInt(_retentionDaysKey) ?? BackupRetentionDefaults.defaultRetentionDays,
         'keepLatestN': _storage.getInt(_keepLatestNKey) ?? BackupRetentionDefaults.defaultKeepLatestN,
         'autoCleanupEnabled': _storage.getBool(_autoCleanupEnabledKey) ?? true,
       };
     }
     
     /// Set retention policy
     Future<void> setRetentionPolicy({
       String? policy,
       int? retentionDays,
       int? keepLatestN,
       bool? autoCleanupEnabled,
     }) async {
       if (policy != null) {
         await _storage.setString(_retentionPolicyKey, policy);
       }
       if (retentionDays != null) {
         await _storage.setInt(_retentionDaysKey, retentionDays);
       }
       if (keepLatestN != null) {
         await _storage.setInt(_keepLatestNKey, keepLatestN);
       }
       if (autoCleanupEnabled != null) {
         await _storage.setBool(_autoCleanupEnabledKey, autoCleanupEnabled);
       }
     }
     
     /// Cleanup old backups according to retention policy
     Future<void> cleanupOldBackups() async {
       try {
         final policy = getRetentionPolicy();
         
         if (!policy['autoCleanupEnabled']) {
           Get.log('Auto-cleanup is disabled');
           return;
         }
         
         final backups = await _backupService.listBackups();
         if (backups.isEmpty) {
           Get.log('No backups to cleanup');
           return;
         }
         
         List<Map<String, dynamic>> backupsToDelete = [];
         
         switch (policy['policy']) {
           case BackupRetentionPolicy.keepLatestN:
             backupsToDelete = _getBackupsToDeleteKeepLatestN(
               backups,
               policy['keepLatestN'],
             );
             break;
           case BackupRetentionPolicy.keepByDateRange:
             backupsToDelete = _getBackupsToDeleteByDateRange(
               backups,
               policy['retentionDays'],
             );
             break;
           case BackupRetentionPolicy.keepAll:
             Get.log('Retention policy is keep all, no cleanup needed');
             return;
           default:
             Get.log('Unknown retention policy: ${policy['policy']}');
             return;
         }
         
         // Delete old backups
         int deletedCount = 0;
         for (final backup in backupsToDelete) {
           try {
             await _backupService.deleteBackup(backup['id'] as String);
             deletedCount++;
             Get.log('Deleted backup: ${backup['name']}');
           } catch (e) {
             Get.log('ERROR: Failed to delete backup ${backup['id']}: $e');
           }
         }
         
         Get.log('Cleanup completed: $deletedCount backups deleted');
       } catch (e) {
         Get.log('ERROR: Cleanup failed: $e');
       }
     }
     
     /// Get backups to delete for "Keep Latest N" policy
     List<Map<String, dynamic>> _getBackupsToDeleteKeepLatestN(
       List<Map<String, dynamic>> backups,
       int keepLatestN,
     ) {
       // Sort backups by date (most recent first)
       backups.sort((a, b) {
         final dateA = _parseBackupDate(a);
         final dateB = _parseBackupDate(b);
         return dateB.compareTo(dateA);
       });
       
       // Keep latest N, delete the rest
       if (backups.length <= keepLatestN) {
         return [];
       }
       
       return backups.sublist(keepLatestN);
     }
     
     /// Get backups to delete for "Keep by Date Range" policy
     List<Map<String, dynamic>> _getBackupsToDeleteByDateRange(
       List<Map<String, dynamic>> backups,
       int retentionDays,
     ) {
       final cutoffDate = DateTime.now().subtract(Duration(days: retentionDays));
       
       return backups.where((backup) {
         final backupDate = _parseBackupDate(backup);
         return backupDate.isBefore(cutoffDate);
       }).toList();
     }
     
     /// Parse backup date from backup file
     DateTime _parseBackupDate(Map<String, dynamic> backup) {
       try {
         // Try to parse from file name (backup_YYYY-MM-DDTHH-MM-SS.json)
         final fileName = backup['name']?.toString() ?? '';
         final match = RegExp(r'backup_(\d{4}-\d{2}-\d{2}T\d{2}-\d{2}-\d{2})').firstMatch(fileName);
         if (match != null) {
           final dateString = match.group(1)!.replaceAll('-', ':');
           return DateTime.parse(dateString);
         }
         
         // Try to parse from createdDateTime or lastModifiedDateTime
         if (backup['createdDateTime'] != null) {
           return DateTime.parse(backup['createdDateTime'] as String);
         }
         if (backup['lastModifiedDateTime'] != null) {
           return DateTime.parse(backup['lastModifiedDateTime'] as String);
         }
         
         // Default to now if cannot parse
         return DateTime.now();
       } catch (e) {
         Get.log('ERROR: Failed to parse backup date: $e');
         return DateTime.now();
       }
     }
   }
   ```

3. **Add deleteBackup method to BackupService**:
   ```dart
   /// Delete backup file
   Future<void> deleteBackup(String fileId) async {
     try {
       await _oneDrive.deleteFile(fileId);
       
       // Also delete checksum if stored
       await _storage.remove('backup_checksum_$fileId');
       
       Get.log('Backup deleted: $fileId');
     } catch (e) {
       Get.log('ERROR: Failed to delete backup: $e');
       rethrow;
     }
   }
   ```

**Expected Results**:
- ✅ BackupRetentionService exists
- ✅ Retention policy can be configured
- ✅ Auto-cleanup works according to policy
- ✅ Old backups are deleted correctly

**Testing**:
- Test retention policy configuration
- Test "Keep Latest N" policy
- Test "Keep by Date Range" policy
- Test auto-cleanup
- Verify backups are deleted correctly

---

### Task 8: Add Scheduled Auto-Cleanup

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Add scheduled auto-cleanup to run periodically and clean up old backups.

**Files to Modify**:
- `lib/core/services/backup_retention_service.dart`
- `lib/core/services/backup_service.dart`
- `lib/app/app.dart` (initialize scheduled cleanup)

**Dependencies**:
- Task 7 (BackupRetentionService)

**Implementation Steps**:

1. **Add scheduled cleanup to BackupRetentionService**:
   ```dart
   // In lib/core/services/backup_retention_service.dart
   import 'dart:async';
   
   class BackupRetentionService {
     Timer? _cleanupTimer;
     
     /// Start scheduled auto-cleanup
     void startScheduledCleanup() {
       _cleanupTimer?.cancel();
       
       // Run cleanup daily at 2 AM
       _cleanupTimer = Timer.periodic(
         const Duration(hours: 24),
         (_) async {
           await _runScheduledCleanup();
         },
       );
       
       // Also run cleanup on startup (with delay)
       Future.delayed(const Duration(minutes: 5), () async {
         await _runScheduledCleanup();
       });
     }
     
     /// Stop scheduled auto-cleanup
     void stopScheduledCleanup() {
       _cleanupTimer?.cancel();
       _cleanupTimer = null;
     }
     
     /// Run scheduled cleanup
     Future<void> _runScheduledCleanup() async {
       final policy = getRetentionPolicy();
       if (!policy['autoCleanupEnabled']) {
         return;
       }
       
       try {
         Get.log('Running scheduled backup cleanup...');
         await cleanupOldBackups();
       } catch (e) {
         Get.log('ERROR: Scheduled cleanup failed: $e');
         // Don't throw - scheduled cleanup failure shouldn't break app
       }
     }
   }
   ```

2. **Initialize scheduled cleanup in app.dart**:
   ```dart
   // In lib/app/app.dart
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Backup Retention Service
     final backupRetentionService = BackupRetentionService();
     Get.put(backupRetentionService);
     
     // Start scheduled cleanup
     backupRetentionService.startScheduledCleanup();
   }
   ```

**Expected Results**:
- ✅ Scheduled auto-cleanup is implemented
- ✅ Cleanup runs periodically (daily)
- ✅ Cleanup runs on app startup (with delay)
- ✅ Cleanup can be started/stopped

**Testing**:
- Test scheduled cleanup runs
- Test cleanup on app startup
- Test cleanup can be stopped
- Verify cleanup respects retention policy

---

### Task 9: Add Retention Policy UI

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Add UI for configuring backup retention policy and auto-cleanup settings.

**Files to Create/Modify**:
- `lib/app/pages/backup/backup_retention_settings_page.dart` (new file)
- `lib/core/controllers/backup_retention_controller.dart` (new file)
- `lib/app/routes/app_router.dart` (add route)

**Dependencies**:
- Task 7 (BackupRetentionService)

**Implementation Steps**:

1. **Create BackupRetentionController**:
   ```dart
   // lib/core/controllers/backup_retention_controller.dart
   import 'package:get/get.dart';
   import '../services/backup_retention_service.dart';
   import '../constants/backup_constants.dart';
   
   class BackupRetentionController extends GetxController {
     final BackupRetentionService _retentionService = BackupRetentionService();
     
     final RxString _policy = BackupRetentionPolicy.keepByDateRange.obs;
     final RxInt _retentionDays = 90.obs;
     final RxInt _keepLatestN = 10.obs;
     final RxBool _autoCleanupEnabled = true.obs;
     
     String get policy => _policy.value;
     int get retentionDays => _retentionDays.value;
     int get keepLatestN => _keepLatestN.value;
     bool get autoCleanupEnabled => _autoCleanupEnabled.value;
     
     @override
     void onInit() {
       super.onInit();
       _loadRetentionPolicy();
     }
     
     void _loadRetentionPolicy() {
       final policy = _retentionService.getRetentionPolicy();
       _policy.value = policy['policy'];
       _retentionDays.value = policy['retentionDays'];
       _keepLatestN.value = policy['keepLatestN'];
       _autoCleanupEnabled.value = policy['autoCleanupEnabled'];
     }
     
     void setPolicy(String policy) {
       _policy.value = policy;
     }
     
     void setRetentionDays(int days) {
       _retentionDays.value = days;
     }
     
     void setKeepLatestN(int n) {
       _keepLatestN.value = n;
     }
     
     void setAutoCleanupEnabled(bool enabled) {
       _autoCleanupEnabled.value = enabled;
     }
     
     Future<void> saveRetentionPolicy() async {
       await _retentionService.setRetentionPolicy(
         policy: _policy.value,
         retentionDays: _retentionDays.value,
         keepLatestN: _keepLatestN.value,
         autoCleanupEnabled: _autoCleanupEnabled.value,
       );
     }
     
     Future<void> runCleanupNow() async {
       await _retentionService.cleanupOldBackups();
     }
   }
   ```

2. **Create BackupRetentionSettingsPage UI**:
   ```dart
   // lib/app/pages/backup/backup_retention_settings_page.dart
   // Implementation with:
   // - Policy selection (Keep Latest N, Keep by Date Range, Keep All)
   // - Retention days input (for date range policy)
   // - Keep Latest N input (for keep latest N policy)
   // - Auto-cleanup toggle
   // - Save button
   // - Run Cleanup Now button
   ```

**Expected Results**:
- ✅ BackupRetentionController exists
- ✅ BackupRetentionSettingsPage UI exists
- ✅ UI allows configuring retention policy
- ✅ UI allows enabling/disabling auto-cleanup
- ✅ UI allows running cleanup manually

**Testing**:
- Test UI displays current retention policy
- Test UI allows changing retention policy
- Test UI saves retention policy
- Test UI runs cleanup manually

---

## Summary

### Implementation Order:
1. **Task 1**: Add encryption package and create encryption service
2. **Task 2**: Integrate encryption with backup service
3. **Task 4**: Create checksum service
4. **Task 5**: Integrate checksum with backup service
5. **Task 3**: Integrate decryption with restore service
6. **Task 6**: Integrate checksum verification with restore service
7. **Task 7**: Create backup retention policy service
8. **Task 8**: Add scheduled auto-cleanup
9. **Task 9**: Add retention policy UI

### Estimated Total Time: 22-30 hours

### Dependencies:
- Task 1 is independent
- Task 2 depends on Task 1
- Task 3 depends on Tasks 1 and 2
- Task 4 is independent
- Task 5 depends on Task 4
- Task 6 depends on Tasks 4 and 5
- Task 7 is independent
- Task 8 depends on Task 7
- Task 9 depends on Task 7

### Testing Requirements:
- Unit tests for encryption/decryption
- Unit tests for checksum calculation/verification
- Unit tests for retention policy
- Unit tests for auto-cleanup
- Integration tests for complete backup/restore flow with security
- Manual testing with various security scenarios

### Success Criteria:
- ✅ Backup files are encrypted (AES-256)
- ✅ Backup files have checksum (SHA-256)
- ✅ Checksum verification works during restore
- ✅ Retention policy is configurable
- ✅ Auto-cleanup works according to policy
- ✅ Security measures don't break backup/restore functionality

### Security Considerations:
- **Critical**: Encryption and checksum are essential for backup security
- Encryption keys must be stored securely (Keychain/SecureStorage)
- Checksum must be verified before restore
- Retention policy must be enforced
- Auto-cleanup must be safe and logged
- Security measures should not break backup/restore functionality

# OneDrive Integration Setup Guide

## Overview
This document provides instructions for setting up OneDrive integration for the TodoList application to enable data backup and synchronization.

## Prerequisites
- Microsoft Azure account
- Azure AD application registration
- OneDrive for Business or Personal account
- Flutter development environment

## Setup Steps

### 1. Create Azure AD Application

#### Step 1: Register Application
1. Go to [Azure Portal](https://portal.azure.com/)
2. Navigate to "Azure Active Directory" > "App registrations"
3. Click "New registration"
4. Fill in the details:
   - **Name**: TodoList App
   - **Supported account types**: Accounts in any organizational directory and personal Microsoft accounts
   - **Redirect URI**: `msauth://com.kingnguyen.todolist` (for mobile)
5. Click "Register"

#### Step 2: Configure Authentication
1. Go to "Authentication" in your app registration
2. Add platform:
   - **Platform**: Mobile and desktop applications
   - **Redirect URI**: `msauth://com.kingnguyen.todolist`
3. Enable "Allow public client flows"
4. Save configuration

#### Step 3: Configure API Permissions
1. Go to "API permissions"
2. Click "Add a permission"
3. Select "Microsoft Graph"
4. Choose "Delegated permissions"
5. Add the following permissions:
   - `Files.ReadWrite` - Read and write user files
   - `User.Read` - Sign in and read user profile
   - `offline_access` - Maintain access to data you have given it access to
6. Click "Add permissions"
7. Grant admin consent if required

#### Step 4: Get Application Credentials
1. Go to "Overview" in your app registration
2. Copy the following values:
   - **Application (client) ID**
   - **Directory (tenant) ID**

### 2. Configure Flutter App

#### Update Configuration
Update `lib/app/constants/app_constants.dart`:

```dart
class AppConstants {
  // OneDrive Configuration
  static const String oneDriveClientId = 'your-client-id-here';
  static const String oneDriveTenantId = 'common'; // or your tenant ID
  static const String oneDriveScope = 'https://graph.microsoft.com/Files.ReadWrite';
}
```

#### Update Android Configuration
1. Open `android/app/src/main/AndroidManifest.xml`
2. Add the following inside `<application>` tag:

```xml
<activity
    android:name="com.microsoft.identity.client.BrowserTabActivity">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="msauth"
              android:host="com.kingnguyen.todolist" />
    </intent-filter>
</activity>
```

#### Update iOS Configuration
1. Open `ios/Runner/Info.plist`
2. Add the following inside `<dict>` tag:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>msauth</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>msauth://com.kingnguyen.todolist</string>
        </array>
    </dict>
</array>
```

### 3. Initialize OneDrive Service

#### Update App Initialization
Update `lib/app/app.dart`:

```dart
import '../core/services/onedrive_service.dart';

class AppInitializer {
  static Future<void> initialize() async {
    // ... existing initialization code ...
    
    // Initialize OneDrive service
    await OneDriveService.instance.initialize();
  }
}
```

### 4. Usage Examples

#### Authentication
```dart
final oneDriveService = OneDriveService.instance;

// Authenticate user
final isAuthenticated = await oneDriveService.authenticate();
if (isAuthenticated) {
  print('User authenticated successfully');
}
```

#### Backup Data
```dart
// Prepare data for backup
final appData = {
  'tasks': tasks,
  'reports': reports,
  'settings': settings,
  'timestamp': DateTime.now().toIso8601String(),
};

// Backup to OneDrive
try {
  final backupFile = await oneDriveService.backupAppData(appData);
  print('Backup created: ${backupFile['name']}');
} catch (e) {
  print('Backup failed: $e');
}
```

#### Restore Data
```dart
// List available backups
final backups = await oneDriveService.listBackupFiles();

// Restore from latest backup
if (backups.isNotEmpty) {
  final latestBackup = backups.first;
  final restoredData = await oneDriveService.restoreAppData(latestBackup['id']);
  print('Data restored successfully');
}
```

#### File Operations
```dart
// Create folder
final folder = await oneDriveService.createFolder('My Documents');

// Upload file
final fileContent = utf8.encode('Hello, OneDrive!');
final uploadedFile = await oneDriveService.uploadFile(
  'hello.txt',
  fileContent,
  parentId: folder['id'],
);

// Download file
final downloadedContent = await oneDriveService.downloadFile(uploadedFile['id']);
final content = utf8.decode(downloadedContent);
print(content); // Hello, OneDrive!

// List files
final files = await oneDriveService.listFiles();
for (final file in files) {
  print('File: ${file['name']}');
}
```

### 5. Error Handling

#### Common Errors and Solutions

**Authentication Errors**
```dart
try {
  await oneDriveService.authenticate();
} on AuthenticationException catch (e) {
  print('Authentication failed: ${e.message}');
  // Handle authentication error
} on UnauthorizedException catch (e) {
  print('Unauthorized: ${e.message}');
  // Handle unauthorized access
}
```

**Network Errors**
```dart
try {
  await oneDriveService.uploadFile('test.txt', content);
} on NetworkException catch (e) {
  print('Network error: ${e.message}');
  // Handle network issues
} on TimeoutException catch (e) {
  print('Request timeout: ${e.message}');
  // Handle timeout
}
```

**File Operation Errors**
```dart
try {
  await oneDriveService.createFolder('New Folder');
} on ServerException catch (e) {
  print('Server error: ${e.message}');
  // Handle server errors
} on OneDriveException catch (e) {
  print('OneDrive error: ${e.message}');
  // Handle OneDrive specific errors
}
```

### 6. Security Considerations

#### Data Protection
- All data is encrypted in transit using HTTPS
- OneDrive provides encryption at rest
- Access tokens are securely stored by MSAL
- Regular token refresh ensures security

#### Permissions
- Use minimal required permissions
- Regularly review and audit permissions
- Implement proper error handling for permission denied scenarios

#### Best Practices
- Never store access tokens in plain text
- Implement proper session management
- Use secure communication channels
- Regular security updates

### 7. Testing

#### Unit Tests
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('OneDriveService Tests', () {
    test('should authenticate user successfully', () async {
      // Mock authentication
      // Test authentication flow
    });

    test('should backup data successfully', () async {
      // Mock backup operation
      // Test backup functionality
    });
  });
}
```

#### Integration Tests
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('OneDrive integration test', (WidgetTester tester) async {
    // Test complete OneDrive workflow
    // Authentication -> Backup -> Restore
  });
}
```

### 8. Troubleshooting

#### Common Issues

**Authentication Fails**
- Check client ID and tenant ID
- Verify redirect URI configuration
- Ensure proper permissions are granted
- Check network connectivity

**File Upload Fails**
- Verify file size limits
- Check available storage space
- Ensure proper file permissions
- Validate file format

**API Errors**
- Check API permissions
- Verify token validity
- Review rate limiting
- Check service status

#### Debug Mode
Enable debug logging:

```dart
// Enable MSAL debug logging
await PublicClientApplication.createPublicClientApplication(
  config,
  enableLogging: true,
);
```

### 9. Production Considerations

#### Performance
- Implement proper caching
- Use batch operations when possible
- Optimize file sizes
- Monitor API usage

#### Monitoring
- Track authentication success rates
- Monitor backup/restore operations
- Log error rates and types
- Set up alerts for failures

#### Backup Strategy
- Implement automatic backups
- Schedule regular backups
- Maintain backup history
- Test restore procedures

## Support

### Documentation
- [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/)
- [MSAL Flutter](https://pub.dev/packages/msal_flutter)
- [OneDrive API](https://docs.microsoft.com/en-us/onedrive/developer/)

### Community
- [Microsoft Graph Community](https://techcommunity.microsoft.com/t5/microsoft-365-developer/ct-p/Microsoft365Developer)
- [Flutter Community](https://flutter.dev/community)

### Support Channels
- [Microsoft Support](https://support.microsoft.com/)
- [Azure Support](https://azure.microsoft.com/en-us/support/)

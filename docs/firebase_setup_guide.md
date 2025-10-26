# Firebase Setup Guide for Todolist App

## Prerequisites ✅
- Firebase CLI installed: `firebase-tools@14.18.0`
- FlutterFire CLI installed: `flutterfire_cli@1.3.1`
- Bundle ID updated to: `com.kingnguyen.todolist`

## Step 1: Create Firebase Project

### 1.1 Login to Firebase
```bash
firebase login
```
This will open a browser window for authentication.

### 1.2 Create New Project
```bash
firebase projects:create todolist-app-kingnguyen
```
Or create manually at: https://console.firebase.google.com/

**Project Settings:**
- Project Name: `todolist-app-kingnguyen`
- Project ID: `todolist-app-kingnguyen` (or similar)
- Enable Google Analytics: Yes (recommended)

## Step 2: Configure Firebase Services

### 2.1 Enable Authentication
1. Go to Firebase Console → Authentication → Sign-in method
2. Enable the following providers:
   - **Email/Password**: Enable
   - **Google**: Enable (for Google Sign-In)
   - **Anonymous**: Enable (optional)

### 2.2 Create Realtime Database
1. Go to Firebase Console → Realtime Database
2. Click "Create Database"
3. Choose "Start in production mode"
4. Select location closest to your users
5. Note the database URL (e.g., `https://todolist-app-kingnguyen-default-rtdb.firebaseio.com/`)

### 2.3 Enable Cloud Messaging
1. Go to Firebase Console → Cloud Messaging
2. No additional setup required for basic functionality

### 2.4 Enable Analytics
1. Go to Firebase Console → Analytics
2. Enable Google Analytics
3. Link to Google Analytics account (optional)

## Step 3: Add Apps to Firebase Project

### 3.1 Add Android App
1. Go to Project Settings → General
2. Click "Add app" → Android
3. **Package name**: `com.kingnguyen.todolist`
4. **App nickname**: `Todolist Android`
5. **Debug signing certificate SHA-1**: (optional for now)
6. Download `google-services.json`
7. Place in: `android/app/google-services.json`

### 3.2 Add iOS App
1. Click "Add app" → iOS
2. **Bundle ID**: `com.kingnguyen.todolist`
3. **App nickname**: `Todolist iOS`
4. **App Store ID**: (leave blank for now)
5. Download `GoogleService-Info.plist`
6. Place in: `ios/Runner/GoogleService-Info.plist`

### 3.3 Add Web App
1. Click "Add app" → Web
2. **App nickname**: `Todolist Web`
3. **Firebase Hosting**: Enable (optional)
4. Copy the configuration object

## Step 4: Configure Flutter App

### 4.1 Run FlutterFire Configuration
```bash
# Make sure you're in the project root
cd /Users/quangnt/Desktop/Projects/Private/totolist

# Configure Firebase for all platforms
flutterfire configure --project=todolist-app-kingnguyen
```

This will:
- Update `lib/firebase_options.dart` with actual configuration
- Ensure all platform configurations are correct

### 4.2 Verify Configuration Files
After running `flutterfire configure`, verify these files exist:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart` (updated with real values)

## Step 5: Update Security Rules

### 5.1 Database Rules
Update `firebase_database_rules.json` with your project-specific rules:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "companies": {
      "$workspaceId": {
        ".read": "auth != null && (data.child('members').child(auth.uid).exists() || data.child('admins').child(auth.uid).exists())",
        ".write": "auth != null && data.child('admins').child(auth.uid).exists()"
      }
    },
    "tasks": {
      "$taskId": {
        ".read": "auth != null && (data.child('assignedTo').child(auth.uid).exists() || data.child('createdBy').val() === auth.uid)",
        ".write": "auth != null && (data.child('assignedTo').child(auth.uid).exists() || data.child('createdBy').val() === auth.uid)"
      }
    }
  }
}
```

### 5.2 Deploy Rules
```bash
firebase deploy --only database
```

## Step 6: Test Configuration

### 6.1 Run the App
```bash
flutter run
```

### 6.2 Verify Firebase Connection
Check that:
- App starts without Firebase errors
- Authentication is accessible
- Database connection is established
- No configuration errors in console

## Step 7: Environment Setup

### 7.1 Update Documentation
Update these files with your actual project details:
- `docs/FIREBASE_SETUP.md`
- `scripts/firebase_setup.sh`

### 7.2 Add to .gitignore
Ensure these files are in `.gitignore`:
```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
.firebase/
```

## Troubleshooting

### Common Issues:
1. **Bundle ID mismatch**: Ensure all platforms use `com.kingnguyen.todolist`
2. **Missing configuration files**: Re-run `flutterfire configure`
3. **Authentication errors**: Check API keys and authorized domains
4. **Database access denied**: Verify security rules

### Debug Commands:
```bash
# Check Firebase project
firebase projects:list

# Check app configuration
firebase apps:list --project=todolist-app-kingnguyen

# Test database rules
firebase database:rules:test --project=todolist-app-kingnguyen
```

## Next Steps

After completing this setup:
1. Test user authentication
2. Test database read/write operations
3. Configure push notifications (if needed)
4. Set up CI/CD with Firebase (optional)
5. Configure monitoring and alerts

## Support

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)

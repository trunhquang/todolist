# Firebase Setup Guide

## Overview
This document provides instructions for setting up Firebase for the TodoList application.

## Prerequisites
- Firebase CLI installed (`npm install -g firebase-tools`)
- FlutterFire CLI installed (`dart pub global activate flutterfire_cli`)
- Google account with Firebase access

## Setup Steps

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `todolist-app`
4. Enable Google Analytics (optional)
5. Create project

### 2. Enable Required Services

#### Authentication
1. Go to Authentication > Sign-in method
2. Enable Email/Password
3. Enable Google Sign-In
4. Configure authorized domains

#### Realtime Database
1. Go to Realtime Database
2. Create database in production mode
3. Set location (choose closest to your users)
4. Copy database URL

#### Cloud Messaging
1. Go to Cloud Messaging
2. No additional setup required for basic functionality

#### Analytics
1. Go to Analytics
2. Enable Google Analytics
3. Link to Google Analytics account (optional)

### 3. Configure Flutter App

#### Android Configuration
1. Go to Project Settings > General
2. Add Android app
3. Enter package name: `com.example.todolist`
4. Download `google-services.json`
5. Place in `android/app/` directory

#### iOS Configuration
1. Add iOS app in Project Settings
2. Enter bundle ID: `com.example.todolist`
3. Download `GoogleService-Info.plist`
4. Add to Xcode project

#### Web Configuration
1. Add web app in Project Settings
2. Register app
3. Copy configuration object

### 4. Update Firebase Options
Update `lib/firebase_options.dart` with your actual configuration:

```dart
// Replace placeholder values with actual values from Firebase Console
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-web-api-key',
  appId: '1:123456789:web:your-actual-web-app-id',
  messagingSenderId: '123456789',
  projectId: 'todolist-app',
  authDomain: 'todolist-app.firebaseapp.com',
  databaseURL: 'https://todolist-app-default-rtdb.firebaseio.com',
  storageBucket: 'todolist-app.appspot.com',
  measurementId: 'G-XXXXXXXXXX',
);
```

### 5. Deploy Security Rules
```bash
firebase deploy --only database
```

### 6. Test Configuration
Run the app and verify:
- Firebase initialization works
- Authentication is accessible
- Database connection is established

## Security Rules

The application uses role-based access control with the following roles:
- **Company Admin**: Full access to company data
- **Department Admin**: Access to department data
- **User**: Access to assigned tasks and personal data

## Environment Variables

For production deployment, consider using environment variables for sensitive configuration:

```bash
# .env file
FIREBASE_API_KEY=your-api-key
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_DATABASE_URL=your-database-url
```

## Troubleshooting

### Common Issues
1. **Authentication not working**: Check API keys and authorized domains
2. **Database access denied**: Verify security rules and user permissions
3. **Build errors**: Ensure all configuration files are in correct locations

### Debug Mode
Enable debug logging:
```dart
FirebaseDatabase.instance.setLoggingEnabled(true);
```

## Production Considerations

1. **Security Rules**: Review and test all security rules thoroughly
2. **API Keys**: Use environment variables for production
3. **Database Rules**: Implement proper indexing for performance
4. **Monitoring**: Set up Firebase monitoring and alerts
5. **Backup**: Configure automated database backups

## Support

For Firebase-specific issues, refer to:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Support](https://firebase.google.com/support)

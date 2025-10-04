# Firebase Services Setup Guide

## Current Status
✅ Firebase project created: `todolist-kingnguyen`  
✅ Apps configured with bundle ID: `com.kingnguyen.todolist`  
✅ Configuration files downloaded and placed  
✅ Firebase initialization working  

## Required: Enable Firebase Services

The app is currently experiencing Firebase Messaging errors because the services haven't been enabled in the Firebase Console yet.

### Step 1: Enable Authentication
1. Go to [Firebase Console](https://console.firebase.google.com/project/todolist-kingnguyen/overview)
2. Navigate to **Authentication** → **Sign-in method**
3. Enable the following providers:
   - **Email/Password**: Click "Enable" and save
   - **Google** (optional): Click "Enable" and configure

### Step 2: Create Realtime Database
1. Go to **Realtime Database**
2. Click **"Create Database"**
3. Choose **"Start in production mode"**
4. Select location: **us-central1** (recommended)
5. Click **"Done"**

### Step 3: Enable Cloud Messaging
1. Go to **Cloud Messaging**
2. No additional setup required for basic functionality
3. The service is automatically enabled when you create the project

### Step 4: Enable Analytics (Optional)
1. Go to **Analytics** → **Dashboard**
2. Click **"Enable Google Analytics"**
3. Choose or create a Google Analytics account
4. Click **"Enable"**

## After Enabling Services

Once you've enabled the services in the Firebase Console:

1. **Restart the app** to test Firebase Messaging
2. **Check the console logs** for FCM token generation
3. **Test authentication** if you've enabled it

## Troubleshooting

### If you still see Firebase Messaging errors:
1. **Wait 5-10 minutes** after enabling services (propagation time)
2. **Clean and rebuild** the app:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
3. **Check Firebase Console** to ensure services are properly enabled

### Common Issues:
- **"Unknown error"**: Usually means the service isn't enabled yet
- **"Permission denied"**: Check that the app has the correct bundle ID
- **"Network error"**: Ensure you have internet connection

## Next Steps

After enabling Firebase services:
1. Test user authentication
2. Test database read/write operations  
3. Test push notifications
4. Configure security rules for production

## Support

- [Firebase Console](https://console.firebase.google.com/project/todolist-kingnguyen/overview)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)

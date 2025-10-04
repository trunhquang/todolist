#!/bin/bash

# Firebase Setup Script for Todolist App
# This script helps set up Firebase configuration for iOS

echo "🔥 Firebase Setup for Todolist App"
echo "=================================="

# Check if GoogleService-Info.plist exists
GOOGLE_SERVICE_FILE="ios/Runner/GoogleService-Info.plist"

if [ ! -f "$GOOGLE_SERVICE_FILE" ]; then
    echo "❌ GoogleService-Info.plist not found!"
    echo ""
    echo "📋 Please follow these steps:"
    echo "1. Go to https://console.firebase.google.com/"
    echo "2. Create a new project or select existing one"
    echo "3. Add an iOS app with bundle ID: com.kingnguyen.todolist"
    echo "4. Download GoogleService-Info.plist"
    echo "5. Place it in: ios/Runner/GoogleService-Info.plist"
    echo ""
    echo "After downloading the file, run this script again."
    exit 1
fi

echo "✅ GoogleService-Info.plist found!"

# Check if FlutterFire CLI is installed
if ! command -v flutterfire &> /dev/null; then
    echo "📦 Installing FlutterFire CLI..."
    dart pub global activate flutterfire_cli
fi

echo "🔄 Configuring Firebase..."
flutterfire configure --project=your-firebase-project-id

echo "✅ Firebase configuration complete!"
echo ""
echo "🚀 You can now run your app with:"
echo "   flutter run"


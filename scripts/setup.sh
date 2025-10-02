#!/bin/bash

# TodoList App Setup Script
# This script sets up the development environment for the TodoList Flutter app

set -e

echo "🚀 Setting up TodoList development environment..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter version
echo "📱 Checking Flutter version..."
flutter --version

# Get Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

# Generate code (if needed)
echo "🔧 Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check for any issues
echo "🔍 Running Flutter doctor..."
flutter doctor

# Set up Git hooks (if .git directory exists)
if [ -d ".git" ]; then
    echo "🔗 Setting up Git hooks..."
    
    # Create pre-commit hook
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Running pre-commit checks..."

# Run Flutter analyze
echo "Running Flutter analyze..."
flutter analyze

# Run tests
echo "Running tests..."
flutter test

echo "Pre-commit checks passed! ✅"
EOF

    chmod +x .git/hooks/pre-commit
    echo "✅ Git pre-commit hook installed"
fi

# Create environment file template
if [ ! -f ".env.example" ]; then
    echo "📝 Creating environment file template..."
    cat > .env.example << 'EOF'
# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_DATABASE_URL=your-database-url
FIREBASE_STORAGE_BUCKET=your-storage-bucket

# OneDrive Configuration
ONEDRIVE_CLIENT_ID=your-client-id
ONEDRIVE_TENANT_ID=common
ONEDRIVE_SCOPE=https://graph.microsoft.com/Files.ReadWrite

# App Configuration
APP_ENV=development
DEBUG_MODE=true
EOF
    echo "✅ Environment template created (.env.example)"
fi

# Create local config template
if [ ! -f "lib/config/local_config.dart" ]; then
    echo "📝 Creating local config template..."
    mkdir -p lib/config
    cat > lib/config/local_config.dart << 'EOF'
// Local configuration file
// Copy this file and rename to local_config.dart
// Add your local configuration here

class LocalConfig {
  // Firebase Configuration
  static const String firebaseProjectId = 'your-project-id';
  static const String firebaseApiKey = 'your-api-key';
  static const String firebaseDatabaseUrl = 'your-database-url';
  static const String firebaseStorageBucket = 'your-storage-bucket';
  
  // OneDrive Configuration
  static const String oneDriveClientId = 'your-client-id';
  static const String oneDriveTenantId = 'common';
  static const String oneDriveScope = 'https://graph.microsoft.com/Files.ReadWrite';
  
  // App Configuration
  static const String appEnvironment = 'development';
  static const bool debugMode = true;
}
EOF
    echo "✅ Local config template created"
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Copy .env.example to .env and fill in your configuration"
echo "2. Copy lib/config/local_config.dart and update with your values"
echo "3. Set up Firebase project and add configuration files"
echo "4. Run 'flutter run' to start the app"
echo ""
echo "For more information, see the documentation in the docs/ folder."

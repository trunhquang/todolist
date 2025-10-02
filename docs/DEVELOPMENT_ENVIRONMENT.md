# Development Environment Setup

## Overview
This document provides comprehensive instructions for setting up the development environment for the TodoList Flutter application.

## Prerequisites

### Required Software
- **Flutter SDK**: Version 3.16.0 or higher
- **Dart SDK**: Version 3.6.0 or higher (included with Flutter)
- **Git**: For version control
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA

### Platform-Specific Requirements

#### Android Development
- **Android Studio**: Latest version
- **Android SDK**: API level 21 or higher
- **Java Development Kit (JDK)**: Version 11 or higher

#### iOS Development (macOS only)
- **Xcode**: Version 14.0 or higher
- **iOS Simulator**: Latest version
- **CocoaPods**: For iOS dependencies

#### Web Development
- **Chrome**: For web testing
- **Web server**: For local development

## Installation Steps

### 1. Install Flutter
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

### 2. Install IDE Extensions

#### VS Code Extensions
- Flutter
- Dart
- Flutter Widget Snippets
- Bracket Pair Colorizer
- GitLens
- Error Lens

#### Android Studio Plugins
- Flutter
- Dart
- Flutter Intl

### 3. Configure Development Tools

#### Git Configuration
```bash
# Set up Git user
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set up Git hooks
chmod +x scripts/setup.sh
./scripts/setup.sh
```

#### Environment Variables
Create a `.env` file in the project root:
```bash
# Copy template
cp .env.example .env

# Edit with your configuration
nano .env
```

## Project Setup

### 1. Clone Repository
```bash
git clone <repository-url>
cd totolist
```

### 2. Run Setup Script
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Run setup script
./scripts/setup.sh
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Generate Code
```bash
flutter packages pub run build_runner build
```

## Development Workflow

### Running the App
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

### Testing
```bash
# Run all tests
./scripts/test.sh

# Run specific test types
./scripts/test.sh -u  # Unit tests only
./scripts/test.sh -w  # Widget tests only
./scripts/test.sh -i  # Integration tests only

# Run with coverage
./scripts/test.sh -c
```

### Building
```bash
# Build for Android
./scripts/build.sh -p android -m release

# Build for iOS
./scripts/build.sh -p ios -m release

# Build for Web
./scripts/build.sh -p web -m release

# Build for all platforms
./scripts/build.sh -p all -m release
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Fix linting issues
dart fix --apply
```

## Configuration Files

### Firebase Configuration
1. Create Firebase project
2. Add configuration files:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - Update `lib/firebase_options.dart`

### OneDrive Configuration
1. Register app in Azure AD
2. Update configuration in `lib/config/local_config.dart`
3. Add credentials to environment variables

## Development Tools

### Debugging
- **Flutter Inspector**: Built into IDEs
- **Dart DevTools**: For performance profiling
- **Firebase Console**: For backend debugging

### Testing Tools
- **Flutter Test**: Unit and widget tests
- **Integration Test**: End-to-end testing
- **Golden Tests**: UI regression testing

### Code Generation
- **build_runner**: For code generation
- **json_annotation**: For JSON serialization
- **hive_generator**: For local storage

## Troubleshooting

### Common Issues

#### Flutter Doctor Issues
```bash
# Fix Android license issues
flutter doctor --android-licenses

# Update Flutter
flutter upgrade

# Clean and reinstall
flutter clean
flutter pub get
```

#### Build Issues
```bash
# Clean build
flutter clean
rm -rf build/
flutter pub get

# Rebuild
flutter build apk
```

#### Dependency Issues
```bash
# Update dependencies
flutter pub upgrade

# Check for conflicts
flutter pub deps
```

### Platform-Specific Issues

#### Android
- Ensure Android SDK is properly installed
- Check Android license acceptance
- Verify device/emulator is running

#### iOS
- Ensure Xcode is up to date
- Check iOS Simulator is installed
- Verify provisioning profiles

#### Web
- Ensure Chrome is installed
- Check web server configuration
- Verify CORS settings

## Performance Optimization

### Build Performance
- Use `--split-debug-info` for smaller builds
- Enable R8/ProGuard for Android
- Use `--tree-shake-icons` for unused icons

### Runtime Performance
- Profile with DevTools
- Use `const` constructors
- Implement proper state management

## Security Considerations

### API Keys
- Never commit API keys to version control
- Use environment variables
- Implement proper key rotation

### Firebase Security
- Review security rules regularly
- Test authentication flows
- Monitor for suspicious activity

## Continuous Integration

### GitHub Actions
```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test
```

### Pre-commit Hooks
- Code formatting
- Linting
- Testing
- Security scanning

## Documentation

### Code Documentation
- Use DartDoc comments
- Document public APIs
- Include examples

### API Documentation
- Document endpoints
- Include request/response examples
- Version documentation

## Support

### Getting Help
- Check Flutter documentation
- Review project documentation
- Ask team members
- Use Stack Overflow

### Reporting Issues
- Use GitHub issues
- Include reproduction steps
- Provide environment details
- Attach relevant logs

## Best Practices

### Code Organization
- Follow Clean Architecture
- Use proper naming conventions
- Implement proper error handling
- Write comprehensive tests

### Git Workflow
- Use feature branches
- Write descriptive commit messages
- Review code before merging
- Keep commits atomic

### Performance
- Profile regularly
- Optimize images
- Use lazy loading
- Implement caching

### Security
- Validate all inputs
- Use HTTPS
- Implement proper authentication
- Regular security audits

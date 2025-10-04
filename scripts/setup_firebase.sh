#!/bin/bash

# Firebase Setup Script for Todolist App
# This script helps set up Firebase configuration for all platforms

set -e  # Exit on any error

echo "🔥 Firebase Setup for Todolist App"
echo "=================================="
echo "Bundle ID: com.kingnguyen.todolist"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command -v firebase &> /dev/null; then
        print_error "Firebase CLI not found. Please install it first:"
        echo "npm install -g firebase-tools"
        exit 1
    fi
    
    if ! command -v flutterfire &> /dev/null; then
        print_error "FlutterFire CLI not found. Please install it first:"
        echo "dart pub global activate flutterfire_cli"
        echo "export PATH=\"\$PATH\":\"\$HOME/.pub-cache/bin\""
        exit 1
    fi
    
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter not found. Please install Flutter first."
        exit 1
    fi
    
    print_success "All prerequisites are installed!"
}

# Check if user is logged into Firebase
check_firebase_login() {
    print_status "Checking Firebase authentication..."
    
    if ! firebase projects:list &> /dev/null; then
        print_warning "Not logged into Firebase. Please run:"
        echo "firebase login"
        echo ""
        echo "After logging in, run this script again."
        exit 1
    fi
    
    print_success "Firebase authentication verified!"
}

# List available Firebase projects
list_firebase_projects() {
    print_status "Available Firebase projects:"
    firebase projects:list
    echo ""
}

# Create new Firebase project
create_firebase_project() {
    local project_id="todolist-app-kingnguyen"
    
    print_status "Creating Firebase project: $project_id"
    
    if firebase projects:create "$project_id" --display-name "Todolist App - King Nguyen"; then
        print_success "Firebase project created successfully!"
    else
        print_warning "Project might already exist or creation failed."
        print_status "Please check the Firebase Console: https://console.firebase.google.com/"
    fi
}

# Check configuration files
check_config_files() {
    print_status "Checking configuration files..."
    
    local android_config="android/app/google-services.json"
    local ios_config="ios/Runner/GoogleService-Info.plist"
    
    if [ ! -f "$android_config" ]; then
        print_warning "Android configuration file not found: $android_config"
        echo "Please download google-services.json from Firebase Console and place it in android/app/"
    else
        print_success "Android configuration file found!"
    fi
    
    if [ ! -f "$ios_config" ]; then
        print_warning "iOS configuration file not found: $ios_config"
        echo "Please download GoogleService-Info.plist from Firebase Console and place it in ios/Runner/"
    else
        print_success "iOS configuration file found!"
    fi
}

# Run FlutterFire configuration
configure_flutterfire() {
    local project_id="todolist-app-kingnguyen"
    
    print_status "Configuring FlutterFire..."
    print_warning "This will update lib/firebase_options.dart with actual configuration values."
    
    read -p "Do you want to proceed? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if flutterfire configure --project="$project_id"; then
            print_success "FlutterFire configuration completed!"
        else
            print_error "FlutterFire configuration failed. Please check the project ID and try again."
        fi
    else
        print_warning "FlutterFire configuration skipped."
    fi
}

# Deploy database rules
deploy_database_rules() {
    print_status "Deploying database security rules..."
    
    if [ -f "firebase_database_rules.json" ]; then
        if firebase deploy --only database; then
            print_success "Database rules deployed successfully!"
        else
            print_error "Failed to deploy database rules."
        fi
    else
        print_warning "firebase_database_rules.json not found. Skipping rules deployment."
    fi
}

# Test Firebase connection
test_firebase_connection() {
    print_status "Testing Firebase connection..."
    
    print_warning "Please run the following command to test your Firebase setup:"
    echo "flutter run"
    echo ""
    echo "Check the console for any Firebase-related errors."
}

# Main execution
main() {
    echo "Starting Firebase setup process..."
    echo ""
    
    check_prerequisites
    check_firebase_login
    list_firebase_projects
    
    echo "Choose an option:"
    echo "1. Create new Firebase project"
    echo "2. Use existing project (configure FlutterFire)"
    echo "3. Check configuration files only"
    echo "4. Deploy database rules only"
    echo "5. Full setup (create project + configure)"
    echo ""
    
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            create_firebase_project
            ;;
        2)
            configure_flutterfire
            ;;
        3)
            check_config_files
            ;;
        4)
            deploy_database_rules
            ;;
        5)
            create_firebase_project
            check_config_files
            configure_flutterfire
            deploy_database_rules
            ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
    
    test_firebase_connection
    
    echo ""
    print_success "Firebase setup process completed!"
    echo ""
    echo "Next steps:"
    echo "1. Download configuration files from Firebase Console if not already done"
    echo "2. Run 'flutter run' to test the setup"
    echo "3. Check the Firebase Console for any additional configuration needed"
    echo ""
    echo "For detailed instructions, see: scripts/firebase_setup_guide.md"
}

# Run main function
main "$@"

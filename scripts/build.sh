#!/bin/bash

# TodoList App Build Script
# This script builds the app for different platforms

set -e

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

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --platform PLATFORM    Target platform (android, ios, web, all)"
    echo "  -m, --mode MODE            Build mode (debug, release, profile)"
    echo "  -c, --clean                Clean build before building"
    echo "  -t, --test                 Run tests before building"
    echo "  -h, --help                 Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -p android -m release"
    echo "  $0 -p ios -m debug -c"
    echo "  $0 -p all -m release -t"
}

# Default values
PLATFORM=""
MODE="debug"
CLEAN=false
TEST=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -m|--mode)
            MODE="$2"
            shift 2
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -t|--test)
            TEST=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate platform
if [[ -z "$PLATFORM" ]]; then
    print_error "Platform is required"
    show_usage
    exit 1
fi

if [[ "$PLATFORM" != "android" && "$PLATFORM" != "ios" && "$PLATFORM" != "web" && "$PLATFORM" != "all" ]]; then
    print_error "Invalid platform: $PLATFORM"
    print_error "Valid platforms: android, ios, web, all"
    exit 1
fi

# Validate mode
if [[ "$MODE" != "debug" && "$MODE" != "release" && "$MODE" != "profile" ]]; then
    print_error "Invalid mode: $MODE"
    print_error "Valid modes: debug, release, profile"
    exit 1
fi

print_status "Starting build process..."
print_status "Platform: $PLATFORM"
print_status "Mode: $MODE"
print_status "Clean: $CLEAN"
print_status "Test: $TEST"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed"
    exit 1
fi

# Run tests if requested
if [[ "$TEST" == true ]]; then
    print_status "Running tests..."
    flutter test
    if [[ $? -eq 0 ]]; then
        print_success "Tests passed"
    else
        print_error "Tests failed"
        exit 1
    fi
fi

# Clean if requested
if [[ "$CLEAN" == true ]]; then
    print_status "Cleaning build..."
    flutter clean
    flutter pub get
fi

# Build function for specific platform
build_platform() {
    local platform=$1
    local mode=$2
    
    print_status "Building for $platform in $mode mode..."
    
    case $platform in
        android)
            if [[ "$mode" == "release" ]]; then
                flutter build apk --release
            elif [[ "$mode" == "profile" ]]; then
                flutter build apk --profile
            else
                flutter build apk --debug
            fi
            ;;
        ios)
            if [[ "$mode" == "release" ]]; then
                flutter build ios --release
            elif [[ "$mode" == "profile" ]]; then
                flutter build ios --profile
            else
                flutter build ios --debug
            fi
            ;;
        web)
            if [[ "$mode" == "release" ]]; then
                flutter build web --release
            elif [[ "$mode" == "profile" ]]; then
                flutter build web --profile
            else
                flutter build web --debug
            fi
            ;;
    esac
    
    if [[ $? -eq 0 ]]; then
        print_success "Build completed for $platform"
    else
        print_error "Build failed for $platform"
        exit 1
    fi
}

# Build for specified platform(s)
if [[ "$PLATFORM" == "all" ]]; then
    build_platform "android" "$MODE"
    build_platform "ios" "$MODE"
    build_platform "web" "$MODE"
else
    build_platform "$PLATFORM" "$MODE"
fi

print_success "Build process completed successfully!"
print_status "Build artifacts are available in the build/ directory"

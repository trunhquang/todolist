#!/bin/bash

# TodoList App Test Script
# This script runs various tests for the TodoList Flutter app

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
    echo "  -u, --unit                 Run unit tests only"
    echo "  -w, --widget               Run widget tests only"
    echo "  -i, --integration          Run integration tests only"
    echo "  -a, --all                  Run all tests (default)"
    echo "  -c, --coverage             Generate coverage report"
    echo "  -v, --verbose              Verbose output"
    echo "  -h, --help                 Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -u -c"
    echo "  $0 -w -v"
    echo "  $0 -a -c"
}

# Default values
UNIT=false
WIDGET=false
INTEGRATION=false
ALL=true
COVERAGE=false
VERBOSE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--unit)
            UNIT=true
            ALL=false
            shift
            ;;
        -w|--widget)
            WIDGET=true
            ALL=false
            shift
            ;;
        -i|--integration)
            INTEGRATION=true
            ALL=false
            shift
            ;;
        -a|--all)
            ALL=true
            shift
            ;;
        -c|--coverage)
            COVERAGE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
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

print_status "Starting test process..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed"
    exit 1
fi

# Prepare test command
TEST_CMD="flutter test"
if [[ "$COVERAGE" == true ]]; then
    TEST_CMD="$TEST_CMD --coverage"
fi

if [[ "$VERBOSE" == true ]]; then
    TEST_CMD="$TEST_CMD --verbose"
fi

# Run unit tests
if [[ "$UNIT" == true || "$ALL" == true ]]; then
    print_status "Running unit tests..."
    if [[ "$COVERAGE" == true ]]; then
        $TEST_CMD test/unit/
    else
        flutter test test/unit/
    fi
    
    if [[ $? -eq 0 ]]; then
        print_success "Unit tests passed"
    else
        print_error "Unit tests failed"
        exit 1
    fi
fi

# Run widget tests
if [[ "$WIDGET" == true || "$ALL" == true ]]; then
    print_status "Running widget tests..."
    if [[ "$COVERAGE" == true ]]; then
        $TEST_CMD test/widget/
    else
        flutter test test/widget/
    fi
    
    if [[ $? -eq 0 ]]; then
        print_success "Widget tests passed"
    else
        print_error "Widget tests failed"
        exit 1
    fi
fi

# Run integration tests
if [[ "$INTEGRATION" == true || "$ALL" == true ]]; then
    print_status "Running integration tests..."
    flutter test integration_test/
    
    if [[ $? -eq 0 ]]; then
        print_success "Integration tests passed"
    else
        print_error "Integration tests failed"
        exit 1
    fi
fi

# Generate coverage report if requested
if [[ "$COVERAGE" == true ]]; then
    print_status "Generating coverage report..."
    
    # Check if lcov is installed
    if command -v lcov &> /dev/null; then
        # Generate HTML coverage report
        genhtml coverage/lcov.info -o coverage/html
        print_success "Coverage report generated in coverage/html/"
    else
        print_warning "lcov is not installed. Install it to generate HTML coverage reports."
        print_status "Coverage data is available in coverage/lcov.info"
    fi
fi

# Run Flutter analyze
print_status "Running Flutter analyze..."
flutter analyze

if [[ $? -eq 0 ]]; then
    print_success "Code analysis passed"
else
    print_warning "Code analysis found issues"
fi

print_success "Test process completed successfully!"

if [[ "$COVERAGE" == true ]]; then
    print_status "Coverage report available in coverage/ directory"
fi

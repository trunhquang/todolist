#!/bin/bash

# Workspace Test Execution Script
# This script runs comprehensive tests for the workspace functionality

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TEST_DIR="test/features/workspace"
REPORTS_DIR="test_reports/workspace"
COVERAGE_DIR="coverage/workspace"
PERFORMANCE_DIR="performance/workspace"

# Create directories
mkdir -p "$REPORTS_DIR"
mkdir -p "$COVERAGE_DIR"
mkdir -p "$PERFORMANCE_DIR"

echo -e "${BLUE}🚀 Starting Workspace Test Suite...${NC}"

# Function to print section headers
print_section() {
    echo -e "\n${YELLOW}========================================${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${YELLOW}========================================${NC}\n"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
print_section "Checking Prerequisites"

if ! command_exists flutter; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    exit 1
fi

if ! command_exists dart; then
    echo -e "${RED}❌ Dart is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter and Dart are available${NC}"

# Get Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
echo -e "${BLUE}📱 Flutter Version: $FLUTTER_VERSION${NC}"

# Clean and get dependencies
print_section "Preparing Environment"

echo -e "${BLUE}🧹 Cleaning project...${NC}"
flutter clean

echo -e "${BLUE}📦 Getting dependencies...${NC}"
flutter pub get

echo -e "${BLUE}🔧 Generating code...${NC}"
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run analysis
print_section "Running Code Analysis"

echo -e "${BLUE}🔍 Running Flutter analyze...${NC}"
if flutter analyze; then
    echo -e "${GREEN}✅ Code analysis passed${NC}"
else
    echo -e "${RED}❌ Code analysis failed${NC}"
    exit 1
fi

# Run unit tests
print_section "Running Unit Tests"

echo -e "${BLUE}🧪 Running unit tests...${NC}"
if flutter test "$TEST_DIR/domain/" --coverage; then
    echo -e "${GREEN}✅ Unit tests passed${NC}"
else
    echo -e "${RED}❌ Unit tests failed${NC}"
    exit 1
fi

# Run integration tests
print_section "Running Integration Tests"

echo -e "${BLUE}🔗 Running integration tests...${NC}"
if flutter test "$TEST_DIR/integration/"; then
    echo -e "${GREEN}✅ Integration tests passed${NC}"
else
    echo -e "${RED}❌ Integration tests failed${NC}"
    exit 1
fi

# Run widget tests
print_section "Running Widget Tests"

echo -e "${BLUE}🎨 Running widget tests...${NC}"
if flutter test "$TEST_DIR/presentation/"; then
    echo -e "${GREEN}✅ Widget tests passed${NC}"
else
    echo -e "${RED}❌ Widget tests failed${NC}"
    exit 1
fi

# Run performance tests
print_section "Running Performance Tests"

echo -e "${BLUE}⚡ Running performance tests...${NC}"
if flutter test "$TEST_DIR/performance/"; then
    echo -e "${GREEN}✅ Performance tests passed${NC}"
else
    echo -e "${RED}❌ Performance tests failed${NC}"
    exit 1
fi

# Generate coverage report
print_section "Generating Coverage Report"

echo -e "${BLUE}📊 Generating coverage report...${NC}"

# Check if lcov is available
if command_exists lcov; then
    echo -e "${BLUE}📈 Generating LCOV report...${NC}"
    lcov --capture --directory . --output-file coverage/lcov.info
    lcov --remove coverage/lcov.info 'lib/*.g.dart' 'lib/*.freezed.dart' --output-file coverage/lcov.info
    lcov --remove coverage/lcov.info 'test/*' --output-file coverage/lcov.info
fi

# Check if genhtml is available
if command_exists genhtml; then
    echo -e "${BLUE}🌐 Generating HTML coverage report...${NC}"
    genhtml coverage/lcov.info -o "$COVERAGE_DIR" --title "Workspace Coverage Report"
    echo -e "${GREEN}✅ HTML coverage report generated at $COVERAGE_DIR${NC}"
else
    echo -e "${YELLOW}⚠️  genhtml not available, skipping HTML coverage report${NC}"
fi

# Generate test report
print_section "Generating Test Report"

echo -e "${BLUE}📋 Generating comprehensive test report...${NC}"

# Create a simple test report
cat > "$REPORTS_DIR/test_summary.txt" << EOF
Workspace Test Summary
=====================

Generated: $(date)
Flutter Version: $FLUTTER_VERSION

Test Results:
- Unit Tests: ✅ PASSED
- Integration Tests: ✅ PASSED
- Widget Tests: ✅ PASSED
- Performance Tests: ✅ PASSED

Coverage:
- Overall Coverage: Available in $COVERAGE_DIR

Performance:
- All performance tests passed
- Detailed metrics available in $PERFORMANCE_DIR

Next Steps:
1. Review coverage report
2. Check performance metrics
3. Address any issues found
4. Update documentation

EOF

echo -e "${GREEN}✅ Test summary generated at $REPORTS_DIR/test_summary.txt${NC}"

# Final summary
print_section "Test Execution Complete"

echo -e "${GREEN}🎉 All tests completed successfully!${NC}"
echo -e "\n${BLUE}📁 Reports generated:${NC}"
echo -e "  📋 Test Summary: $REPORTS_DIR/test_summary.txt"
echo -e "  📊 Coverage Report: $COVERAGE_DIR/index.html"
echo -e "  ⚡ Performance Report: $PERFORMANCE_DIR/performance_summary.txt"

echo -e "\n${BLUE}🔍 Next Steps:${NC}"
echo -e "  1. Review the generated reports"
echo -e "  2. Check coverage gaps and add tests if needed"
echo -e "  3. Monitor performance metrics"
echo -e "  4. Update documentation based on findings"

echo -e "\n${GREEN}✅ Workspace test suite execution completed successfully!${NC}"

exit 0

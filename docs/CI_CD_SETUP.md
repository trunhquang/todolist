# CI/CD Pipeline Setup Guide

## Overview
This document provides comprehensive instructions for setting up the CI/CD pipeline for the TodoList application using GitHub Actions.

## Pipeline Architecture

### Workflows
1. **CI Pipeline** (`ci.yml`) - Main continuous integration
2. **PR Checks** (`pr.yml`) - Pull request validation
3. **Release** (`release.yml`) - Production deployment
4. **Dependabot** (`dependabot.yml`) - Dependency updates

## Setup Instructions

### 1. GitHub Repository Setup

#### Enable GitHub Actions
1. Go to your repository settings
2. Navigate to "Actions" > "General"
3. Enable "Allow all actions and reusable workflows"
4. Save changes

#### Configure Branch Protection
1. Go to "Branches" in repository settings
2. Add rule for `main` branch:
   - Require pull request reviews
   - Require status checks to pass
   - Require branches to be up to date
   - Include administrators

### 2. Secrets Configuration

#### Required Secrets
Add the following secrets in repository settings > Secrets and variables > Actions:

```bash
# Firebase
FIREBASE_SERVICE_ACCOUNT=<firebase-service-account-json>

# Google Play Store
GOOGLE_PLAY_SERVICE_ACCOUNT=<google-play-service-account-json>

# Apple App Store
APPLE_API_KEY_ID=<apple-api-key-id>
APPLE_API_ISSUER_ID=<apple-api-issuer-id>
APPLE_API_PRIVATE_KEY=<apple-api-private-key>

# Notifications
SLACK_WEBHOOK=<slack-webhook-url>
TEAMS_WEBHOOK=<teams-webhook-url>
```

#### Firebase Service Account
1. Go to Firebase Console > Project Settings > Service Accounts
2. Click "Generate new private key"
3. Download the JSON file
4. Copy the entire JSON content to `FIREBASE_SERVICE_ACCOUNT` secret

#### Google Play Store
1. Go to Google Play Console > Setup > API access
2. Create or select a service account
3. Download the JSON key file
4. Copy the entire JSON content to `GOOGLE_PLAY_SERVICE_ACCOUNT` secret

#### Apple App Store
1. Go to Apple Developer > Certificates, Identifiers & Profiles > Keys
2. Create a new API key with App Store Connect access
3. Download the .p8 file and note the Key ID and Issuer ID
4. Add the values to respective secrets

### 3. Codecov Setup

#### Enable Codecov
1. Go to [Codecov.io](https://codecov.io)
2. Sign in with GitHub
3. Add your repository
4. Copy the repository token

#### Configure Codecov
The `codecov.yml` file is already configured with:
- 80% coverage target for project
- 70% coverage target for patches
- Proper file exclusions
- Flag-based coverage tracking

### 4. Dependabot Configuration

#### Automatic Updates
Dependabot is configured to:
- Update dependencies weekly (Mondays at 9 AM)
- Group related packages (Flutter, Firebase, Testing, Code Quality)
- Create pull requests with proper labels
- Assign to maintainers

#### Manual Configuration
You can customize the schedule and grouping in `.github/dependabot.yml`.

### 5. Docker Configuration

#### Build and Run
```bash
# Build the Docker image
docker build -t todolist-app .

# Run the container
docker run -p 8080:80 todolist-app

# Use docker-compose for development
docker-compose up -d
```

#### Development Environment
```bash
# Start development environment
docker-compose up todolist-dev

# Access the app at http://localhost:3000
```

### 6. Pipeline Workflows

#### CI Pipeline (`ci.yml`)
**Triggers**: Push to main/dev, Pull requests
**Jobs**:
- Test and Code Quality
- Build Android APK
- Build iOS
- Build Web
- Security Scan
- Deploy to Firebase Hosting (main branch only)
- Deploy to Google Play Store (main branch only)
- Deploy to App Store (main branch only)

#### PR Checks (`pr.yml`)
**Triggers**: Pull requests to main/dev
**Jobs**:
- Code Quality
- Unit Tests
- Widget Tests
- Integration Tests
- Build Tests
- Security Scan
- Performance Tests
- Documentation Check
- PR Summary

#### Release (`release.yml`)
**Triggers**: Git tags (v*)
**Jobs**:
- Create Release
- Deploy to Firebase Hosting
- Deploy to Google Play Store
- Deploy to App Store
- Notify Teams

### 7. Testing Strategy

#### Test Structure
```
test/
├── unit/           # Unit tests
├── widget/         # Widget tests
├── integration/    # Integration tests
└── performance/    # Performance tests
```

#### Running Tests Locally
```bash
# Run all tests
flutter test

# Run specific test types
flutter test test/unit/
flutter test test/widget/
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

#### Test Coverage
- Target: 80% overall coverage
- Patch coverage: 70%
- Excluded files: Generated files, test files, configuration files

### 8. Security Scanning

#### Trivy Scanner
- Scans for vulnerabilities in dependencies
- Runs on every PR and main branch push
- Fails on CRITICAL and HIGH severity issues
- Results uploaded to GitHub Security tab

#### Security Headers
- X-Frame-Options: SAMEORIGIN
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Referrer-Policy: strict-origin-when-cross-origin

### 9. Deployment Strategy

#### Environments
- **Development**: Automatic deployment on dev branch
- **Staging**: Manual deployment from main branch
- **Production**: Automatic deployment on release tags

#### Deployment Targets
- **Web**: Firebase Hosting
- **Android**: Google Play Store (Internal track)
- **iOS**: App Store Connect

#### Rollback Strategy
- Firebase Hosting: Previous versions available
- Google Play Store: Rollback to previous release
- App Store: Submit new version with fixes

### 10. Monitoring and Notifications

#### Slack Integration
- Deployment notifications
- Build failure alerts
- Release announcements

#### Teams Integration
- Release summaries
- Deployment status updates
- Team collaboration

#### GitHub Notifications
- PR status updates
- Build failure notifications
- Security alerts

### 11. Performance Monitoring

#### Build Performance
- Parallel job execution
- Caching strategies
- Optimized Docker layers

#### Runtime Performance
- Bundle size analysis
- Performance test suite
- Memory usage monitoring

### 12. Troubleshooting

#### Common Issues

**Build Failures**
```bash
# Check build logs
gh run list
gh run view <run-id>

# Re-run failed jobs
gh run rerun <run-id>
```

**Deployment Issues**
```bash
# Check deployment status
firebase hosting:channel:list

# Rollback deployment
firebase hosting:channel:deploy live --only hosting
```

**Test Failures**
```bash
# Run tests locally
flutter test --verbose

# Check coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

#### Debug Mode
Enable debug logging in workflows:
```yaml
- name: Debug
  run: |
    echo "Debug information"
    flutter doctor -v
    flutter pub deps
```

### 13. Best Practices

#### Code Quality
- All code must pass linting
- Tests must pass before merge
- Coverage must meet targets
- No TODO/FIXME in production code

#### Security
- Regular dependency updates
- Vulnerability scanning
- Secure secret management
- Principle of least privilege

#### Performance
- Optimize build times
- Minimize bundle size
- Efficient caching
- Parallel execution

#### Documentation
- Keep documentation updated
- Document breaking changes
- Provide migration guides
- Include examples

### 14. Maintenance

#### Regular Tasks
- Review and update dependencies
- Monitor build performance
- Update security policies
- Review and optimize workflows

#### Monthly Reviews
- Analyze build metrics
- Review security reports
- Update documentation
- Plan infrastructure improvements

## Support

### Documentation
- [GitHub Actions](https://docs.github.com/en/actions)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)
- [Google Play Console](https://support.google.com/googleplay/android-developer/)
- [App Store Connect](https://developer.apple.com/app-store-connect/)

### Community
- [GitHub Community](https://github.community/)
- [Flutter Community](https://flutter.dev/community)
- [Firebase Community](https://firebase.google.com/community)

### Support Channels
- GitHub Issues for bug reports
- GitHub Discussions for questions
- Slack/Teams for team communication

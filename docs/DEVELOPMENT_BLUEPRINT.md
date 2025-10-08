> ⚠️ Development Note:
> All implementations described in this blueprint **must adhere strictly** to the rules in `development_rules.md`.
> In case of conflict, `development_rules.md` takes precedence.

# 📋 Development Blueprint - Todo List Application

## 🎯 Project Overview

**Application Name**: Company Todo List & Daily Reports  
**Platform**: Flutter (Cross-platform Mobile)  
**Architecture**: Serverless (Firebase + OneDrive)  
**Target Users**: Companies with multiple departments and employees  

## 🏗️ System Architecture

### Core Components
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Flutter App   │◄──►│  Firebase Suite  │◄──►│   OneDrive      │
│                 │    │                  │    │                 │
│ • Authentication│    │ • Auth           │    │ • JSON Backup   │
│ • Task Management│    │ • Realtime DB    │    │ • Reports       │
│ • Daily Reports │    │ • Cloud Messaging│    │ • Data Export   │
│ • Notifications │    │ • Security Rules │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Data Flow
1. **User Actions** → Firebase Realtime Database
2. **Data Changes** → Firebase Cloud Messaging (Notifications)
3. **Scheduled Backup** → OneDrive JSON Files
4. **Dashboard** → Read from Firebase or OneDrive

## 📊 Data Model

### Firebase Database Structure
```json
{
  "companies": {
    "companyId": {
      "info": {
        "name": "Company Name",
        "createdBy": "adminUserId",
        "createdAt": "timestamp"
      },
      "departments": {
        "depId": {
          "name": "Department Name",
          "admins": ["userId1", "userId2"],
          "users": ["userId3", "userId4"],
          "createdAt": "timestamp"
        }
      },
      "projects": {
        "projectId": {
          "title": "Project Title",
          "description": "Project Description",
          "deadline": "2025-10-15|null",
          "departmentId": "depId",
          "status": "active|completed|closed",
          "createdBy": "userId",
          "createdAt": "timestamp"
        }
      },
      "tasks": {
        "taskId": {
          "title": "Task Title",
          "description": "Task Description",
          "assignee": "userId",
          "assigner": "userId",
          "status": "pending|in_progress|completed|cancelled",
          "priority": "low|medium|high|urgent",
          "taskType": "daily|weekly|monthly|project",
          "projectId": "projectId|null", // null for standalone tasks; required when taskType == "project" or when linking daily/weekly/monthly to a project
          "departmentId": "depId",
          "deadline": "2025-10-15|null",
          "hasDeadline": "true|false",
          "recurring": {
            "isRecurring": "true|false",
            "frequency": "daily|weekly|monthly",
            "interval": "1|2|3...",
            "endDate": "2025-12-31|null"
          },
          "parentTaskId": "taskId|null", // for generated instances of recurring tasks
          "stoppedByProjectClose": "true|false|undefined", // set true when project is closed and task is halted
          "createdAt": "timestamp",
          "updatedAt": "timestamp"
        }
      },
      "reports": {
        "userId": {
          "date": {
            "completedTasks": ["taskId1", "taskId2"],
            "pendingTasks": ["taskId3", "taskId4"],
            "notes": "Daily report notes",
            "submittedAt": "timestamp"
          }
        }
      }
    }
  }
}
```

## 📋 Task Types & Management

### Task Categories

#### 1. Daily Tasks
- **Purpose**: Tasks to be completed within a single day
- **Characteristics**:
  - Can be recurring (every day, weekdays only, etc.)
  - Optional deadline (end of day by default)
  - High frequency completion tracking
  - Perfect for routine work and daily habits

#### 2. Weekly Tasks
- **Purpose**: Tasks with weekly completion cycles
- **Characteristics**:
  - Can be recurring (every week, bi-weekly, etc.)
  - Optional deadline (end of week by default)
  - Weekly progress tracking
  - Suitable for regular weekly responsibilities

#### 3. Monthly Tasks
- **Purpose**: Tasks with monthly completion cycles
- **Characteristics**:
  - Can be recurring (every month, quarterly, etc.)
  - Optional deadline (end of month by default)
  - Monthly progress tracking
  - Ideal for long-term goals and monthly objectives

#### 4. Project Tasks
- **Purpose**: Tasks associated with specific projects
- **Characteristics**:
  - Must be linked to a project; creation flow requires an existing project
  - Can be daily/weekly/monthly type tasks that belong to a project (recurring supported)
  - Can have specific deadlines or be deadline-free
  - Creation flows:
    - Create inside a project's detail page; or
    - Create from global task creation but selecting a required `projectId`
  - When a project is closed, all its active/incomplete tasks are halted and no new recurring instances are generated
  - Suitable for project milestones and deliverables

### Task Properties
- **Deadline**: Optional for all task types
- **Priority**: Low, Medium, High, Urgent
- **Status**: Pending, In Progress, Completed, Cancelled
- **Recurring**: Support for automatic task regeneration
- **Assignment**: Can be assigned to specific users or departments
- **Project Linkage**:
  - Daily/Weekly/Monthly tasks may be standalone (no `projectId`) or linked to a project (`projectId` required when linking)
  - Tasks with `taskType = project` always require `projectId`
  - Closing a project halts all linked tasks that are not yet completed

## 👥 User Roles & Permissions

### 1. Admin (Company Administrator)
- **Role Code**: `admin`
- **Permissions**: Full system access
- **Responsibilities**:
  - Create and manage company
  - Create departments and assign department managers
  - Invite users and assign roles
  - View all reports and analytics
  - Delete tasks and manage all data
  - Configure company settings

### 2. Department Manager (Trưởng phòng)
- **Role Code**: `user_level_0`
- **Permissions**: Department-level access
- **Responsibilities**:
  - Create, assign, update, and close tasks within department
  - Update and monitor task progress for department
  - View department dashboard and team performance
  - Manage team members within department
  - Create and manage projects within department
  - Generate and view department reports
  - Set task priorities and deadlines

### 3. Team Lead (Lead)
- **Role Code**: `user_level_1`
- **Permissions**: Team-specific access
- **Responsibilities**:
  - Create and assign tasks within own team
  - Update task progress for team members
  - View team-specific dashboard and metrics
  - Generate team reports
  - Monitor team member progress
  - Coordinate team activities

### 4. Regular User (User bình thường)
- **Role Code**: `user_level_2`
- **Permissions**: Personal access only
- **Responsibilities**:
  - Create and manage own personal tasks
  - Update status of assigned tasks
  - View own task dashboard and progress
  - Update progress on assigned tasks
  - View own task reports and history
  - Complete assigned tasks on time

### Permission Restrictions:
- **Regular Users**: Cannot delete tasks, assign tasks to others, or view other users' data
- **Team Leads**: Cannot access other teams or delete tasks
- **Department Managers**: Cannot delete tasks (only close/cancel) or access other departments
- **Admin**: Full access to all functions and data

## 🚀 Development Phases

### Phase 0: Discovery & Setup (2 weeks) ✅ COMPLETED
**Week 1:**
- [x] Project setup and architecture design
- [x] Firebase project configuration
- [x] OneDrive API setup
- [x] UI/UX wireframes and mockups
- [x] Development environment setup

**Week 2:**
- [x] Flutter project initialization
- [x] Firebase integration setup
- [x] Basic authentication flow (UI only - no Firebase integration)
- [x] CI/CD pipeline setup
- [x] Code structure and architecture patterns

### Phase 1: Authentication & User Management (2 weeks) ✅ COMPLETED (100% Complete)
**Week 3:**
- [x] Firebase Authentication implementation (Complete with data persistence)
- [x] Google Sign-In integration (Complete with Firebase integration)
- [x] Email/Password authentication (Complete with Firebase Auth)
- [x] User registration flow (Complete with data saving)
- [x] Company creation functionality (Complete with Firebase integration)

**Week 4:**
- [x] Department creation and management
- [x] User invitation system (Basic implementation)
- [x] Role assignment functionality
- [x] Firebase Security Rules implementation
- [x] User profile management

### Phase 1.5: Infrastructure & Code Quality (Additional Work Completed)
**Configuration & Setup:**
- [x] Bundle ID migration to `com.kingnguyen.todolist`
- [x] Android build configuration updates (Kotlin 2.1.0, Java 11)
- [x] iOS configuration updates
- [x] Firebase configuration files updated and synchronized

**Code Architecture & Services:**
- [x] Centralized SnackbarService implementation
- [x] Centralized NavigationService with stack tracking
- [x] BaseController enhancement with navigation helpers
- [x] Comprehensive error handling and logging
- [x] Navigation stack tracking and popup monitoring

**UI/UX Improvements:**
- [x] Primary color theme updated to green (`rgb(5, 129, 45)`)
- [x] Color scheme consistency across all components
- [x] Custom widget system with TD prefix
- [x] Responsive design implementation

**Documentation & Process:**
- [x] Comprehensive documentation organization
- [x] Process tracking system implementation
- [x] Technical debt management framework
- [x] Sprint tracking and progress monitoring

### Phase 1 Extensions: Authentication & Onboarding Rules (Added Post-Completion)
These items extend Phase 1 scope to finalize onboarding and access control logic:

**Onboarding & Registration**
- [x] Self-registration users are assigned role `admin` only
- [x] After first login, if `admin` has no `companyId` → force navigate to Company Setup
- [x] Other users cannot self-register; they are invited by admin via email

**Invited Users**
- [x] Admin can pre-create/invite users with preset: department, role level, manager (hierarchy)
- [x] Invited users have `mustChangePassword = true` and must change password on first login

**Post-Login Flow Enhancements**
- [x] Centralized post-login navigation resolves session race using Firebase currentUser
- [x] Splash routes: if session exists → delegate to post-login routing; else → login
- [x] Enforce admin without companyId to `Company Setup` before accessing dashboard
- [x] Robust company check using trimmed `companyId`
- [x] Must-change-password enforcement: route to `Change Password` if `mustChangePassword == true`
- [x] Implemented `ChangePasswordPage` and backend `changePassword` to update Firebase Auth and clear `mustChangePassword` in DB and local storage

**Registration Controls**
- [x] Disable `register` route in release builds to prevent public self-registration (kept in debug/dev for testing)

**User Entity Enhancements**
- [x] Added `managerUserId`, `invitedByUserId`, `mustChangePassword` fields
- [x] Persistence updated in `FirebaseDatabaseService` (create/get/update)
- [x] Post-login navigation centralized (`handlePostLoginNavigation`)

### Phase 2: Core Task Management (2 weeks)
**Week 5:**
- [x] Project CRUD operations (must exist before creating project-linked tasks)
- [x] Task creation and assignment by type (daily/weekly/monthly/project) with project linkage rules
- [x] Task status management
- [x] Priority and optional deadline handling (validation: deadline ≥ today, timezone-safe)
- [x] Recurring task functionality (model + UI controls, no auto-generation yet) including project-linked recurring tasks
- [x] Basic task filtering and search by type

**Acceptance Criteria (Week 5):**
- [x] Users with proper role can create/update/delete Projects within their department
- [x] Users can create Tasks by type with validation on required fields, including:
  - `projectId` is required when creating `taskType = project`
  - When creating daily/weekly/monthly tasks, `projectId` is optional (standalone) but required if linking to a project
- [x] Status transitions follow rules per role and allowed transitions
- [x] Priority and deadline toggles behave consistently across types
- [x] Recurring options captured and stored (no generation yet). If a task is linked to a project, recurring config is allowed and respects project lifecycle
- [x] List pages support filter by type/status/priority and search by title; add filter by `projectId` and project status
  
  Role-based constraints implemented:
  - [x] Only `admin`/`user_level_0`/`user_level_1` can assign/change assignee
  - [x] `user_level_2` can only update status when they are the assigned user
  - [x] `user_level_2` cannot change `projectId` when editing an existing task
  - [x] Delete task button is hidden unless role has `deleteTasks` permission

**Week 6:**
- [x] Realtime data synchronization (projects/tasks list via streams)
- [x] Offline support with local caching (Hive) and mutation queue for tasks/projects
- [x] Recurring task auto-generation (daily/weekly/monthly) including project-linked tasks
- [ ] Conflict resolution and retry/backoff strategy
- [ ] Performance optimization (pagination/limits for large lists)

**Acceptance Criteria (Week 6):**
- [x] Task/project changes propagate in realtime across devices
- [x] Offline create/update/delete queued and synced when online
- [ ] Conflicts resolved deterministically (last-write-wins + activityLog)
- [x] Recurring generator creates next instances at the correct cadence and stops per endDate; additionally, halts generation for tasks linked to projects that are `closed`
- [ ] Lists handle 1k+ tasks with stable scrolling and pagination

#### Authorization Rules for Tasks/Projects (Phase 2)
- Admin (`admin`): full access across company; can hard delete (reserved for later phases)
- Department Manager (`user_level_0`): CRUD within department; close/cancel tasks; no hard delete
- Team Lead (`user_level_1`): create/assign within own team; update status; no cross-team access
- Regular User (`user_level_2`): create personal tasks; update assigned tasks; cannot assign or delete
- Soft delete recommended in Phase 2; hard delete limited to Admin (Phase 4)

#### Recurring Task Specification (Phase 2)
- Fields: `isRecurring`, `frequency` (daily|weekly|monthly), `interval`, `endDate`
- Generation timing: executed locally on app open and periodically; server-side optional later
- Linkage: new instances reference `parentTaskId`; copy: title/description/priority/deadline rules per type
- Project linkage: recurring tasks may be standalone or linked to a project; project-linked recurring tasks require `projectId`
- Stop rules: stop at `endDate` or when parent cancelled; also halt generation immediately when linked `project.status == closed`

#### Offline Sync Strategy (Phase 2)
- Local cache: Hive storage for tasks/projects and filters
- Queue mutations while offline; apply when reconnected with exponential backoff
- Conflict resolution: last-write-wins; log changes in `activityLog`

#### Indexes & Query Strategy (Realtime DB)
- Index by: `departmentId`, `assignee`, `taskType`, `status`, `projectId`, `deadline`
- Query patterns: list by department + type + status; assignee inbox; overdue by deadline; tasks by `projectId`; exclude tasks linked to projects with status `closed` where applicable
- Pagination: limit/offset (startAt/endAt keys), chunked loading in UI

### Phase 3: Daily Reports & Notifications (2 weeks)
**Week 7:**
- [ ] Daily report creation interface
- [ ] Task completion tracking by type (daily/weekly/monthly/project)
- [ ] Report submission system
- [ ] Report history and analytics
- [ ] Department report aggregation
- [ ] Task type-based reporting and filtering

**Week 8:**
- [ ] Firebase Cloud Messaging setup
- [ ] Push notification implementation
- [ ] Deadline reminder notifications (for tasks with deadlines)
- [ ] Task assignment notifications
- [ ] Report submission notifications
- [ ] Recurring task reminder notifications
- [ ] Task type-specific notification templates

### Phase 4: Data Backup & Export (2 weeks)
**Week 9:**
- [ ] OneDrive integration setup
- [ ] Microsoft Graph API implementation
- [ ] JSON data export functionality
- [ ] Scheduled backup system
- [ ] Data synchronization with OneDrive

**Week 10:**
- [ ] Dashboard data visualization
- [ ] Power BI integration
- [ ] Report generation and export
- [ ] Analytics and insights
- [ ] Performance monitoring

### Phase 5: Testing & Quality Assurance (2 weeks)
**Week 11:**
- [ ] Unit testing implementation
- [ ] Integration testing
- [ ] Firebase Security Rules testing
- [ ] Performance testing
- [ ] Security testing

**Week 12:**
- [ ] User acceptance testing
- [ ] Pilot testing with real users
- [ ] Bug fixes and improvements
- [ ] Performance optimization
- [ ] Final release preparation

## 🛠️ Technical Specifications

> **📋 Chi tiết kỹ thuật đầy đủ**: Xem file [TECHNICAL_SPECIFICATIONS.md](./TECHNICAL_SPECIFICATIONS.md) để biết thông tin chi tiết về:
> - Dependencies và packages Flutter
> - Cấu trúc project chi tiết
> - Firebase configuration và security rules
> - CI/CD pipeline setup
> - Testing strategy và configuration
> - Performance monitoring

### Tóm tắt Technical Stack
- **Framework**: Flutter 3.16.0+
- **State Management**: GetX (Controllers, Dependency Injection, Route Management)
- **Backend**: Firebase (Auth, Realtime DB, FCM, Analytics)
- **Storage**: Hive (local) + OneDrive (backup)
- **Architecture**: Clean Architecture với GetX pattern
- **Testing**: Unit, Widget, Integration tests
- **CI/CD**: GitLab CI với automated testing và building

## 🔐 Security Implementation

> **🔒 Chi tiết Security Rules**: Xem file [TECHNICAL_SPECIFICATIONS.md](./TECHNICAL_SPECIFICATIONS.md) để biết Firebase Security Rules đầy đủ và chi tiết.

### Tóm tắt Security Features
- **Authentication**: Firebase Auth với Google Sign-In và Email/Password
- **Authorization**: Role-based access control (Company Admin, Department Admin, User)
- **Data Security**: Firebase Security Rules cho từng loại dữ liệu
- **API Security**: OneDrive API với proper authentication
- **Local Security**: Encrypted local storage với Hive

## 🎨 UI/UX Design for Task Types

### Task Creation Interface
- **Task Type Selector**: Dropdown with 4 options (Daily, Weekly, Monthly, Project)
- **Dynamic Form Fields**: 
  - Project selection behavior:
    - When `taskType = project`: show `Project` picker (required); disable submit until `projectId` selected
    - When `taskType ∈ {daily, weekly, monthly}`: show `Link to project` toggle
      - If toggle = ON: show `Project` picker (required)
      - If toggle = OFF: hide/disable `Project` picker (standalone task)
    - If creating from a Project detail page: prefill `projectId` and lock the `Project` picker
  - Deadline toggle (optional for all types)
  - Recurring options (for Daily/Weekly/Monthly tasks)
- **Visual Indicators**: Color coding for different task types
- **Quick Actions**: Templates for common task patterns
  
#### Validation & UX Rules (Task Creation)
- Required fields: `title`, `taskType`; plus `projectId` when `taskType = project` or when `Link to project` = ON
- Inline errors:
  - Show "Project is required" when missing under the required conditions above
  - Disable submit button until all required fields are valid
- Project state handling:
  - If selected `project.status = closed`, show warning and prevent linking; auto-unlink or require picking another project
  - For recurring tasks linked to a project, show helper text: "Recurring instances will stop if the project is closed"

#### Wireframes (ASCII)
```
1) Daily/Weekly/Monthly — Toggle OFF (Standalone)
┌──────────────────────────────────────────────┐
│ Task Type: [ Daily ▾ ]                      │
│ Title: [____________________________]       │
│ Link to project: [ OFF ]                    │
│ Project:  — hidden —                        │
│ Deadline: ( ) Has deadline   [  __ / __ / __] │
│ Recurring: [ ] Enable                       │
│    Frequency:  — disabled —                 │
│    Interval:   — disabled —                 │
│    End date:   — disabled —                 │
│ [Cancel]                         [Create]   │
└──────────────────────────────────────────────┘

2) Daily/Weekly/Monthly — Toggle ON (Linked)
┌──────────────────────────────────────────────┐
│ Task Type: [ Weekly ▾ ]                      │
│ Title: [____________________________]       │
│ Link to project: [ ON ]                     │
│ Project: [ Select project ▾ ]  (required)   │
│   ℹ Recurring instances will stop if the    │
│     project is closed                       │
│ Deadline: ( ) Has deadline   [  __ / __ / __] │
│ Recurring: [x] Enable                       │
│    Frequency:  [ weekly ▾ ]                 │
│    Interval:   [  1  ▾ ]                    │
│    End date:   [  __ / __ / __ ]            │
│ [Cancel]                         [Create]   │
└──────────────────────────────────────────────┘

3) Project Task — Project required
┌──────────────────────────────────────────────┐
│ Task Type: [ Project ▾ ]                     │
│ Title: [____________________________]       │
│ Project: [ Select project ▾ ]  (required)   │
│ Deadline: ( ) Has deadline   [  __ / __ / __] │
│ Recurring: [ ] Enable (optional)            │
│    Frequency:  — disabled until checked —   │
│    Interval:   — disabled until checked —   │
│    End date:   — disabled until checked —   │
│ [Cancel]                         [Create]   │
└──────────────────────────────────────────────┘

4) Error States
┌──────────────────────────────────────────────┐
│ (a) Missing project when required            │
│ Project: [ Select project ▾ ]                │
│   ✖ Project is required                      │
│ [Create] — disabled                          │
├──────────────────────────────────────────────┤
│ (b) Selected project is closed               │
│ Project: [ Alpha Project (closed) ▾ ]        │
│   ⚠ This project is closed. Choose another   │
│     project or unlink to proceed             │
│   [Change project]    [Unlink]               │
│ [Create] — disabled while closed selected    │
└──────────────────────────────────────────────┘

5) Create from Project Detail Page — Prefilled & Locked projectId
┌──────────────────────────────────────────────┐
│ Context: Project Detail → "New Task"         │
│ Current project: Alpha Project (id=proj_123) │
├──────────────────────────────────────────────┤
│ Task Type: [ Daily ▾ ]                       │
│ Title: [____________________________]        │
│ Link to project: [ ON ] — locked             │
│ Project: [ Alpha Project ] — locked          │
│   ℹ Tasks created here are linked to project │
│ Deadline: ( ) Has deadline   [  __ / __ / __] │
│ Recurring: [ ] Enable                        │
│    Frequency:  — disabled until checked —    │
│    Interval:   — disabled until checked —    │
│    End date:   — disabled until checked —    │
│ [Cancel]                         [Create]    │
└──────────────────────────────────────────────┘
```

### Task List Views
- **Filter by Type**: Separate tabs or filter options
- **Grouped Display**: Tasks organized by type and deadline
- **Progress Indicators**: Visual progress for recurring tasks
- **Status Badges**: Clear status indicators with type-specific styling

### Dashboard Analytics
- **Task Type Breakdown**: Pie charts showing distribution
- **Completion Rates**: By task type and time period
- **Trend Analysis**: Performance over time for each type
- **Deadline Tracking**: Overdue tasks by type

## 📱 Key Features Implementation

### 1. Authentication Flow
- Google Sign-In integration
- Email/Password authentication
- Company registration
- User invitation system
- Role-based access control

### 2. Task Management
- **Task Types**:
  - **Daily Tasks**: Tasks to be completed within a day
  - **Weekly Tasks**: Tasks with weekly completion cycles
  - **Monthly Tasks**: Tasks with monthly completion cycles
  - **Project Tasks**: Tasks associated with specific projects
- **Task Features**:
  - Create, assign, and track tasks by type
  - Set priorities and optional deadlines (with validation)
  - Task status updates and progress tracking
  - Project association (for project tasks)
  - Department filtering and organization
  - Recurring task support for daily/weekly/monthly tasks
  - Hooks for downstream notifications (Phase 3)

### 3. Daily Reports
- Task completion tracking
- Daily notes and comments
- Report submission
- Historical report viewing
- Department report aggregation

### 4. Notifications
- Task assignment alerts
- Deadline reminders
- Report submission notifications
- Project updates
- System announcements

### 5. Data Management
- Real-time synchronization
- Offline support
- OneDrive backup
- Data export functionality
- Analytics and reporting

## 🧪 Testing Strategy

### Unit Testing
- Business logic testing
- Data model validation
- Utility function testing
- State management testing

### Integration Testing
- Firebase integration
- OneDrive API integration
- Authentication flow
- Real-time synchronization

### UI Testing
- Widget testing
- User interaction testing
- Navigation testing
- Responsive design testing

### Performance Testing
- App startup time
- Memory usage
- Network efficiency
- Database query performance

## 📈 Success Metrics

### Technical Metrics
- App startup time < 3 seconds
- Real-time sync latency < 500ms
- Offline functionality coverage > 90%
- Crash rate < 0.1%

### User Experience Metrics
- User onboarding completion rate > 80%
- Daily active users retention > 70%
- Task completion rate > 85%
- User satisfaction score > 4.5/5

## 🚀 Deployment Strategy

### Development Environment
- Firebase project for development
- OneDrive sandbox environment
- GitLab CI/CD pipeline
- Automated testing

### Staging Environment
- Production-like Firebase setup
- OneDrive test environment
- User acceptance testing
- Performance monitoring

### Production Environment
- Production Firebase project
- OneDrive production integration
- App store deployment
- Monitoring and analytics

## 📋 Risk Management

### Technical Risks
- Firebase quota limitations
- OneDrive API rate limits
- Real-time sync performance
- Offline data consistency

### Mitigation Strategies
- Implement data pagination
- Add retry mechanisms
- Optimize database queries
- Implement conflict resolution

## 🔄 Maintenance & Updates

### Regular Maintenance
- Security updates
- Performance optimization
- Bug fixes
- Feature enhancements

### Monitoring
- Firebase Analytics
- Crash reporting
- Performance monitoring
- User feedback collection

## 📚 Documentation

### Technical Documentation
- API documentation
- Database schema
- Security rules
- Deployment guide

### User Documentation
- User manual
- Admin guide
- FAQ
- Video tutorials

---

**Total Development Time**: 12-13 weeks  
**Team Size**: 2-3 developers  
**Budget Estimate**: $15,000 - $25,000  
**Post-MVP Features**: Web dashboard, Advanced analytics, Multi-company support

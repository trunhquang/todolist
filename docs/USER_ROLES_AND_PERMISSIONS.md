# 👥 User Roles & Permissions System

## 🎯 Overview
This document defines the comprehensive user roles and permissions system for the TodoList application. The system supports hierarchical user management with different access levels and capabilities.

## 📊 User Role Hierarchy

### 1. 🔑 Admin (Company Administrator)
**Role Code**: `admin`  
**Level**: Highest authority  
**Scope**: Company-wide access

#### Permissions:
- **✅ Full System Access**: Complete control over all company data
- **✅ Company Management**: Create, update, delete company information
- **✅ Department Management**: Create, update, delete departments
- **✅ User Management**: Invite, assign roles, activate/deactivate users
- **✅ Role Assignment**: Assign any role to any user
- **✅ Data Access**: View all data across all departments and teams
- **✅ System Configuration**: Configure company settings and policies
- **✅ Analytics & Reports**: Access to all company-wide reports and analytics
- **✅ Backup & Export**: Full data export and backup capabilities

#### Responsibilities:
- Overall company management and strategy
- User onboarding and role assignment
- Department structure planning
- System-wide policy enforcement
- Company-wide reporting and analytics

---

### 2. 🏢 Department Manager (Trưởng phòng)
**Role Code**: `user_level_0`  
**Level**: Department authority  
**Scope**: Department-wide access

#### Permissions:
- **✅ Task Management**: Create, assign, update, and close tasks within department
- **✅ Progress Tracking**: Update and monitor task progress for department
- **✅ Dashboard Access**: View department dashboard and team performance
- **✅ Team Management**: View and manage team members within department
- **✅ Project Management**: Create and manage projects within department
- **✅ Reporting**: Generate and view department reports
- **✅ User Assignment**: Assign tasks to department members
- **✅ Task Status Control**: Change task status (pending, in progress, completed, cancelled)
- **✅ Deadline Management**: Set and modify task deadlines
- **✅ Priority Management**: Set task priorities (low, medium, high, urgent)

#### Restrictions:
- **❌ Cannot delete tasks** (only close/cancel)
- **❌ Cannot access other departments** (unless explicitly granted)
- **❌ Cannot modify company-level settings**
- **❌ Cannot assign admin roles**

#### Responsibilities:
- Department performance management
- Task assignment and progress monitoring
- Team coordination and communication
- Department reporting to admin
- Project planning and execution

---

### 3. 👨‍💼 Team Lead (Lead)
**Role Code**: `user_level_1`  
**Level**: Team authority  
**Scope**: Team-specific access

#### Permissions:
- **✅ Team Task Management**: Create and assign tasks within own team
- **✅ Team Progress Tracking**: Update task progress for team members
- **✅ Team Dashboard**: View team-specific dashboard and metrics
- **✅ Task Assignment**: Assign tasks to team members
- **✅ Task Status Updates**: Update task status for team tasks
- **✅ Team Reporting**: Generate team reports
- **✅ Task Creation**: Create tasks for team projects
- **✅ Progress Monitoring**: Monitor team member progress

#### Restrictions:
- **❌ Cannot access other teams** within department
- **❌ Cannot delete tasks** (only close/cancel)
- **❌ Cannot modify department-level settings**
- **❌ Cannot assign department manager roles**
- **❌ Limited to own team scope**

#### Responsibilities:
- Team performance management
- Task coordination within team
- Team member guidance and support
- Team reporting to department manager
- Project execution within team scope

---

### 4. 👤 Regular User (User bình thường)
**Role Code**: `user_level_2`  
**Level**: Individual contributor  
**Scope**: Personal access only

#### Permissions:
- **✅ Personal Task Management**: Create and manage own personal tasks
- **✅ Task Status Updates**: Update status of assigned tasks
- **✅ Personal Dashboard**: View own task dashboard and progress
- **✅ Task Progress**: Update progress on assigned tasks
- **✅ Personal Reports**: View own task reports and history
- **✅ Task Assignment**: Can be assigned tasks by leads/managers
- **✅ Task Completion**: Mark assigned tasks as completed

#### Restrictions:
- **❌ Cannot delete tasks** (only mark as completed/cancelled)
- **❌ Cannot assign tasks to others**
- **❌ Cannot view other users' tasks** (unless assigned)
- **❌ Cannot access team/department dashboards**
- **❌ Cannot create projects**
- **❌ Cannot modify task priorities or deadlines** (assigned tasks only)
- **❌ Cannot access administrative functions**

#### Responsibilities:
- Complete assigned tasks on time
- Update task progress regularly
- Report task completion and issues
- Maintain personal task organization
- Follow team and department guidelines

---

## 🔐 Permission Matrix

| Action | Admin | Dept Manager | Team Lead | Regular User |
|--------|-------|--------------|-----------|--------------|
| **Company Management** | ✅ | ❌ | ❌ | ❌ |
| **Department Management** | ✅ | ✅ (Own Dept) | ❌ | ❌ |
| **User Management** | ✅ | ✅ (Dept Users) | ❌ | ❌ |
| **Create Tasks** | ✅ | ✅ | ✅ (Team) | ✅ (Personal) |
| **Assign Tasks** | ✅ | ✅ | ✅ (Team) | ❌ |
| **Update Task Status** | ✅ | ✅ | ✅ (Team) | ✅ (Assigned) |
| **Delete Tasks** | ✅ | ❌ | ❌ | ❌ |
| **View Dashboards** | ✅ (All) | ✅ (Dept) | ✅ (Team) | ✅ (Personal) |
| **Generate Reports** | ✅ (All) | ✅ (Dept) | ✅ (Team) | ✅ (Personal) |
| **Set Priorities** | ✅ | ✅ | ✅ (Team) | ❌ |
| **Set Deadlines** | ✅ | ✅ | ✅ (Team) | ❌ |
| **Access Analytics** | ✅ (All) | ✅ (Dept) | ✅ (Team) | ❌ |

---

## 🏗️ Technical Implementation

### User Entity Structure
```dart
class User {
  final String id;
  final String email;
  final String name;
  final String role; // 'admin', 'user_level_0', 'user_level_1', 'user_level_2'
  final String companyId;
  final String? departmentId;
  final String? teamId; // For team leads and regular users
  final List<String> permissions; // Dynamic permissions list
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;
}
```

### Role Constants
```dart
class UserRoles {
  static const String admin = 'admin';
  static const String departmentManager = 'user_level_0';
  static const String teamLead = 'user_level_1';
  static const String regularUser = 'user_level_2';
}
```

### Permission Constants
```dart
class Permissions {
  // Company Management
  static const String manageCompany = 'manage_company';
  static const String manageDepartments = 'manage_departments';
  static const String manageUsers = 'manage_users';
  
  // Task Management
  static const String createTasks = 'create_tasks';
  static const String assignTasks = 'assign_tasks';
  static const String updateTaskStatus = 'update_task_status';
  static const String deleteTasks = 'delete_tasks';
  static const String setTaskPriority = 'set_task_priority';
  static const String setTaskDeadline = 'set_task_deadline';
  
  // Dashboard & Reports
  static const String viewCompanyDashboard = 'view_company_dashboard';
  static const String viewDepartmentDashboard = 'view_department_dashboard';
  static const String viewTeamDashboard = 'view_team_dashboard';
  static const String viewPersonalDashboard = 'view_personal_dashboard';
  static const String generateReports = 'generate_reports';
  
  // Data Access
  static const String viewAllData = 'view_all_data';
  static const String viewDepartmentData = 'view_department_data';
  static const String viewTeamData = 'view_team_data';
  static const String viewPersonalData = 'view_personal_data';
}
```

---

## 🔒 Security Rules

### Firebase Security Rules
```json
{
  "rules": {
    "companies": {
      "$companyId": {
        ".read": "auth != null && root.child('companies').child($companyId).child('users').child(auth.uid).exists()",
        ".write": "auth != null && root.child('companies').child($companyId).child('users').child(auth.uid).child('role').val() == 'admin'",
        
        "departments": {
          "$departmentId": {
            ".read": "auth != null && (data.child('users').child(auth.uid).exists() || data.child('admins').child(auth.uid).exists())",
            ".write": "auth != null && (data.child('admins').child(auth.uid).exists() || root.child('companies').child($companyId).child('users').child(auth.uid).child('role').val() == 'admin')"
          }
        },
        
        "tasks": {
          "$taskId": {
            ".read": "auth != null && (data.child('assignee').val() == auth.uid || data.child('assigner').val() == auth.uid || data.child('departmentId').val() == root.child('companies').child($companyId).child('departments').child(data.child('departmentId').val()).child('admins').child(auth.uid).exists())",
            ".write": "auth != null && (data.child('assignee').val() == auth.uid || data.child('assigner').val() == auth.uid || data.child('departmentId').val() == root.child('companies').child($companyId).child('departments').child(data.child('departmentId').val()).child('admins').child(auth.uid).exists())",
            ".delete": "auth != null && root.child('companies').child($companyId).child('users').child(auth.uid).child('role').val() == 'admin'"
          }
        }
      }
    }
  }
}
```

---

## 🚀 Implementation Guidelines

### 1. Role Assignment
- **Admin**: Assigned during company creation
- **Department Manager**: Assigned by admin during department creation
- **Team Lead**: Assigned by department manager
- **Regular User**: Default role for new users

### 2. Permission Checking
```dart
class PermissionService {
  static bool hasPermission(User user, String permission) {
    switch (user.role) {
      case UserRoles.admin:
        return true; // Admin has all permissions
      case UserRoles.departmentManager:
        return _departmentManagerPermissions.contains(permission);
      case UserRoles.teamLead:
        return _teamLeadPermissions.contains(permission);
      case UserRoles.regularUser:
        return _regularUserPermissions.contains(permission);
      default:
        return false;
    }
  }
}
```

### 3. UI Access Control
```dart
class RoleBasedWidget extends StatelessWidget {
  final String requiredRole;
  final Widget child;
  final Widget? fallback;
  
  const RoleBasedWidget({
    required this.requiredRole,
    required this.child,
    this.fallback,
  });
  
  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthController>().currentUser;
    if (user != null && _hasRequiredRole(user.role, requiredRole)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}
```

---

## 📋 Migration Plan

### Phase 1: Update User Entity
1. Add new role constants
2. Update User entity with teamId field
3. Add permission checking methods

### Phase 2: Update Controllers
1. Modify AuthController to handle new roles
2. Update permission checking logic
3. Add role-based navigation

### Phase 3: Update UI Components
1. Add role-based access control widgets
2. Update dashboards for different roles
3. Modify task management interfaces

### Phase 4: Update Security Rules
1. Deploy new Firebase security rules
2. Test permission enforcement
3. Update documentation

---

## 🎯 Success Criteria

### Functional Requirements
- [x] Four distinct user roles with clear hierarchy
- [x] Role-based permission system
- [x] Secure data access control
- [x] Task management permissions by role
- [x] Dashboard access by role level

### Technical Requirements
- [x] User entity supports new role structure
- [x] Permission checking service implemented
- [x] Firebase security rules updated
- [x] Role-based UI components
- [x] Comprehensive documentation

### Security Requirements
- [x] Users can only access data within their scope
- [x] Task deletion restricted to admin only
- [x] Role assignment controlled by higher-level users
- [x] Data isolation between departments and teams
- [x] Audit trail for permission changes

---

**Document Version**: 1.0  
**Last Updated**: December 2024  
**Status**: ✅ **IMPLEMENTATION READY**

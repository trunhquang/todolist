# 📱 UI/UX Rules

## 1. Widget Composition & Size Management

### Widget Size Limits
```
✅ ĐÚNG: 
- Mỗi widget file không quá 100 dòng
- Mỗi file không quá 400 dòng
- Chia widget lớn thành nhiều widget nhỏ

❌ SAI:
- Widget 200+ dòng code
- File 500+ dòng code
- Monolithic widgets
```

### Widget Composition Example
```dart
// ✅ ĐÚNG: Chia nhỏ widget
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TDCard(
      child: Column(
        children: [
          TaskCardHeader(task: task),
          TaskCardContent(task: task),
          TaskCardActions(
            onTap: onTap,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

// TaskCardHeader - Widget nhỏ
class TaskCardHeader extends StatelessWidget {
  final Task task;
  
  const TaskCardHeader({Key? key, required this.task}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      child: TDText.heading(task.title),
    );
  }
}
```

## 2. Custom Widget Inheritance (TD Prefix)

### Custom Widget Rules
```
✅ ĐÚNG: Tất cả custom widgets phải có prefix TD
- TDCard, TDButton, TDText, TDTextField
- TDAppBar, TDDialog, TDSnackbar
- TDLoading, TDError, TDEmpty

❌ SAI: Sử dụng trực tiếp Material widgets
- Card, ElevatedButton, Text, TextField
- AppBar, AlertDialog, SnackBar
```

## 3. Centralized Services

### SnackbarService Rules
```
✅ ĐÚNG: Sử dụng SnackbarService cho tất cả thông báo
- SnackbarService.instance.showSuccess()
- SnackbarService.instance.showError()
- SnackbarService.instance.showWarning()
- SnackbarService.instance.showInfo()
- SnackbarService.instance.showTaskCreated()
- SnackbarService.instance.showNetworkError()

❌ SAI: Sử dụng trực tiếp Get.snackbar
- Get.snackbar()
- ScaffoldMessenger.of(context).showSnackBar()
```

### NavigationService Rules
```
✅ ĐÚNG: Sử dụng NavigationService cho tất cả navigation
- NavigationService.instance.toNamed()
- NavigationService.instance.offAllNamed()
- NavigationService.instance.back()
- NavigationService.instance.showDialog()
- NavigationService.instance.showBottomSheet()
- NavigationService.instance.showAlertDialog()

❌ SAI: Sử dụng trực tiếp Get navigation
- Get.toNamed()
- Get.offAllNamed()
- Get.back()
- Get.dialog()
```

## 4. String Management & Localization

### String Management Rules
```
✅ ĐÚNG: Sử dụng AppStrings cho tất cả strings
- AppStrings.I.taskCreatedSuccessfully
- AppStrings.I.confirm
- AppStrings.I.cancel

❌ SAI: Hardcode strings
- "Task created successfully"
- "Confirm"
- "Cancel"
```

## 5. Consistent Spacing & Padding

### Spacing Rules
```
✅ ĐÚNG: Sử dụng AppSpacing cho tất cả spacing
- AppSpacing.cardPadding
- AppSpacing.contentMargin
- AppSpacing.sectionSpacing

❌ SAI: Hardcode spacing values
- EdgeInsets.all(16)
- EdgeInsets.symmetric(horizontal: 24)
- SizedBox(height: 8)
```

## 6. Widget Structure
```dart
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
```

## 7. Responsive Design
```dart
✅ ĐÚNG:
class ResponsiveTaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => TaskCard(),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) => TaskCard(),
          );
        }
      },
    );
  }
}
```

## 8. Loading States
```dart
✅ ĐÚNG:
Obx(() {
  if (controller.isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  
  if (controller.tasks.isEmpty) {
    return Center(child: Text('No tasks found'));
  }
  
  return ListView.builder(
    itemCount: controller.tasks.length,
    itemBuilder: (context, index) => TaskCard(
      task: controller.tasks[index],
    ),
  );
})
```

---

**📁 File liên quan:**
- [String Management Rules](STRING_MANAGEMENT_RULES.md)
- [GetX Specific Rules](GETX_RULES.md)
- [Implementation Examples](IMPLEMENTATION_EXAMPLES.md)

# 📊 Performance Rules

## 1. Memory Management
```dart
✅ ĐÚNG:
@override
void onClose() {
  _subscription?.cancel();
  super.onClose();
}

❌ SAI:
// Not disposing resources
```

## 2. Lazy Loading
```dart
✅ ĐÚNG:
Get.lazyPut<TaskController>(() => TaskController());

❌ SAI:
Get.put(TaskController()); // Eager loading
```

## 3. Image Optimization
```dart
✅ ĐÚNG:
CachedNetworkImage(
  imageUrl: task.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)

❌ SAI:
Image.network(task.imageUrl) // No caching or error handling
```

---

**📁 File liên quan:**
- [GetX Specific Rules](GETX_RULES.md)
- [Security Rules](SECURITY_RULES.md)
- [Deployment Rules](DEPLOYMENT_RULES.md)

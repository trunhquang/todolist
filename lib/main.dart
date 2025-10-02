import 'package:flutter/material.dart';
import 'package:todolist/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app services
  await AppInitializer.initialize();
  
  runApp(const TodoListApp());
}

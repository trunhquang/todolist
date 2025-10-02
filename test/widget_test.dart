// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:todolist/app/pages/splash_page.dart';

void main() {
  testWidgets('Splash page loads successfully', (WidgetTester tester) async {
    // Enable Get test mode
    Get.testMode = true;
    
    // Build the splash page directly with GetMaterialApp
    await tester.pumpWidget(
      GetMaterialApp(
        home: const SplashPage(),
        // Add a simple route for login to prevent navigation errors
        getPages: [
          GetPage(name: '/login', page: () => const Scaffold(body: Text('Login Page'))),
        ],
      ),
    );

    // Verify that the splash page loads without crashing
    expect(find.byType(SplashPage), findsOneWidget);
    
    // Verify that the app name is displayed
    expect(find.text('TodoList'), findsOneWidget);
    
    // Verify that the app description is displayed
    expect(find.text('Company Todo List & Daily Reports'), findsOneWidget);
    
    // Wait for the timer to complete to avoid pending timer error
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}

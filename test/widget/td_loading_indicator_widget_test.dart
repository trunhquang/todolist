import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/app/widgets/td_loading_indicator.dart';
import 'package:todolist/app/theme/app_colors.dart';

void main() {
  group('TDLoadingIndicator Widget Tests', () {
    testWidgets('should display loading indicator with default properties', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingIndicator(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('should display loading indicator with custom message', (tester) async {
      // Arrange
      const message = 'Loading data...';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingIndicator(
              message: message,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('should display loading indicator with custom size', (tester) async {
      // Arrange
      const customSize = 48.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingIndicator(
              size: customSize,
            ),
          ),
        ),
      );

      // Assert
      final circularProgressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(circularProgressIndicator.strokeWidth, equals(2));
      
      final sizedBox = tester.widget<SizedBox>(
        find.byType(SizedBox).first,
      );
      expect(sizedBox.width, equals(customSize));
      expect(sizedBox.height, equals(customSize));
    });

    testWidgets('should display loading indicator with custom color', (tester) async {
      // Arrange
      const customColor = Colors.red;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingIndicator(
              color: customColor,
            ),
          ),
        ),
      );

      // Assert
      final circularProgressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      final valueColor = circularProgressIndicator.valueColor as AlwaysStoppedAnimation<Color>;
      expect(valueColor.value, equals(customColor));
    });

    testWidgets('should not display message when showMessage is false', (tester) async {
      // Arrange
      const message = 'Loading data...';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingIndicator(
              message: message,
              showMessage: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(message), findsNothing);
    });

    testWidgets('should use default primary color when no color specified', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingIndicator(),
          ),
        ),
      );

      // Assert
      final circularProgressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      final valueColor = circularProgressIndicator.valueColor as AlwaysStoppedAnimation<Color>;
      expect(valueColor.value, equals(AppColors.primary));
    });

    testWidgets('should display message with correct text style', (tester) async {
      // Arrange
      const message = 'Loading data...';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingIndicator(
              message: message,
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text(message));
      expect(textWidget.textAlign, equals(TextAlign.center));
      expect(textWidget.style?.color, equals(AppColors.onSurfaceVariant));
    });

    testWidgets('should have correct spacing between indicator and message', (tester) async {
      // Arrange
      const message = 'Loading data...';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingIndicator(
              message: message,
            ),
          ),
        ),
      );

      // Assert
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsNWidgets(2)); // One for size, one for spacing
      
      final spacingSizedBox = tester.widget<SizedBox>(sizedBoxes.last);
      expect(spacingSizedBox.height, equals(16));
    });
  });

  group('TDLoadingOverlay Widget Tests', () {
    testWidgets('should display child when not loading', (tester) async {
      // Arrange
      const childText = 'Child Content';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingOverlay(
              isLoading: false,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(childText), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should display loading overlay when loading', (tester) async {
      // Arrange
      const childText = 'Child Content';
      const loadingMessage = 'Loading...';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingOverlay(
              isLoading: true,
              loadingMessage: loadingMessage,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(childText), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(loadingMessage), findsOneWidget);
    });

    testWidgets('should display loading overlay without message when loading', (tester) async {
      // Arrange
      const childText = 'Child Content';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingOverlay(
              isLoading: true,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(childText), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsOneWidget); // Only child text, no loading message
    });

    testWidgets('should display loading overlay with custom overlay color', (tester) async {
      // Arrange
      const childText = 'Child Content';
      const customOverlayColor = Colors.blue;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingOverlay(
              isLoading: true,
              overlayColor: customOverlayColor,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(childText), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      final coloredBox = tester.widget<ColoredBox>(find.byType(ColoredBox));
      expect(coloredBox.color, equals(customOverlayColor));
    });

    testWidgets('should use default overlay color when not specified', (tester) async {
      // Arrange
      const childText = 'Child Content';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingOverlay(
              isLoading: true,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Assert
      final coloredBox = tester.widget<ColoredBox>(find.byType(ColoredBox));
      expect(coloredBox.color, equals(Colors.black.withValues(alpha: 0.3)));
    });

    testWidgets('should maintain child widget state when loading', (tester) async {
      // Arrange
      const childText = 'Child Content';
      const loadingMessage = 'Loading...';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingOverlay(
              isLoading: true,
              loadingMessage: loadingMessage,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(childText), findsOneWidget);
      expect(find.text(loadingMessage), findsOneWidget);
      
      // Verify the child is still in the widget tree
      final textWidget = tester.widget<Text>(find.text(childText));
      expect(textWidget.data, equals(childText));
    });

    testWidgets('should handle loading state changes', (tester) async {
      // Arrange
      const childText = 'Child Content';
      const loadingMessage = 'Loading...';

      // Act - Start with loading false
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingOverlay(
              isLoading: false,
              loadingMessage: loadingMessage,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Assert - No loading indicator
      expect(find.text(childText), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Act - Change to loading true
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TDLoadingOverlay(
              isLoading: true,
              loadingMessage: loadingMessage,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Assert - Loading indicator appears
      expect(find.text(childText), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(loadingMessage), findsOneWidget);
    });
  });
}

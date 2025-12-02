import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_eqif_new/shared/widgets/toggle.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('Toggle Widget Tests', () {
    testWidgets('renders with provided labels', (WidgetTester tester) async {
      // Arrange
      final labels = ['Option 1', 'Option 2'];

      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          Toggle(
            labels: labels,
            onToggle: (_) {},
          ),
        ),
      );

      // Assert
      expect(find.text('OPTION 1'), findsOneWidget);
      expect(find.text('OPTION 2'), findsOneWidget);
    });

    testWidgets('calls onToggle when tapped', (WidgetTester tester) async {
      // Arrange
      final labels = ['Income', 'Expense'];
      String? selectedValue;

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          Toggle(
            labels: labels,
            onToggle: (value) => selectedValue = value,
          ),
        ),
      );

      // Act
      await tester.tap(find.text('EXPENSE'));
      await tester.pump();

      // Assert
      expect(selectedValue, equals('Expense'));
    });

    testWidgets('switches between options correctly',
        (WidgetTester tester) async {
      // Arrange
      final labels = ['Option A', 'Option B', 'Option C'];
      final selectedValues = <String>[];

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          Toggle(
            labels: labels,
            onToggle: (value) => selectedValues.add(value),
          ),
        ),
      );

      // Act - Tap multiple options
      await tester.tap(find.text('OPTION B'));
      await tester.pump();
      await tester.tap(find.text('OPTION C'));
      await tester.pump();
      await tester.tap(find.text('OPTION A'));
      await tester.pump();

      // Assert
      expect(selectedValues, equals(['Option B', 'Option C', 'Option A']));
    });

    testWidgets('handles two labels correctly', (WidgetTester tester) async {
      // Arrange
      final labels = ['Yes', 'No'];

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          Toggle(
            labels: labels,
            onToggle: (_) {},
          ),
        ),
      );

      // Assert - Both options should be visible
      expect(find.text('YES'), findsOneWidget);
      expect(find.text('NO'), findsOneWidget);

      // Assert - Container should have correct structure
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(GestureDetector), findsNWidgets(2));
    });

    testWidgets('renders with custom number of labels',
        (WidgetTester tester) async {
      // Arrange
      final labels = ['1', '2', '3', '4'];

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          Toggle(
            labels: labels,
            onToggle: (_) {},
          ),
        ),
      );

      // Assert
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });
  });
}

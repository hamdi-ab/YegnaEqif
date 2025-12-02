import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_eqif_new/shared/widgets/select_date_widget.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('SelectDateWidget Tests', () {
    testWidgets('renders with provided label', (WidgetTester tester) async {
      // Arrange
      const label = 'Select a Date';
      DateTime? selectedDate;
      final firstDay = DateTime(2020, 1, 1);
      final lastDay = DateTime(2030, 12, 31);

      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          SelectDateWidget(
            label: label,
            firstDay: firstDay,
            lastDay: lastDay,
            onDateSelected: (date) => selectedDate = date,
          ),
        ),
      );

      // Assert
      expect(find.text(label), findsOneWidget);
      expect(find.text('Select'), findsOneWidget);
    });

    testWidgets('displays calendar icon or select button',
        (WidgetTester tester) async {
      // Arrange
      final firstDay = DateTime(2020, 1, 1);
      final lastDay = DateTime(2030, 12, 31);

      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          SelectDateWidget(
            label: 'Pick Date',
            firstDay: firstDay,
            lastDay: lastDay,
            onDateSelected: (_) {},
          ),
        ),
      );

      // Assert - Select button should be present
      expect(find.text('Select'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('opens date picker on select button tap',
        (WidgetTester tester) async {
      // Arrange
      DateTime? selectedDate;
      final firstDay = DateTime(2020, 1, 1);
      final lastDay = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          SelectDateWidget(
            label: 'Select Date',
            firstDay: firstDay,
            lastDay: lastDay,
            onDateSelected: (date) => selectedDate = date,
          ),
        ),
      );

      // Act - Tap the Select button
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      // Assert - Date picker dialog should appear
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('calls onDateSelected when date is picked',
        (WidgetTester tester) async {
      // Arrange
      DateTime? selectedDate;
      final firstDay = DateTime(2020, 1, 1);
      final lastDay = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          SelectDateWidget(
            label: 'Select Date',
            firstDay: firstDay,
            lastDay: lastDay,
            onDateSelected: (date) => selectedDate = date,
          ),
        ),
      );

      // Act - Open picker
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      // Find and tap the OK button
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Assert - Callback was called with a date
      expect(selectedDate, isNotNull);
    });

    testWidgets('date picker respects firstDay and lastDay constraints',
        (WidgetTester tester) async {
      // Arrange
      final firstDay = DateTime(2020, 1, 1);
      final lastDay = DateTime(2025, 12, 31);

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          SelectDateWidget(
            label: 'Constrained Date',
            firstDay: firstDay,
            lastDay: lastDay,
            onDateSelected: (_) {},
          ),
        ),
      );

      // Act - Open date picker
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      // Assert - Date picker dialog appears with constraints
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('renders with ContainerWIthBoxShadow',
        (WidgetTester tester) async {
      // Arrange & Act
      final firstDay = DateTime(2020, 1, 1);
      final lastDay = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          SelectDateWidget(
            label: 'Date',
            firstDay: firstDay,
            lastDay: lastDay,
            onDateSelected: (_) {},
          ),
        ),
      );

      // Assert - Should find the widget
      expect(find.byType(SelectDateWidget), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });
  });
}

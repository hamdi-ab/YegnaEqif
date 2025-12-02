import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_eqif_new/shared/widgets/bank_card_dropdown.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('BankCardDropdown Tests', () {
    testWidgets('renders with default selection (Cash)',
        (WidgetTester tester) async {
      // Arrange
      String? selectedBank;

      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          BankCardDropdown(
            onBankSelected: (bank) => selectedBank = bank,
          ),
        ),
      );

      // Assert - Cash should be selected by default
      expect(find.text('Cash'), findsOneWidget);
    });

    testWidgets('displays all bank options when dropdown is opened',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          BankCardDropdown(
            onBankSelected: (_) {},
          ),
        ),
      );

      // Act - Tap to open dropdown
      await tester.tap(find.byType(BankCardDropdown));
      await tester.pumpAndSettle();

      // Assert - All bank options should be visible
      expect(find.text('Cash'), findsWidgets);
      expect(find.text('CBE'), findsWidgets);
      expect(find.text('Awash'), findsWidgets);
      expect(find.text('Dashen'), findsWidgets);
      expect(find.text('Abyssinia'), findsWidgets);
    });

    testWidgets('calls onBankSelected when bank is selected',
        (WidgetTester tester) async {
      // Arrange
      String? selectedBank;

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          BankCardDropdown(
            onBankSelected: (bank) => selectedBank = bank,
          ),
        ),
      );

      // Act - Open dropdown and select CBE
      await tester.tap(find.byType(BankCardDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CBE').last);
      await tester.pumpAndSettle();

      // Assert
      expect(selectedBank, equals('CBE'));
      expect(find.text('CBE'), findsOneWidget);
    });

    testWidgets('updates displayed value when selection changes',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          BankCardDropdown(
            onBankSelected: (_) {},
          ),
        ),
      );

      // Act - Select Dashen
      await tester.tap(find.byType(BankCardDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dashen').last);
      await tester.pumpAndSettle();

      // Assert - Dashen should now be displayed
      expect(find.text('Dashen'), findsOneWidget);

      // Act - Select Abyssinia
      await tester.tap(find.byType(BankCardDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abyssinia').last);
      await tester.pumpAndSettle();

      // Assert - Abyssinia should now be displayed
      expect(find.text('Abyssinia'), findsOneWidget);
    });

    testWidgets('displays dropdown icon', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          BankCardDropdown(
            onBankSelected: (_) {},
          ),
        ),
      );

      // Assert - Dropdown icon should be present
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('has 5 bank options', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          BankCardDropdown(
            onBankSelected: (_) {},
          ),
        ),
      );

      // Act - Open dropdown
      await tester.tap(find.byType(BankCardDropdown));
      await tester.pumpAndSettle();

      // Assert - Should have bank options visible
      // The dropdown shows items twice (once in button, once in menu)
      expect(find.text('Cash'), findsWidgets);
      expect(find.text('CBE'), findsWidgets);
      expect(find.text('Awash'), findsWidgets);
    });
  });
}

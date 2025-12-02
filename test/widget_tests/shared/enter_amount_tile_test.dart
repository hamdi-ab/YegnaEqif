import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_eqif_new/shared/widgets/enter_amount_tile.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('EnterAmountTile Tests', () {
    testWidgets('renders with hint text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          EnterAmountTile(
            onAmountSaved: (_) {},
          ),
        ),
      );

      // Assert
      expect(find.text('Enter Amount'), findsOneWidget);
    });

    testWidgets('displays money icon', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          EnterAmountTile(
            onAmountSaved: (_) {},
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });

    testWidgets('accepts numeric input', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          EnterAmountTile(
            onAmountSaved: (_) {},
          ),
        ),
      );

      // Act - Enter a number
      await tester.enterText(find.byType(TextFormField), '123.45');
      await tester.pump();

      // Assert - Input should be displayed
      expect(find.text('123.45'), findsOneWidget);
    });

    testWidgets('calls onAmountSaved when text changes',
        (WidgetTester tester) async {
      // Arrange
      String? savedAmount;

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          EnterAmountTile(
            onAmountSaved: (amount) => savedAmount = amount,
          ),
        ),
      );

      // Act - Enter amount
      await tester.enterText(find.byType(TextFormField), '500');
      await tester.pump();

      // Assert
      expect(savedAmount, equals('500'));
      expect(find.text('500'), findsOneWidget);
    });

    testWidgets('validates empty input', (WidgetTester tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          Form(
            key: formKey,
            child: EnterAmountTile(
              onAmountSaved: (_) {},
            ),
          ),
        ),
      );

      // Act - Validate without entering text
      final isValid = formKey.currentState!.validate();

      await tester.pump();

      // Assert
      expect(isValid, isFalse);
      expect(find.text('Please enter an amount'), findsOneWidget);
    });

    testWidgets('validates non-numeric input', (WidgetTester tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          Form(
            key: formKey,
            child: EnterAmountTile(
              onAmountSaved: (_) {},
            ),
          ),
        ),
      );

      // Act - Enter invalid text
      await tester.enterText(find.byType(TextFormField), 'abc');
      final isValid = formKey.currentState!.validate();
      await tester.pump();

      // Assert
      expect(isValid, isFalse);
      expect(find.text('Please enter a valid number'), findsOneWidget);
    });

    testWidgets('accepts valid numeric input', (WidgetTester tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          Form(
            key: formKey,
            child: EnterAmountTile(
              onAmountSaved: (_) {},
            ),
          ),
        ),
      );

      // Act - Enter valid amount
      await tester.enterText(find.byType(TextFormField), '1234.56');
      final isValid = formKey.currentState!.validate();
      await tester.pump();

      // Assert
      expect(isValid, isTrue);
      expect(find.text('Please enter an amount'), findsNothing);
      expect(find.text('Please enter a valid number'), findsNothing);
    });
  });
}

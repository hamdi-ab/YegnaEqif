import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_eqif_new/shared/widgets/forms/container_with_box_shadow.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('ContainerWithBoxShadow Tests', () {
    testWidgets('renders with child widget', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(
            child: Text('Test Content'),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('applies default margin and padding',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(
            child: Text('Content'),
          ),
        ),
      );

      // Assert - Widget should render
      final container = tester.widget<Container>(
        find.byType(Container),
      );

      expect(container.margin, equals(const EdgeInsets.all(0)));
      expect(container.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('applies custom margin', (WidgetTester tester) async {
      // Arrange
      const customMargin = EdgeInsets.all(20);

      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(
            margin: customMargin,
            child: Text('Content'),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.byType(Container),
      );

      expect(container.margin, equals(customMargin));
    });

    testWidgets('applies custom padding', (WidgetTester tester) async {
      // Arrange
      const customPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);

      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(
            padding: customPadding,
            child: Text('Content'),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.byType(Container),
      );

      expect(container.padding, equals(customPadding));
    });

    testWidgets('renders with custom width and height',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(
            width: 200,
            height: 100,
            child: Text('Content'),
          ),
        ),
      );

      // Assert - Widget renders successfully with dimensions
      expect(find.byType(ContainerWithBoxShadow), findsOneWidget);
    });

    testWidgets('applies default white background color',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(
            child: Text('Content'),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.byType(Container),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.white));
    });

    testWidgets('applies custom background color', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(
            color: Colors.blue,
            child: Text('Content'),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.byType(Container),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.blue));
    });

    testWidgets('applies default border radius', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(
            child: Text('Content'),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.byType(Container),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(
        decoration.borderRadius,
        equals(const BorderRadius.all(Radius.circular(8))),
      );
    });

    testWidgets('has box shadow by default', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(
            child: Text('Content'),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.byType(Container),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, equals(1));
    });

    testWidgets('renders without child', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.wrapWithMaterialApp(
          const ContainerWithBoxShadow(),
        ),
      );

      // Assert - Should render without error
      expect(find.byType(ContainerWithBoxShadow), findsOneWidget);
    });
  });
}

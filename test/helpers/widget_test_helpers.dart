import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Helper utilities for widget testing
class WidgetTestHelpers {
  /// Wraps a widget with MaterialApp for testing
  static Widget wrapWithMaterialApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Wraps a widget with MaterialApp and Provider for testing
  static Widget wrapWithProviders<T extends ChangeNotifier>({
    required Widget child,
    required T Function() create,
  }) {
    return MaterialApp(
      home: ChangeNotifierProvider<T>(
        create: (_) => create(),
        child: Scaffold(
          body: child,
        ),
      ),
    );
  }

  /// Wraps a widget with MaterialApp and MultiProvider for testing
  static Widget wrapWithMultiProviders({
    required Widget child,
    required List<ChangeNotifierProvider> providers,
  }) {
    return MaterialApp(
      home: MultiProvider(
        providers: providers,
        child: Scaffold(
          body: child,
        ),
      ),
    );
  }

  /// Pumps a widget and waits for all animations to settle
  static Future<void> pumpAndSettle(
    WidgetTester tester,
    Widget widget, {
    Duration duration = const Duration(milliseconds: 100),
  }) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(duration);
  }

  /// Finds a widget by type
  static Finder findWidgetByType<T>() {
    return find.byType(T);
  }

  /// Finds a widget by key
  static Finder findWidgetByKey(Key key) {
    return find.byKey(key);
  }

  /// Finds text in the widget tree
  static Finder findText(String text) {
    return find.text(text);
  }

  /// Taps a widget and pumps
  static Future<void> tapAndPump(
    WidgetTester tester,
    Finder finder, {
    int pumpTimes = 1,
  }) async {
    await tester.tap(finder);
    for (int i = 0; i < pumpTimes; i++) {
      await tester.pump();
    }
  }

  /// Enters text into a text field
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Verifies that a widget exists
  static void expectWidgetExists(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Verifies that a widget does not exist
  static void expectWidgetDoesNotExist(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Verifies that multiple widgets exist
  static void expectWidgetsExist(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }

  /// Waits for a specific duration
  static Future<void> wait(Duration duration) {
    return Future.delayed(duration);
  }

  /// Scrolls to a widget
  static Future<void> scrollTo(
    WidgetTester tester,
    Finder finder, {
    double delta = 300.0,
  }) async {
    await tester.drag(finder, Offset(0, -delta));
    await tester.pump();
  }
}

/// Helper for creating test keys
class TestKeys {
  static const emailField = Key('email_field');
  static const passwordField = Key('password_field');
  static const signInButton = Key('sign_in_button');
  static const signUpButton = Key('sign_up_button');
  static const submitButton = Key('submit_button');
  static const cancelButton = Key('cancel_button');
  static const deleteButton = Key('delete_button');
  static const editButton = Key('edit_button');
  static const saveButton = Key('save_button');
}

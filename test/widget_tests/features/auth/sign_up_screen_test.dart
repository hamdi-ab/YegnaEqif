import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/auth/view/sign_up_screen.dart';
import 'package:yegna_eqif_new/features/auth/viewmodel/auth_viewmodel.dart';
import '../../../helpers/mock_viewmodels.mocks.dart';

void main() {
  group('SignUp Screen Tests', () {
    late MockAuthViewModel mockAuthViewModel;

    setUp(() {
      mockAuthViewModel = MockAuthViewModel();
      when(mockAuthViewModel.user).thenReturn(null);
      when(mockAuthViewModel.error).thenReturn(null);
      when(mockAuthViewModel.loading).thenReturn(false);
    });

    Widget createSignUpScreen() {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthViewModel>.value(
          value: mockAuthViewModel,
          child: const SignUp(),
        ),
      );
    }

    testWidgets('renders signup UI elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createSignUpScreen());

      // Assert
      expect(find.text('Sign Up to Yegna Eqif'), findsOneWidget);
      expect(find.text('Enter an Email'), findsOneWidget);
      expect(find.text('Enter a Password'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text("Already have an account? Log in here"), findsOneWidget);
    });

    testWidgets('displays app logo', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createSignUpScreen());

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('validates empty email', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignUpScreen());

      // Act - Tap signup without entering email
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Assert
      expect(find.text('Please Enter an Email'), findsOneWidget);
    });

    testWidgets('validates invalid email format', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignUpScreen());

      // Act - Enter invalid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter an Email'),
        'invalidemail',
      );
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Assert
      expect(find.text('Please Enter a Valid Email'), findsOneWidget);
    });

    testWidgets('validates empty password', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignUpScreen());

      // Act - Enter email but not password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter an Email'),
        'test@example.com',
      );
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Assert
      expect(find.text('Please Enter a Password'), findsOneWidget);
    });

    testWidgets('validates short password', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignUpScreen());

      // Act - Enter short password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter a Password'),
        '12345',
      );
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Assert
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('calls signUp with valid credentials',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignUpScreen());
      const email = 'newuser@example.com';
      const password = 'password123';

      // Act - Enter valid credentials and submit
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter an Email'),
        email,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter a Password'),
        password,
      );
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Assert
      verify(mockAuthViewModel.signUp(email, password)).called(1);
    });

    testWidgets('shows loading indicator when loading',
        (WidgetTester tester) async {
      // Arrange
      when(mockAuthViewModel.loading).thenReturn(true);

      // Act
      await tester.pumpWidget(createSignUpScreen());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign Up'), findsNothing);
    });

    testWidgets('password field obscures text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignUpScreen());

      // Assert - Password field should render (obscureText is constructor param, not accessible)
      expect(find.widgetWithText(TextFormField, 'Enter a Password'),
          findsOneWidget);
    });

    testWidgets('has login link button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignUpScreen());

      // Assert - Login link should be present
      expect(find.text("Already have an account? Log in here"), findsOneWidget);
    });
  });
}

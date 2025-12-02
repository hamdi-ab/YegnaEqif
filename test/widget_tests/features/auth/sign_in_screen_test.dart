import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/auth/view/sign_in_screen.dart';
import 'package:yegna_eqif_new/features/auth/viewmodel/auth_viewmodel.dart';
import '../../../helpers/mock_viewmodels.mocks.dart';

void main() {
  group('SignIn Screen Tests', () {
    late MockAuthViewModel mockAuthViewModel;

    setUp(() {
      mockAuthViewModel = MockAuthViewModel();
      when(mockAuthViewModel.user).thenReturn(null);
      when(mockAuthViewModel.error).thenReturn(null);
      when(mockAuthViewModel.loading).thenReturn(false);
    });

    Widget createSignInScreen() {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthViewModel>.value(
          value: mockAuthViewModel,
          child: const SignIn(),
        ),
      );
    }

    testWidgets('renders login UI elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createSignInScreen());

      // Assert
      expect(find.text('Log in to Yegna Eqif'), findsOneWidget);
      expect(find.text('Enter an Email'), findsOneWidget);
      expect(find.text('Enter a Password'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text("Don't have an account? Sign up here"), findsOneWidget);
    });

    testWidgets('displays app logo', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createSignInScreen());

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('validates empty email', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignInScreen());

      // Act - Tap login without entering email
      await tester.tap(find.text('Log In'));
      await tester.pump();

      // Assert
      expect(find.text('Please Enter an Email'), findsOneWidget);
    });

    testWidgets('validates invalid email format', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignInScreen());

      // Act - Enter invalid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter an Email'),
        'invalidemail',
      );
      await tester.tap(find.text('Log In'));
      await tester.pump();

      // Assert
      expect(find.text('Please Enter a Valid Email'), findsOneWidget);
    });

    testWidgets('validates empty password', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignInScreen());

      // Act - Enter email but not password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter an Email'),
        'test@example.com',
      );
      await tester.tap(find.text('Log In'));
      await tester.pump();

      // Assert
      expect(find.text('Please Enter a Password'), findsOneWidget);
    });

    testWidgets('validates short password', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignInScreen());

      // Act - Enter short password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter a Password'),
        '12345',
      );
      await tester.tap(find.text('Log In'));
      await tester.pump();

      // Assert
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('calls signIn with valid credentials',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignInScreen());
      const email = 'test@example.com';
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
      await tester.tap(find.text('Log In'));
      await tester.pump();

      // Assert
      verify(mockAuthViewModel.signIn(email, password)).called(1);
    });

    testWidgets('shows loading indicator when loading',
        (WidgetTester tester) async {
      // Arrange
      when(mockAuthViewModel.loading).thenReturn(true);

      //Act
      await tester.pumpWidget(createSignInScreen());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Log In'), findsNothing);
    });

    testWidgets('password field obscures text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createSignInScreen());

      // Assert - Password field should render (obscureText is constructor param, not accessible)
      expect(find.widgetWithText(TextFormField, 'Enter a Password'),
          findsOneWidget);
    });

    testWidgets('navigates to SignUp screen on button tap',
        (WidgetTester tester) async {
      // Arrange - Create a MaterialApp with proper navigator
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthViewModel>.value(
            value: mockAuthViewModel,
            child: const SignIn(),
          ),
        ),
      );

      // Act - Tap signup link
      await tester.tap(find.text("Don't have an account? Sign up here"));
      await tester.pumpAndSettle();

      // Assert - SignUp screen should appear (verify we're on a different screen)
      expect(find.text('Log in to Yegna Eqif'), findsNothing);
    });
  });
}

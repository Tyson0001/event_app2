import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:event_management_app/main.dart';

void main() {
  testWidgets('Initial screen shows login form', (WidgetTester tester) async {
    // Build our app and trigger a frame without the const keyword
    await tester.pumpWidget(MyApp());

    // Verify that the Login Page is displayed.
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Expecting 2 fields: Username and Password
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets('Username and password are submitted', (WidgetTester tester) async {
    // Build our app and trigger a frame without the const keyword
    await tester.pumpWidget(MyApp());

    // Enter username and password
    await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Tap the login button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    // Here, you could verify the result of the login action.
    // For example, you might check that the user is navigated to the home page
    // or check that an error message is displayed if the login fails.
  });

  testWidgets('Registration form shows correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame without the const keyword
    await tester.pumpWidget(MyApp());

    // Tap to navigate to the Registration Page
    await tester.tap(find.text('Register')); // Assuming there is a way to navigate
    await tester.pumpAndSettle();

    // Verify that the Registration Page is displayed.
    expect(find.text('Register'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4)); // Expecting 4 fields: Username, Email, Password, Confirm Password
    expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
  });
}

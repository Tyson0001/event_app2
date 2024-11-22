import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Event_App2/lib/main.dart'; // Ensure this imports the correct file for your `MyApp`.

void main() {
  testWidgets('Initial screen shows login form', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the Login Page is displayed
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Username and Password fields
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets('Username and password are submitted', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Enter username and password
    await tester.enterText(find.byType(TextFormField).at(0), 'testuser'); // Username field
    await tester.enterText(find.byType(TextFormField).at(1), 'password123'); // Password field

    // Tap the login button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    // Verify navigation or login result here
    // Replace this with an actual assertion based on your app's behavior
    expect(find.text('Login successful'), findsNothing); // Update based on expected outcome
  });

  testWidgets('Registration form shows correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Tap to navigate to the Registration Page
    await tester.tap(find.text('Register')); // Adjust if navigation is via a button or link
    await tester.pumpAndSettle();

    // Verify that the Registration Page is displayed
    expect(find.text('Register'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4)); // Username, Email, Password, Confirm Password fields
    expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_11/ui/app.dart';

void main() {
  testWidgets('Movie app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the home screen elements are displayed
    expect(find.text('Hi User!'), findsOneWidget);
    expect(find.byIcon(Icons.movie), findsWidgets);
    expect(find.text('On trend'), findsOneWidget);
    expect(find.text('Latest trailers'), findsOneWidget);
  });

  testWidgets('Bottom navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify bottom navigation is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Verify all navigation items exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('My lists'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);

    // Tap on Activity tab
    await tester.tap(find.text('Activity'));
    await tester.pump();

    // Verify Activity screen is shown
    expect(find.text('Activity screen'), findsOneWidget);
    expect(find.text('Coming soon...'), findsOneWidget);
  });

  testWidgets('Navigation to auth screens works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );

    // Navigate to Activity tab first to see the auth buttons
    await tester.tap(find.text('Activity'));
    await tester.pump();

    // Verify login and register buttons exist
    expect(find.text('Go to Login'), findsOneWidget);
    expect(find.text('Go to Register'), findsOneWidget);

    // Test navigation to login
    await tester.tap(find.text('Go to Login'));
    await tester.pumpAndSettle();

    // Verify login screen is displayed
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });

  testWidgets('Categories are displayed correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify category chips are displayed
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('Series'), findsOneWidget);
    expect(find.text('Popular actors'), findsOneWidget);
  });

  testWidgets('Movie cards are displayed in sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify section titles
    expect(find.text('On trend'), findsOneWidget);
    expect(find.text('Latest trailers'), findsOneWidget);
    
    // Verify movie card placeholder text exists
    expect(find.text('Lorem ipsum'), findsWidgets);
  });
}

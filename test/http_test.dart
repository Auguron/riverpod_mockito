import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod_mockito/constants.dart';

import 'package:riverpod_mockito/main.dart';
import 'package:riverpod_mockito/services/http_service.dart';

import 'mocks/http_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  testWidgets('200 response increments', (WidgetTester tester) async {
    final client = MockClient();
    when(client.get(url200)).thenAnswer(
      (value) async {
        return http.Response('{"title": "Test"}', 200);
      },
    );
    when(client.get(url400)).thenAnswer(
      (value) async {
        return http.Response('{"title": "Test"}', 400);
      },
    );
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          httpProvider.overrideWithValue(client),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    // verify(client.get(url200)).called(1);
    // verify(client.get(url400)).called(1);
    await tester.pumpAndSettle();

    verifyInOrder([
      client.get(url200),
      client.get(url400),
    ]);
    verifyNoMoreInteractions(client);
  });

  testWidgets('400 response decrements', (WidgetTester tester) async {
    final client = MockClient();
    when(client.get(url200)).thenAnswer(
      (value) async {
        return http.Response('{"title": "Test"}', 400);
      },
    );
    when(client.get(url400)).thenAnswer(
      (value) async {
        return http.Response('{"title": "Test"}', 400);
      },
    );
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          httpProvider.overrideWithValue(client),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('-1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('-1'), findsOneWidget);
  });
}

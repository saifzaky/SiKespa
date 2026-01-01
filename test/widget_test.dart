// SiKespa Widget Tests
// Tests for the SiKespa application

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sikespa/main.dart';

void main() {
  testWidgets('MyApp builds without error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

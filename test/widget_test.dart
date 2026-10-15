// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cuaca_kalteng/main.dart';
import 'package:cuaca_kalteng/weather_model.dart';

void main() {
  testWidgets('shows the Central Kalimantan weather screen', (tester) async {
    await tester.pumpWidget(const WeatherApp());

    expect(find.text('Cuaca Kalimantan Tengah'), findsOneWidget);
    expect(find.text('Pilih Kabupaten / Kota'), findsOneWidget);
    expect(find.text('Palangkaraya (Ibu Kota)'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<KaltengCity>));
    await tester.pumpAndSettle();

    expect(find.text('Buntok (Barito Selatan)'), findsOneWidget);
    expect(find.text('Puruk Cahu (Murung Raya)'), findsOneWidget);
  });
}

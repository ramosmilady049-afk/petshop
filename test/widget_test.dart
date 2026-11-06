import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:proyecto_pet_shop/main.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const PetShopApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

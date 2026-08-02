import 'package:duo_trend_app/core/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('usa NavigationBar y navega en ancho móvil', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      createTestApp(initialLocation: RoutePaths.home),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    await tester.tap(find.text('Balance').last);
    await tester.pumpAndSettle();

    expect(find.text('Flujo de caja separado de la utilidad contable.'), findsOneWidget);
  });

  testWidgets('usa NavigationRail en ancho de escritorio', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      createTestApp(initialLocation: RoutePaths.inventory),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('El catálogo todavía está vacío'), findsOneWidget);
  });
}

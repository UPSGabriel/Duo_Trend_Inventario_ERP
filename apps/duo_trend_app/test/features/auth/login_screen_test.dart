import 'package:duo_trend_app/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('login comunica que OAuth está pendiente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Integración pendiente'), findsOneWidget);
    expect(find.text('Continuar con Google'), findsOneWidget);

    await tester.tap(find.text('Continuar con Google'));
    await tester.pumpAndSettle();

    expect(find.text('Google OAuth aún no está habilitado'), findsOneWidget);
    expect(find.textContaining('No se creó ninguna sesión'), findsOneWidget);
  });

  testWidgets('la vista previa declara que no crea sesión', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('open-navigation-preview')), findsOneWidget);
  });
}

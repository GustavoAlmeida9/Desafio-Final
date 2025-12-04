import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_crud_app/main.dart';

void main() {
  testWidgets('App inicializa corretamente', (WidgetTester tester) async {
    // Carrega o widget principal
    await tester.pumpWidget(const MyApp());

    // Verifica se o AppBar com título "CRUD App" está presente
    expect(find.text('CRUD App'), findsOneWidget);

    // Verifica se há pelo menos um FloatingActionButton
    expect(find.byType(FloatingActionButton), findsWidgets);
  });
}

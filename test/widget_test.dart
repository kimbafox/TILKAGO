import 'package:flutter_test/flutter_test.dart';

import 'package:tilkago/main.dart';

void main() {
  testWidgets('shows the Tilka wallet dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const TilkaApp());

    expect(find.text('Saldo disponible'), findsOneWidget);
    expect(find.text('Operaciones rápidas'), findsOneWidget);
    expect(find.text('Bs 5000.00'), findsOneWidget);
  });
}

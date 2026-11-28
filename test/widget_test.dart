import 'package:flutter_test/flutter_test.dart';
import 'package:dughry/main.dart';

void main() {
  testWidgets('DUGHRY opens with its Arabic brand message', (tester) async {
    await tester.pumpWidget(const DughryApp());
    await tester.pumpAndSettle();

    expect(find.text('كل احتياجاتك في مكان واحد'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_store_ui/app/grocery_app.dart';

void main() {
  testWidgets('shows Lumi Grocery splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: GroceryApp()));
    expect(find.text('Lumi Grocery'), findsOneWidget);
  });
}

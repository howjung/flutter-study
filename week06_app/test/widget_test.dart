import 'package:flutter_test/flutter_test.dart';

import 'package:week06_app/main.dart';

void main() {
  testWidgets('데모 페이지가 렌더링된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Flutter 위젯 데모'), findsOneWidget);
    expect(find.text('1. Container / Padding / Align / Center'), findsOneWidget);
  });
}

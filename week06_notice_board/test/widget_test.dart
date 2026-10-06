import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week06_notice_board/main.dart';

void main() {
  testWidgets('AC1, AC2, AC5: 로딩, 성공, 중복 방지', (tester) async {
    await tester.pumpWidget(const NoticeApp());
    await tester.tap(find.byKey(const Key('load')));
    await tester.pump();
    expect(find.text('상태: loading'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byKey(const Key('load')));
    expect(button.onPressed, isNull);
    await tester.tap(find.byKey(const Key('load')));
    await tester.pump();
    expect(find.text('요청 횟수: 1'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('상태: success'), findsOneWidget);
    expect(find.text('6주차 실습 자료가 열렸습니다.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('AC3, AC4: 실패와 재시도', (tester) async {
    await tester.pumpWidget(const NoticeApp());
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('load')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('상태: failure'), findsOneWidget);
    expect(find.text('공지를 불러오지 못했습니다.'), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('load')));
    await tester.pump();
    expect(find.text('공지를 불러오지 못했습니다.'), findsNothing);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('상태: success'), findsOneWidget);
    expect(find.text('요청 횟수: 2'), findsOneWidget);
  });

  testWidgets('확장: 요청 중 화면 제거 뒤 예외 없음', (tester) async {
    await tester.pumpWidget(const NoticeApp());
    await tester.tap(find.byKey(const Key('load')));
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });
}

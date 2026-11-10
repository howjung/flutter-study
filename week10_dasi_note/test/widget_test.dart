import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week10_dasi_note/main.dart';

/// 화면 크기를 정해서 앱을 띄운다. (size는 논리 픽셀)
Future<void> pumpApp(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const DasiNoteApp());
}

void main() {
  const phone = Size(390, 780);
  const pc = Size(1100, 780);

  // PRD 완료 기준 AC1: 앱 첫 실행 (저장된 데이터 없음)
  testWidgets('AC1: 첫 실행에는 제목, 빈 상태 안내, 오답 적기 버튼이 보인다',
      (WidgetTester tester) async {
    await pumpApp(tester, phone);

    expect(find.text('다시노트'), findsOneWidget);
    expect(find.text('복습 0 / 0'), findsOneWidget);
    expect(find.text('아직 기록한 오답이 없습니다'), findsOneWidget);
    expect(find.text('＋ 오답 적기'), findsOneWidget);
  });

  // AC17: 폰에서는 사이드바가 접혀 있고 ☰로 열린다
  testWidgets('AC17(폰): 사이드바가 접혀 있다가 ☰를 누르면 열린다',
      (WidgetTester tester) async {
    await pumpApp(tester, phone);

    expect(find.text('복습 모드'), findsNothing);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('오답노트'), findsWidgets);
    expect(find.text('복습 모드'), findsOneWidget);
  });

  // AC17: PC에서는 처음부터 펼쳐져 있다
  testWidgets('AC17(PC): 사이드바가 처음부터 펼쳐져 있고 ☰로 접을 수 있다',
      (WidgetTester tester) async {
    await pumpApp(tester, pc);

    expect(find.text('복습 모드'), findsOneWidget);
    expect(find.text('틀린 것, 중요한 것만 모아 다시 보기'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('복습 모드'), findsNothing);
  });

  // AC18 중 첫 실행 부분: 오답이 없으면 요약 카드가 모두 0
  testWidgets('AC18(일부): 오답이 없으면 요약 카드 숫자가 모두 0이다',
      (WidgetTester tester) async {
    await pumpApp(tester, pc);

    expect(find.text('전체 오답'), findsOneWidget);
    expect(find.text('복습 전'), findsOneWidget);
    expect(find.text('복습 완료'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(3));
  });

  // AC19: 준비 중 메뉴를 눌러도 화면이 바뀌지 않는다
  testWidgets('AC19: 복습 모드·통계를 눌러도 화면이 그대로이고 준비 중 표시만 있다',
      (WidgetTester tester) async {
    await pumpApp(tester, pc);

    expect(find.text('준비 중'), findsNWidgets(2));
    await tester.tap(find.text('복습 모드'));
    await tester.tap(find.text('통계'));
    await tester.pumpAndSettle();

    expect(find.text('오답노트 › 전체'), findsOneWidget);
    expect(find.text('아직 기록한 오답이 없습니다'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// 주의: 프로젝트 이름이 promise_time이 아니면 아래 import의 이름을 바꿔야 한다.
import 'package:promise_time/main.dart';

// 화면 흐름 테스트: 디자인을 바꿔도 AC가 보는 문구와 동작이 그대로인지 확인한다.
// 시각 선택기는 키보드 입력 모드로 바꿔 시·분을 직접 입력한다.

const String guide = '오늘 정한 시각과 실제로 한 시각을 선택해 주세요';
const String missing = '목표 시각과 실제 시각을 모두 입력해 주세요';
const String targetLabel = '오늘 정한 시각은?';
const String actualLabel = '실제로 한 시각은?';

Future<void> pickTime(
  WidgetTester tester,
  String label,
  int hour,
  int minute,
) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.keyboard_outlined)); // 키보드 입력 모드
  await tester.pumpAndSettle();
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), hour.toString().padLeft(2, '0'));
  await tester.enterText(fields.at(1), minute.toString().padLeft(2, '0'));
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> record(WidgetTester tester) async {
  await tester.tap(find.text('기록'));
  await tester.pumpAndSettle();
}

Future<void> startApp(WidgetTester tester) async {
  // 기본 테스트 화면은 낮아서 ListView가 아래쪽 기록을 그리지 않는다.
  // 휴대폰처럼 세로로 긴 화면을 쓴다.
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const PromiseTimeApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('AC1 첫 화면: 안내, 취침 기본, 두 칸 미선택, 0건, 기록 없음', (tester) async {
    await startApp(tester);

    expect(find.text(guide), findsOneWidget);
    expect(find.text('취침'), findsOneWidget);
    expect(find.text('출근'), findsOneWidget);
    expect(find.text(targetLabel), findsOneWidget);
    expect(find.text(actualLabel), findsOneWidget);
    expect(find.text('선택 안 함'), findsNWidgets(2));
    expect(find.text('이번 실행 중 기록 목록 · 0건'), findsOneWidget);
    expect(find.text('앱을 다시 실행하면 사라져요'), findsOneWidget);
    expect(find.text('아직 기록이 없어요'), findsOneWidget);
    expect(find.text(missing), findsNothing);

    // 종류의 기본값은 취침
    final segmented = tester.widget<SegmentedButton<dynamic>>(
      find.byWidgetPredicate((w) => w is SegmentedButton),
    );
    expect(segmented.selected.single.toString(), contains('bedtime'));
  });

  testWidgets('AC5 한쪽이라도 비면 안내만 보이고 0건 유지', (tester) async {
    await startApp(tester);

    // 두 칸 모두 비움
    await record(tester);
    expect(find.text(missing), findsOneWidget);
    expect(find.text('이번 실행 중 기록 목록 · 0건'), findsOneWidget);
    expect(find.text('아직 기록이 없어요'), findsOneWidget);

    // 목표만 비움 (실제만 선택)
    await pickTime(tester, actualLabel, 2, 40);
    await record(tester);
    expect(find.text(missing), findsOneWidget);
    expect(find.text('이번 실행 중 기록 목록 · 0건'), findsOneWidget);
    expect(find.text('아직 기록이 없어요'), findsOneWidget);
  });

  testWidgets('AC5 실제만 비운 경우도 0건 유지', (tester) async {
    await startApp(tester);

    await pickTime(tester, targetLabel, 3, 0); // 목표만 선택
    await record(tester);
    expect(find.text(missing), findsOneWidget);
    expect(find.text('이번 실행 중 기록 목록 · 0건'), findsOneWidget);
  });

  testWidgets('AC2·AC3·AC4·AC6 차례로 기록하면 건수가 1→2→3→4, 최신이 위', (tester) async {
    await startApp(tester);

    // AC2 취침 01:23 / 02:40
    await pickTime(tester, targetLabel, 1, 23);
    await pickTime(tester, actualLabel, 2, 40);
    await record(tester);
    expect(find.text('77분 늦었어요'), findsOneWidget); // 결과 카드
    expect(find.text('이번 실행 중 기록 목록 · 1건'), findsOneWidget);
    expect(find.text('취침 · 목표 01:23 · 실제 02:40 · 77분 늦었어요'), findsOneWidget);
    expect(find.text('아직 기록이 없어요'), findsNothing);
    expect(find.text(missing), findsNothing);

    // AC3 실제만 23:40
    await pickTime(tester, actualLabel, 23, 40);
    await record(tester);
    expect(find.text('103분 일찍 했어요'), findsOneWidget);
    expect(find.text('이번 실행 중 기록 목록 · 2건'), findsOneWidget);
    expect(
      find.text('취침 · 목표 01:23 · 실제 23:40 · 103분 일찍 했어요'),
      findsOneWidget,
    );

    // AC4 출근 17:00 / 17:03
    await tester.tap(find.text('출근'));
    await tester.pumpAndSettle();
    await pickTime(tester, targetLabel, 17, 0);
    await pickTime(tester, actualLabel, 17, 3);
    await record(tester);
    expect(find.text('3분 늦었어요'), findsOneWidget);
    expect(find.text('이번 실행 중 기록 목록 · 3건'), findsOneWidget);
    expect(
      find.text('출근 · 목표 17:00 · 실제 17:03 · 3분 늦었어요'),
      findsOneWidget,
    );

    // AC6 실제만 17:00
    await pickTime(tester, actualLabel, 17, 0);
    await record(tester);
    expect(find.text('목표 시각에 맞췄어요'), findsOneWidget); // 결과 카드
    expect(find.text('이번 실행 중 기록 목록 · 4건'), findsOneWidget);

    // 최신 기록이 위, 오래된 기록이 아래
    final lines = [
      '출근 · 목표 17:00 · 실제 17:00 · 목표 시각에 맞췄어요',
      '출근 · 목표 17:00 · 실제 17:03 · 3분 늦었어요',
      '취침 · 목표 01:23 · 실제 23:40 · 103분 일찍 했어요',
      '취침 · 목표 01:23 · 실제 02:40 · 77분 늦었어요',
    ];
    final ys = [
      for (final l in lines) tester.getTopLeft(find.text(l)).dy,
    ];
    for (var i = 0; i < ys.length - 1; i++) {
      expect(ys[i], lessThan(ys[i + 1]), reason: '${lines[i]} 가 ${lines[i + 1]} 보다 위에 있어야 함');
    }
  });

  testWidgets('AC7 같은 입력을 두 번 기록하면 2건, 같은 줄 2개', (tester) async {
    await startApp(tester);

    await pickTime(tester, targetLabel, 1, 23);
    await pickTime(tester, actualLabel, 2, 40);
    await record(tester);
    await record(tester);

    expect(find.text('이번 실행 중 기록 목록 · 2건'), findsOneWidget);
    expect(
      find.text('취침 · 목표 01:23 · 실제 02:40 · 77분 늦었어요'),
      findsNWidgets(2),
    );
  });

  testWidgets('시각 선택기는 24시간제(오전/오후 없음)', (tester) async {
    await startApp(tester);

    await tester.tap(find.text(targetLabel));
    await tester.pumpAndSettle();
    expect(find.text('OK'), findsOneWidget); // 선택기가 실제로 열렸는지
    expect(find.text('AM'), findsNothing);
    expect(find.text('PM'), findsNothing);
    // 다이얼 숫자는 직접 그린 그림이라 글자로 찾을 수 없다.
    // 24시간제(23시 입력 가능)는 위 AC3 테스트의 23:40 입력이 확인한다.
  });
}

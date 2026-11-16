import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// 주의: 프로젝트 이름이 promise_time이 아니면 아래 import의 이름을 바꿔야 한다.
import 'package:promise_time/time_wheel_sheet.dart';

// 아래에서 올라오는 휠 시각 선택기의 동작을 확인한다. (24시간제, 한글 버튼, 확인/취소)

/// 시트를 여는 버튼 하나만 있는 작은 앱. 결과는 [result]에 담긴다.
class Harness {
  TimeOfDay? result;
  bool closed = false;

  Widget build(TimeOfDay initial) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () async {
              result = await showTimeWheelSheet(context, initial);
              closed = true;
            },
            child: const Text('열기'),
          ),
        ),
      ),
    );
  }
}

Future<void> open(WidgetTester tester, Harness h, TimeOfDay initial) async {
  await tester.pumpWidget(h.build(initial));
  await tester.tap(find.text('열기'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('시트가 열리고 한글 제목과 확인·취소 버튼이 보인다 (오전/오후 없음)', (tester) async {
    final h = Harness();
    await open(tester, h, const TimeOfDay(hour: 1, minute: 23));

    expect(find.text('시각을 골라 주세요'), findsOneWidget);
    expect(find.text('확인'), findsOneWidget);
    expect(find.text('취소'), findsOneWidget);
    expect(find.text('AM'), findsNothing);
    expect(find.text('PM'), findsNothing);
    expect(find.text('오전'), findsNothing);
    expect(find.text('오후'), findsNothing);
    // 시와 분 두 개의 휠
    expect(find.byType(CupertinoPicker), findsNWidgets(2));
  });

  testWidgets('제목을 따로 주면 그 제목이 보인다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => showTimeWheelSheet(
                context,
                const TimeOfDay(hour: 1, minute: 23),
                title: '정한 시각 선택',
              ),
              child: const Text('열기'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();

    expect(find.text('정한 시각 선택'), findsOneWidget);
    expect(find.text('시각을 골라 주세요'), findsNothing);
  });

  testWidgets('휠을 돌리지 않고 확인하면 처음 시각이 그대로 선택된다', (tester) async {
    final h = Harness();
    await open(tester, h, const TimeOfDay(hour: 1, minute: 23));

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(h.closed, isTrue);
    expect(h.result, const TimeOfDay(hour: 1, minute: 23));
  });

  testWidgets('취소하면 null', (tester) async {
    final h = Harness();
    await open(tester, h, const TimeOfDay(hour: 1, minute: 23));

    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();

    expect(h.closed, isTrue);
    expect(h.result, isNull);
  });

  testWidgets('분 휠을 돌리면 선택한 분이 바뀐다', (tester) async {
    final h = Harness();
    await open(tester, h, const TimeOfDay(hour: 1, minute: 23));

    // 한 칸의 높이는 32. 위로 2칸 끌면 분이 2 늘어난다.
    await tester.drag(find.byType(CupertinoPicker).at(1), const Offset(0, -64));
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(h.result, const TimeOfDay(hour: 1, minute: 25));
  });

  testWidgets('시 휠을 돌리면 선택한 시가 바뀌고 분은 그대로', (tester) async {
    final h = Harness();
    await open(tester, h, const TimeOfDay(hour: 1, minute: 23));

    await tester.drag(find.byType(CupertinoPicker).at(0), const Offset(0, -96));
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(h.result, const TimeOfDay(hour: 4, minute: 23));
  });

  testWidgets('자정 근처도 고를 수 있다 (23시에서 위로 돌리면 0시)', (tester) async {
    final h = Harness();
    await open(tester, h, const TimeOfDay(hour: 23, minute: 40));

    await tester.drag(find.byType(CupertinoPicker).at(0), const Offset(0, -32));
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(h.result, const TimeOfDay(hour: 0, minute: 40));
  });

  testWidgets('이미 고른 시각이 있으면 그 시각에서 시작한다', (tester) async {
    TimeOfDay? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                result = await pickTimeWithWheel(
                  context,
                  const TimeOfDay(hour: 17, minute: 3),
                  '실제 시각 선택',
                );
              },
              child: const Text('열기'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(result, const TimeOfDay(hour: 17, minute: 3));
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week05_app1/main.dart';
import 'package:week05_app1/main1.dart' as focus_app;
import 'package:week05_app1/main2.dart' as lunar_app;
import 'package:week05_app1/rabbit.dart' as rabbit_app;
import 'package:week05_app1/main3.dart' as memory_app;

void main() {
  testWidgets('tapping tasks updates completion and remaining count', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('2'), findsOneWidget);
    expect(find.text('5주차 강의 복습'), findsOneWidget);
    expect(find.text('상태 흐름도 작성'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('task-toggle-0')));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('취소'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('task-toggle-1')));
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
    expect(find.text('취소'), findsNWidgets(2));
  });

  testWidgets('focus timer updates duration, pause, and reset state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const focus_app.FocusTimerApp());

    expect(find.text('25:00'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('decrease-duration')));
    await tester.pump();
    expect(find.text('20분'), findsOneWidget);
    expect(find.text('20:00'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('timer-toggle')));
    await tester.pump();
    expect(find.text('잠시 멈춤'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('19:59'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('timer-toggle')));
    await tester.pump();
    expect(find.text('집중 시작'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('timer-reset')));
    await tester.pump();
    expect(find.text('20:00'), findsOneWidget);
  });

  testWidgets('lunar station actions update resources and shift progress', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const lunar_app.LunarShiftApp());

    expect(find.text('78%'), findsOneWidget);
    expect(find.text('62%'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('greenhouse-action')));
    await tester.tap(find.byKey(const ValueKey('greenhouse-action')));
    await tester.pump();

    expect(find.text('91%'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('end-shift')));
    await tester.tap(find.byKey(const ValueKey('end-shift')));
    await tester.pump();

    expect(find.text('77%'), findsOneWidget);
    expect(find.text('39%'), findsOneWidget);
    expect(find.text('교대 2'), findsOneWidget);
  });

  testWidgets('memory game counts attempts and resets the board', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const memory_app.MemoryMatchApp());

    expect(find.text('0 / 6'), findsOneWidget);
    expect(find.text('0번'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('memory-card-0')));
    await tester.tap(find.byKey(const ValueKey('memory-card-0')));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const ValueKey('memory-card-1')));
    await tester.tap(find.byKey(const ValueKey('memory-card-1')));
    await tester.pump();

    expect(find.text('1번'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('new-memory-game')));
    await tester.tap(find.byKey(const ValueKey('new-memory-game')));
    await tester.pump();

    expect(find.text('0 / 6'), findsOneWidget);
    expect(find.text('0번'), findsOneWidget);
  });

  testWidgets('market search filters products and images zoom on hover', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const rabbit_app.RabbitMarketApp());

    expect(find.text('“애플” 중고거래 검색 결과'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('product-tile-airpods-max')),
      findsOneWidget,
    );

    final imageKey = const ValueKey('product-image-hover-0');
    final scaleKey = const ValueKey('product-image-scale-0');
    expect(tester.widget<AnimatedScale>(find.byKey(scaleKey)).scale, 1);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.byKey(imageKey)));
    await tester.pump();
    expect(tester.widget<AnimatedScale>(find.byKey(scaleKey)).scale, 1.08);

    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(tester.widget<AnimatedScale>(find.byKey(scaleKey)).scale, 1);

    await tester.enterText(
      find.byKey(const ValueKey('market-search-field')),
      '아이폰',
    );
    await tester.pump();
    expect(
      find.byKey(const ValueKey('product-tile-iphone-13-mini')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('product-tile-airpods-max')),
      findsNothing,
    );
  });
}

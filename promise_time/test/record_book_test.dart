import 'package:flutter_test/flutter_test.dart';
// 주의: 프로젝트 이름이 promise_time이 아니면 아래 import의 이름을 바꿔야 한다.
import 'package:promise_time/gap_record.dart';
import 'package:promise_time/time_gap.dart';

/// "HH:MM" 문자열을 하루 기준 분으로 바꾸는 테스트용 도우미
int m(String hhmm) {
  final parts = hhmm.split(':');
  return toMinutes(int.parse(parts[0]), int.parse(parts[1]));
}

GapRecord bed(String target, String actual) => GapRecord(
      kind: RecordKind.bedtime,
      targetMin: m(target),
      actualMin: m(actual),
    );

GapRecord work(String target, String actual) => GapRecord(
      kind: RecordKind.work,
      targetMin: m(target),
      actualMin: m(actual),
    );

void main() {
  group('GapRecord (기록 한 건)', () {
    test('AC2 취침 01:23 -> 02:40: 77분 늦었어요, 목록 줄', () {
      final r = bed('01:23', '02:40');
      expect(r.gapMin, 77);
      expect(r.message, '77분 늦었어요');
      expect(r.summary, '취침 · 목표 01:23 · 실제 02:40 · 77분 늦었어요');
    });

    test('AC3 자정 경계 01:23 -> 23:40: 103분 일찍 했어요', () {
      final r = bed('01:23', '23:40');
      expect(r.gapMin, -103);
      expect(r.summary, '취침 · 목표 01:23 · 실제 23:40 · 103분 일찍 했어요');
    });

    test('AC4 출근 17:00 -> 17:03: 3분 늦었어요', () {
      final r = work('17:00', '17:03');
      expect(r.summary, '출근 · 목표 17:00 · 실제 17:03 · 3분 늦었어요');
    });

    test('AC6 출근 17:00 -> 17:00: 목표 시각에 맞췄어요', () {
      final r = work('17:00', '17:00');
      expect(r.summary, '출근 · 목표 17:00 · 실제 17:00 · 목표 시각에 맞췄어요');
    });

    test('종류는 계산에 영향을 주지 않는다 (같은 시각이면 같은 차이)', () {
      expect(bed('17:00', '17:03').gapMin, work('17:00', '17:03').gapMin);
    });

    test('종류 이름표', () {
      expect(RecordKind.bedtime.label, '취침');
      expect(RecordKind.work.label, '출근');
    });
  });

  group('RecordBook (이번 실행 중 기록 목록)', () {
    test('처음에는 건수 0, 목록 비어 있음', () {
      final book = RecordBook();
      expect(book.count, 0);
      expect(book.items, isEmpty);
    });

    test('추가하면 건수가 정확히 1 늘어난다', () {
      final book = RecordBook();
      book.add(bed('01:23', '02:40'));
      expect(book.count, 1);
      book.add(work('17:00', '17:03'));
      expect(book.count, 2);
    });

    test('AC7 같은 기록을 두 번 추가하면 2건 (합치지 않음)', () {
      final book = RecordBook();
      final r = bed('01:23', '02:40');
      book.add(r);
      book.add(r);
      expect(book.count, 2);
      expect(book.items[0].summary, book.items[1].summary);
    });

    test('같은 내용의 서로 다른 기록 객체도 2건', () {
      final book = RecordBook();
      book.add(bed('01:23', '02:40'));
      book.add(bed('01:23', '02:40'));
      expect(book.count, 2);
    });

    test('새 기록을 추가해도 기존 기록은 그대로다', () {
      final book = RecordBook();
      final first = bed('01:23', '02:40');
      book.add(first);
      book.add(work('17:00', '17:03'));

      final old = book.items[1];
      expect(old, same(first));
      expect(old.kind, RecordKind.bedtime);
      expect(old.targetMin, m('01:23'));
      expect(old.actualMin, m('02:40'));
      expect(old.gapMin, 77);
    });

    test('최신 기록이 인덱스 0에 온다', () {
      final book = RecordBook();
      final first = bed('01:23', '02:40');
      final second = work('17:00', '17:03');
      book.add(first);
      book.add(second);
      expect(book.items[0], same(second));
      expect(book.items[1], same(first));
    });

    test('건수와 목록 길이는 항상 같다 (여러 번 추가)', () {
      final book = RecordBook();
      expect(book.count, book.items.length);
      for (var i = 0; i < 5; i++) {
        book.add(bed('01:23', '02:40'));
        expect(book.count, book.items.length);
      }
      expect(book.count, 5);
    });

    test('바깥에서 items로 목록을 직접 바꿀 수 없다', () {
      final book = RecordBook();
      book.add(bed('01:23', '02:40'));
      expect(() => book.items.add(work('17:00', '17:00')),
          throwsUnsupportedError);
      expect(() => book.items.removeLast(), throwsUnsupportedError);
      expect(book.count, 1);
    });
  });
}

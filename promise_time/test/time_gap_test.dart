import 'package:flutter_test/flutter_test.dart';
// 주의: 프로젝트 이름이 promise_time이 아니면 아래 import의 이름을 바꿔야 한다.
import 'package:promise_time/time_gap.dart';

/// "HH:MM" 문자열을 하루 기준 분으로 바꾸는 테스트용 도우미
int m(String hhmm) {
  final parts = hhmm.split(':');
  return toMinutes(int.parse(parts[0]), int.parse(parts[1]));
}

void main() {
  group('timeGapMinutes (PRD v8 계산 규칙)', () {
    test('AC2 취침 01:23 -> 02:40 = +77', () {
      expect(timeGapMinutes(m('01:23'), m('02:40')), 77);
    });

    test('AC3 자정 경계: 01:23 -> 23:40 = -103', () {
      expect(timeGapMinutes(m('01:23'), m('23:40')), -103);
    });

    test('자정 넘김: 23:30 -> 01:10 = +100', () {
      expect(timeGapMinutes(m('23:30'), m('01:10')), 100);
    });

    test('AC4 출근 17:00 -> 17:03 = +3', () {
      expect(timeGapMinutes(m('17:00'), m('17:03')), 3);
    });

    test('일찍 도착 17:00 -> 16:58 = -2', () {
      expect(timeGapMinutes(m('17:00'), m('16:58')), -2);
    });

    test('AC6 같은 시각 = 0', () {
      expect(timeGapMinutes(m('17:00'), m('17:00')), 0);
    });

    test('정확히 12시간은 어느 방향이든 +720 (늦게)', () {
      expect(timeGapMinutes(m('17:00'), m('05:00')), 720);
      expect(timeGapMinutes(m('05:00'), m('17:00')), 720);
    });

    test('12시간 + 1분은 반대 방향(-719)으로 계산된다 (한계)', () {
      expect(timeGapMinutes(m('00:00'), m('12:01')), -719);
    });
  });

  group('gapMessage', () {
    test('늦음', () => expect(gapMessage(77), '77분 늦었어요'));
    test('일찍', () => expect(gapMessage(-103), '103분 일찍 했어요'));
    test('0분', () => expect(gapMessage(0), '목표 시각에 맞췄어요'));
    test('720분', () => expect(gapMessage(720), '720분 늦었어요'));
  });

  group('formatHm', () {
    test('항상 두 자리 24시간제', () {
      expect(formatHm(1, 5), '01:05');
      expect(formatHm(23, 40), '23:40');
      expect(formatHm(0, 0), '00:00');
    });
  });
}

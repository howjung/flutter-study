// 약속 시각 기록: 시각 차이 계산 (순수 Dart, Flutter에 의존하지 않음)
// 기준 문서: week10/PRD.md (v8)

/// 시각(시, 분)을 하루 기준 분(0~1439)으로 바꾼다.
int toMinutes(int hour, int minute) => hour * 60 + minute;

/// 목표 시각과 실제 시각의 차이를 분 단위로 계산한다.
/// - 양수 = 목표보다 늦음, 음수 = 목표보다 일찍
/// - 날짜는 받지 않으므로 하루(1440분) 안에서 "가장 짧은 방향"으로만 계산한다.
///   (실제 오차가 12시간을 넘어도 판별할 수 없다 — PRD 5절 한계)
/// - 정확히 720분(12시간) 차이는 방향과 무관하게 +720(늦게)으로 처리한다.
int timeGapMinutes(int targetMin, int actualMin) {
  // 1) 실제 - 목표를 0~1439 범위로 맞춘다.
  //    Dart의 %는 피제수가 음수여도 결과가 0 이상이라 자정 넘김이 처리된다.
  var gap = (actualMin - targetMin) % 1440;
  // 2) 720을 넘으면 반대 방향이 더 짧으므로 음수로 바꾼다. (720은 그대로 +720)
  if (gap > 720) gap -= 1440;
  return gap;
}

/// 차이(분)를 사용자에게 보여 줄 문구로 바꾼다. (종류와 무관하게 동일)
String gapMessage(int gap) {
  if (gap > 0) return '$gap분 늦었어요';
  if (gap < 0) return '${-gap}분 일찍 했어요';
  return '목표 시각에 맞췄어요';
}

/// 시각을 항상 24시간제 "HH:mm"으로 만든다. (시스템 지역 설정의 AM/PM 표기 방지)
String formatHm(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

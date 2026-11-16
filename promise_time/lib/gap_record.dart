// 약속 시각 기록: 기록 한 건(GapRecord)과 이번 실행 중 기록 목록(RecordBook)
// 순수 Dart (Flutter에 의존하지 않음). 기준 문서: docs/PRD.md

import 'time_gap.dart';

/// 기록의 종류. 목록에서 구분하는 이름표이며 차이 계산에는 영향을 주지 않는다.
/// 문자열 대신 enum을 쓰면 "취침" 같은 값의 오타 상태를 만들 수 없다.
enum RecordKind {
  bedtime('취침'),
  work('출근');

  const RecordKind(this.label);

  /// 화면에 보여 줄 이름
  final String label;
}

/// 기록 한 건. 모든 필드가 final이라 기록한 뒤 값이 바뀌지 않는다.
/// 차이(분)와 문구는 저장하지 않고 필요할 때 계산하므로 값이 서로 어긋날 수 없다.
class GapRecord {
  const GapRecord({
    required this.kind,
    required this.targetMin,
    required this.actualMin,
  })  : assert(targetMin >= 0 && targetMin < 1440),
        assert(actualMin >= 0 && actualMin < 1440);

  final RecordKind kind;

  /// 목표 시각 (하루 기준 분, 0~1439)
  final int targetMin;

  /// 실제 시각 (하루 기준 분, 0~1439)
  final int actualMin;

  /// 차이(분). 양수 = 목표보다 늦음, 음수 = 일찍 (PRD v8 계산 규칙)
  int get gapMin => timeGapMinutes(targetMin, actualMin);

  /// 결과 문구. 예: "77분 늦었어요"
  String get message => gapMessage(gapMin);

  String get targetText => formatHm(targetMin ~/ 60, targetMin % 60);

  String get actualText => formatHm(actualMin ~/ 60, actualMin % 60);

  /// 목록에 보여 줄 한 줄. 예: "취침 · 목표 01:23 · 실제 02:40 · 77분 늦었어요"
  String get summary =>
      '${kind.label} · 목표 $targetText · 실제 $actualText · $message';
}

/// 이번 실행 중 기록 목록. 앱을 다시 실행하면 사라진다(메모리에만 보관).
/// 목록에 관한 규칙만 맡고, 입력 검증(빈 시각 등)은 화면이 한 뒤
/// 완성된 GapRecord만 넘긴다.
class RecordBook {
  final List<GapRecord> _items = [];

  /// 기록 건수. 화면의 "N건"은 별도 값을 두지 않고 반드시 이 값에서 바로 만든다.
  int get count => _items.length;

  /// 읽기 전용 목록. 최신 기록이 index 0.
  /// 바깥에서 add/remove로 건수 규칙을 우회할 수 없다.
  List<GapRecord> get items => List.unmodifiable(_items);

  /// 새 기록을 맨 앞에 넣는다. 같은 내용이어도 한 건으로 합치지 않는다.
  void add(GapRecord record) {
    _items.insert(0, record);
  }
}

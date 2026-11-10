/// 틀린 문제 하나.
///
/// [question]은 필수(문제 요약), [reason]은 선택이라 비어 있을 수 있다.
/// [done]은 복습 여부이며 누를 때마다 바뀐다 (PRD R4).
class Mistake {
  Mistake({
    required this.id,
    required this.subjectId,
    required this.question,
    this.reason = '',
    this.done = false,
  });

  final int id;
  final int subjectId;
  final String question;
  final String reason;
  bool done;
}

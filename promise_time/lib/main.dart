import 'package:flutter/material.dart';

import 'gap_record.dart';
import 'time_gap.dart';

// 약속 시각 기록 — 10주차 첫 화면 + 11주차 기록 목록 정리 + 12주차 발표용 화면 정리
// 범위: 종류 선택 -> 목표·실제 시각 선택 -> 차이 표시 -> 이번 실행 중 기록 목록
// 역할 분리: 입력 검증은 이 화면(main.dart)이 하고, 목록 규칙은 RecordBook이 맡는다.
// 하지 않는 것: 저장, 알림, 날짜 입력, 지킴 판정, 여러 화면, 서버, 추가 패키지
//
// 화면 정리(디자인)는 기능과 AC 문구를 바꾸지 않고 색·여백·카드·아이콘만 다듬은 것이다.

// 차분한 남색 계열의 기록 도구 느낌. 추가 패키지 없이 Material 3만 사용한다.
const Color _seed = Color(0xFF4A56A6);
const Color _background = Color(0xFFF3F5FA);

void main() => runApp(const PromiseTimeApp());

class PromiseTimeApp extends StatelessWidget {
  const PromiseTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '약속 시각 기록',
      theme: ThemeData(
        colorSchemeSeed: _seed,
        useMaterial3: true,
        scaffoldBackgroundColor: _background,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String guide = '오늘 정한 시각과 실제로 한 시각을 선택해 주세요';
  static const String missingMessage = '목표 시각과 실제 시각을 모두 입력해 주세요';

  // ----- 상태 -----
  RecordKind kind = RecordKind.bedtime; // 기본값 취침 (PRD v7 확정)
  TimeOfDay? target; // 선택 전에는 null
  TimeOfDay? actual; // 선택 전에는 null
  String? error; // 입력 안내(오류) 문구
  final RecordBook recordBook = RecordBook(); // 이번 실행 중 기록 (최신이 맨 앞)

  // 시각 선택기: 24시간제로 강제해 23:40 같은 값을 고르기 쉽게 한다.
  Future<TimeOfDay?> _pickTime(TimeOfDay? current) {
    return showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
  }

  Future<void> _selectTarget() async {
    final picked = await _pickTime(target);
    if (picked == null || !mounted) return; // 취소했거나 화면이 사라진 경우
    setState(() => target = picked);
  }

  Future<void> _selectActual() async {
    final picked = await _pickTime(actual);
    if (picked == null || !mounted) return;
    setState(() => actual = picked);
  }

  // "기록" 버튼: 입력 검증(화면) -> 완성된 기록 만들기 -> 목록에 추가(RecordBook)
  void _record() {
    final t = target;
    final a = actual;

    // 하나라도 비어 있으면 결과를 만들지 않고 목록에도 추가하지 않는다. (AC5)
    if (t == null || a == null) {
      setState(() => error = missingMessage);
      return;
    }

    // 검증을 통과한 값으로만 GapRecord를 만든다. 만든 뒤에는 값이 바뀌지 않는다.
    final record = GapRecord(
      kind: kind,
      targetMin: toMinutes(t.hour, t.minute),
      actualMin: toMinutes(a.hour, a.minute),
    );

    setState(() {
      error = null;
      // 최신 기록을 맨 앞에 추가. 선택한 시각은 그대로 유지한다.
      recordBook.add(record);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 결과 카드는 가장 최근 기록을 보여 준다. 별도 상태를 두지 않고 목록에서 바로 읽는다.
    final latest = recordBook.count == 0 ? null : recordBook.items.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('약속 시각 기록'),
        centerTitle: true,
        backgroundColor: _background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Center(
          // 넓은 화면(Chrome)에서도 휴대폰처럼 한 줄 폭으로 보이게 한다.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  guide, // R1 안내 문구
                  style: textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),

                // R1 종류 선택 (기본: 취침)
                SegmentedButton<RecordKind>(
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.white,
                    selectedBackgroundColor: scheme.primaryContainer,
                  ),
                  segments: [
                    for (final k in RecordKind.values)
                      ButtonSegment(value: k, label: Text(k.label)),
                  ],
                  selected: {kind},
                  onSelectionChanged: (s) => setState(() => kind = s.first),
                ),
                const SizedBox(height: 16),

                // R1 시각 선택 두 칸 (카드형)
                Row(
                  children: [
                    Expanded(
                      child: _TimeCard(
                        label: '오늘 정한 시각은?',
                        value: target,
                        onTap: _selectTarget,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TimeCard(
                        label: '실제로 한 시각은?',
                        value: actual,
                        onTap: _selectActual,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // R2 기록 버튼 (화면 폭을 채우는 하나의 강한 버튼)
                FilledButton(
                  onPressed: _record,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('기록'),
                ),

                // R4 입력 안내(오류)
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            size: 18, color: scheme.error),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            error!,
                            style: TextStyle(color: scheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),

                // R2 결과 (카드)
                if (latest != null) _ResultCard(record: latest),

                // R3 기록 목록. 건수는 별도 값 없이 recordBook.count에서 바로 만든다.
                const SizedBox(height: 28),
                Text(
                  '이번 실행 중 기록 목록 · ${recordBook.count}건',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '앱을 다시 실행하면 사라져요',
                  style: textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                if (recordBook.count == 0)
                  const _EmptyState()
                else
                  for (final r in recordBook.items) _RecordTile(record: r),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 라벨 + 시각을 담은 카드. 누르면 시각 선택기가 열린다.
/// 선택 전에는 "선택 안 함"을 흐린 글자로 보여 준다.
class _TimeCard extends StatelessWidget {
  const _TimeCard({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final TimeOfDay? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final v = value;
    final text = v == null ? '선택 안 함' : formatHm(v.hour, v.minute);

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelLarge
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: v == null ? scheme.outline : scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 가장 최근 기록의 결과 문구를 크게 보여 주는 카드.
/// 늦었으면 붉은 계열, 일찍 했거나 맞췄으면 남색 계열로 구분한다.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.record});

  final GapRecord record;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLate = record.gapMin > 0;
    final background = isLate ? scheme.errorContainer : scheme.primaryContainer;
    final foreground =
        isLate ? scheme.onErrorContainer : scheme.onPrimaryContainer;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isLate ? Icons.schedule : Icons.check_circle_outline,
            color: foreground,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              record.message,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 기록이 없을 때: 작은 시계 아이콘과 "아직 기록이 없어요"
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 40, color: scheme.outline),
          const SizedBox(height: 8),
          Text(
            '아직 기록이 없어요',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// 기록 한 줄. 줄 문구(summary)는 그대로 두고 종류 아이콘만 앞에 붙인다.
class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});

  final GapRecord record;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: ListTile(
        leading: Icon(
          record.kind == RecordKind.bedtime
              ? Icons.bedtime_outlined
              : Icons.work_outline,
          color: scheme.primary,
        ),
        title: Text(record.summary),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'time_gap.dart';

// 약속 시각 기록 — 10주차 첫 화면 (기준: week10/PRD.md v8)
// 범위: 종류 선택 -> 목표·실제 시각 선택 -> 차이 표시 -> 이번 실행 중 기록 목록
// 하지 않는 것: 저장, 알림, 날짜 입력, 지킴 판정, 여러 화면, 서버, 추가 패키지

void main() => runApp(const PromiseTimeApp());

class PromiseTimeApp extends StatelessWidget {
  const PromiseTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '약속 시각 기록',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

/// 기록 한 건. 앱을 다시 실행하면 사라진다(메모리에만 보관).
class GapRecord {
  const GapRecord({
    required this.kind,
    required this.target,
    required this.actual,
    required this.message,
  });

  final String kind; // 취침 / 출근 (목록 구분용 이름표, 계산에는 영향 없음)
  final String target; // "HH:mm"
  final String actual; // "HH:mm"
  final String message; // 예: "77분 늦었어요"
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
  String kind = '취침'; // 기본값 취침 (PRD v7 확정)
  TimeOfDay? target; // 선택 전에는 null
  TimeOfDay? actual; // 선택 전에는 null
  String? result; // 가장 최근 결과 문구
  String? error; // 입력 안내(오류) 문구
  final List<GapRecord> records = []; // 이번 실행 중 기록 (최신이 맨 앞)

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

  // "기록" 버튼: 입력 검증 -> 차이 계산 -> 상태 갱신
  void _record() {
    final t = target;
    final a = actual;

    // 하나라도 비어 있으면 결과를 만들지 않고 목록에도 추가하지 않는다. (AC5)
    if (t == null || a == null) {
      setState(() => error = missingMessage);
      return;
    }

    final gap = timeGapMinutes(
      toMinutes(t.hour, t.minute),
      toMinutes(a.hour, a.minute),
    );
    final message = gapMessage(gap);

    setState(() {
      error = null;
      result = message;
      // 최신 기록을 맨 앞에 추가. 선택한 시각은 그대로 유지한다.
      records.insert(
        0,
        GapRecord(
          kind: kind,
          target: formatHm(t.hour, t.minute),
          actual: formatHm(a.hour, a.minute),
          message: message,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('약속 시각 기록')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(guide), // R1 안내 문구
            const SizedBox(height: 16),

            // R1 종류 선택 (기본: 취침)
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: '취침', label: Text('취침')),
                ButtonSegment(value: '출근', label: Text('출근')),
              ],
              selected: {kind},
              onSelectionChanged: (s) => setState(() => kind = s.first),
            ),
            const SizedBox(height: 16),

            // R1 시각 선택 두 칸
            _TimeField(
              label: '오늘 정한 시각은?',
              value: target,
              onPressed: _selectTarget,
            ),
            const SizedBox(height: 8),
            _TimeField(
              label: '실제로 한 시각은?',
              value: actual,
              onPressed: _selectActual,
            ),
            const SizedBox(height: 16),

            // R2 기록 버튼
            FilledButton(onPressed: _record, child: const Text('기록')),

            // R4 입력 안내(오류)
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),

            // R2 결과
            if (result != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(result!, style: textTheme.headlineSmall),
              ),

            // R3 기록 목록
            const SizedBox(height: 24),
            Text('이번 실행 중 기록 목록', style: textTheme.titleMedium),
            const Text('앱을 다시 실행하면 사라져요'),
            const SizedBox(height: 8),
            if (records.isEmpty)
              const Text('아직 기록이 없어요')
            else
              for (final r in records)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${r.kind} · 목표 ${r.target} · 실제 ${r.actual} · ${r.message}',
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

/// 라벨 + 시각 선택 버튼 한 줄. 선택 전에는 "선택 안 함"을 보여 준다.
class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final TimeOfDay? value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final v = value;
    final text = v == null ? '선택 안 함' : formatHm(v.hour, v.minute);
    return Row(
      children: [
        Expanded(child: Text(label)),
        OutlinedButton(onPressed: onPressed, child: Text(text)),
      ],
    );
  }
}

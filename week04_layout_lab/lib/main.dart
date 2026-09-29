import 'package:flutter/material.dart';

void main() {
  runApp(const GoalLabApp());
}

class GoalLabApp extends StatelessWidget {
  const GoalLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Lab - Week 04',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const GoalBoardScreen(),
    );
  }
}

class Goal {
  final String id;
  final String title;
  final String category;
  String memo; // 메모 상태를 데이터 모델에 포함하여 완벽 보존

  Goal({
    required this.id,
    required this.title,
    required this.category,
    this.memo = '',
  });
}

class GoalBoardScreen extends StatefulWidget {
  const GoalBoardScreen({super.key});

  @override
  State<GoalBoardScreen> createState() => _GoalBoardScreenState();
}

class _GoalBoardScreenState extends State<GoalBoardScreen> {
  List<Goal> goals = [
    Goal(
      id: 'g1',
      title: '플러터 레이아웃 제약 조건(BoxConstraints) 및 반응형 그리드 완벽 이해하기',
      category: 'UI/Layout',
    ),
    Goal(
      id: 'g2',
      title: '위젯 재정렬 시 상태 유지를 위한 ValueKey 적용 실습',
      category: 'Widget Key',
    ),
    Goal(
      id: 'g3',
      title: '공식 문서 및 교재 기반 결정 근거표(EVIDENCE_TABLE) 작성',
      category: 'Documentation',
    ),
  ];

  void _reverseGoals() {
    setState(() {
      goals = goals.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4주차 과제: Layout & Key'),
        centerTitle: true,
        actions: [
          ElevatedButton.icon(
            onPressed: _reverseGoals,
            icon: const Icon(Icons.swap_vert),
            label: const Text('순서 뒤집기'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;

          if (!isWide) {
            // 좁은 화면 (1열)
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: goals
                    .map((goal) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: StudyCard(
                            key: ValueKey(goal.id),
                            goal: goal,
                            onMemoChanged: (val) => goal.memo = val,
                          ),
                        ))
                    .toList(),
              ),
            );
          } else {
            // 넓은 화면 (2열)
            final List<Widget> cardWidgets = goals
                .map((goal) => StudyCard(
                      key: ValueKey(goal.id),
                      goal: goal,
                      onMemoChanged: (val) => goal.memo = val,
                    ))
                .toList();

            List<Widget> rows = [];
            for (int i = 0; i < cardWidgets.length; i += 2) {
              final first = cardWidgets[i];
              final second = (i + 1 < cardWidgets.length)
                  ? cardWidgets[i + 1]
                  : const Expanded(child: SizedBox.shrink());

              rows.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: first),
                      const SizedBox(width: 16.0),
                      if (second is Expanded) second else Expanded(child: second),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: rows),
            );
          }
        },
      ),
    );
  }
}

class StudyCard extends StatefulWidget {
  final Goal goal;
  final ValueChanged<String> onMemoChanged;

  const StudyCard({
    super.key,
    required this.goal,
    required this.onMemoChanged,
  });

  @override
  State<StudyCard> createState() => _StudyCardState();
}

class _StudyCardState extends State<StudyCard> {
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.goal.memo);
  }

  @override
  void didUpdateWidget(covariant StudyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 순서가 변경되거나 위젯이 업데이트될 때 컨트롤러 텍스트를 현재 goal.memo로 동기화
    if (_memoController.text != widget.goal.memo) {
      _memoController.text = widget.goal.memo;
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                widget.goal.category,
                style: const TextStyle(fontSize: 12),
              ),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(height: 8),
            Text(
              widget.goal.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _memoController,
              onChanged: widget.onMemoChanged,
              decoration: const InputDecoration(
                labelText: '메모 입력',
                hintText: '상태 유지 테스트용',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
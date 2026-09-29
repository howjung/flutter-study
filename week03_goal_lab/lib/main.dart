import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyGoal Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GoalLabScreen(),
    );
  }
}

class Goal {
  String title;
  bool isCompleted;

  Goal({required this.title, this.isCompleted = false});
}

class GoalLabScreen extends StatefulWidget {
  const GoalLabScreen({super.key});

  @override
  State<GoalLabScreen> createState() => _GoalLabScreenState();
}

class _GoalLabScreenState extends State<GoalLabScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Goal> _goals = [];

  // AC1, AC2: 목표 추가 및 빈 값 검증
  void _addGoal() {
    final String text = _controller.text.trim();

    // AC2: 빈 값 예외 처리
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('목표를 입력해주세요.')),
      );
      return;
    }

    // AC1: 정상 추가
    setState(() {
      _goals.add(Goal(title: text));
      _controller.clear();
    });
  }

  // AC3: 완료 상태 토글 (_toggleGoal TODO 구현)
  void _toggleGoal(int index) {
    setState(() {
      _goals[index].isCompleted = !_goals[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyGoal Lab'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '새로운 학습 목표 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addGoal,
                  child: const Text('추가'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _goals.isEmpty
                  ? const Center(child: Text('등록된 목표가 없습니다.'))
                  : ListView.builder(
                      itemCount: _goals.length,
                      itemBuilder: (context, index) {
                        final goal = _goals[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: goal.isCompleted,
                              onChanged: (_) => _toggleGoal(index),
                            ),
                            title: Text(
                              goal.title,
                              style: TextStyle(
                                decoration: goal.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: goal.isCompleted
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
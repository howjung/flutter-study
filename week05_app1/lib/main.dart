import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TodoAppScreen(),
    );
  }
}

class TodoAppScreen extends StatefulWidget {
  const TodoAppScreen({super.key});

  @override
  State<TodoAppScreen> createState() => _TodoAppScreenState();
}

class _TodoAppScreenState extends State<TodoAppScreen> {
  final List<String> tasks = const ['5주차 강의 복습', '상태 흐름도 작성'];
  final Set<int> completedTasks = {};

  int get remainingCount => tasks.length - completedTasks.length;

  void toggleTask(int index) {
    setState(() {
      if (!completedTasks.add(index)) {
        completedTasks.remove(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '',
                        style: TextStyle(
                          color: Color(0xFF009688),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    '버튼 한 번에 달라지는 두 곳',
                    style: TextStyle(
                      color: Color(0xFF14253F),
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '첫 할 일을 완료하면 카드 표시와 남은 할 일 수가 함께 바뀝니다.',
                    style: TextStyle(
                      color: Color(0xFF485D78),
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 44),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: _buildTaskCard(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFDFE),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF173451), width: 7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F173451),
            blurRadius: 0,
            offset: Offset(8, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '나의 할 일',
            style: TextStyle(
              color: Color(0xFF14253F),
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFD8E1E8)),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text(
                '남은 할 일 ',
                style: TextStyle(color: Color(0xFF24364D), fontSize: 17),
              ),
              Text(
                '$remainingCount',
                style: const TextStyle(
                  color: Color(0xFF009688),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < tasks.length; index++) ...[
            if (index > 0) const SizedBox(height: 8),
            _buildTaskRow(index),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskRow(int index) {
    final isCompleted = completedTasks.contains(index);

    return Material(
      color: isCompleted ? const Color(0xFFE7F5F2) : Colors.white,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        key: ValueKey('task-toggle-$index'),
        borderRadius: BorderRadius.circular(11),
        onTap: () => toggleTask(index),
        child: Container(
          constraints: const BoxConstraints(minHeight: 54),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD5E0E8)),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            children: [
              Icon(
                isCompleted ? Icons.check : Icons.radio_button_unchecked,
                size: 19,
                color: const Color(0xFF009688),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  tasks[index],
                  style: const TextStyle(
                    color: Color(0xFF14253F),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4F2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCompleted ? '취소' : '완료',
                  style: const TextStyle(
                    color: Color(0xFF007F73),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
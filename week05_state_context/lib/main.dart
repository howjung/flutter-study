import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5주차 과제 - 상태 기능',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TaskStatePage(),
    );
  }
}

class TaskStatePage extends StatefulWidget {
  const TaskStatePage({super.key});

  @override
  State<TaskStatePage> createState() => _TaskStatePageState();
}

class _TaskStatePageState extends State<TaskStatePage> {
  // 1. 원본 상태 (Source of Truth) - 유일하게 저장되는 상태 변수
  bool _isCompleted = false;

  // 2. 계산된 상태값 (Derived State - AC4: 별도 변수로 저장하지 않고 getter 활용)
  String get _statusText => _isCompleted ? "작업 완료됨" : "작업 진행 중";
  Color get _statusColor => _isCompleted ? Colors.green : Colors.orange;
  String get _buttonText => _isCompleted ? "취소하기 (원복)" : "완료하기";

  // 3. 이벤트 처리 함수 (이벤트 -> 상태 변경)
  void _toggleStatus() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5주차 상태 기능과 작업 컨텍스트'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '현재 상태',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            // 계산된 상태값 출력
            Text(
              _statusText,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _statusColor,
              ),
            ),
            const SizedBox(height: 30),
            // 입력 이벤트 버트
            ElevatedButton(
              onPressed: _toggleStatus,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                _buttonText,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
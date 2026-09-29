import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const FocusTimerApp());
}

class FocusTimerApp extends StatelessWidget {
  const FocusTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '집중 타이머',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087F73),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F5EF),
        useMaterial3: true,
      ),
      home: const FocusTimerScreen(),
    );
  }
}

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  static const int _minimumMinutes = 5;
  static const int _maximumMinutes = 60;

  int _selectedMinutes = 25;
  int _remainingSeconds = 25 * 60;
  int _completedSessions = 0;
  Timer? _timer;
  bool _isRunning = false;
  bool _hasCompleted = false;

  int get _totalSeconds => _selectedMinutes * 60;

  String get _timeLabel {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progress =>
      _totalSeconds == 0 ? 0 : 1 - (_remainingSeconds / _totalSeconds);

  void _startTimer() {
    if (_isRunning || _remainingSeconds == 0) return;

    setState(() {
      _isRunning = true;
      _hasCompleted = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
          _isRunning = false;
          _hasCompleted = true;
          _completedSessions++;
        });
        return;
      }

      setState(() => _remainingSeconds--);
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
      _hasCompleted = false;
    });
  }

  void _changeDuration(int change) {
    if (_isRunning) return;
    final updatedMinutes = (_selectedMinutes + change).clamp(
      _minimumMinutes,
      _maximumMinutes,
    );
    if (updatedMinutes == _selectedMinutes) return;

    setState(() {
      _selectedMinutes = updatedMinutes;
      _remainingSeconds = updatedMinutes * 60;
      _hasCompleted = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = _hasCompleted
        ? '집중 완료 · 잠깐 쉬어가요'
        : _isRunning
        ? '지금은 집중하는 시간'
        : '천천히 시작해도 괜찮아요';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCEBE3),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.spa_outlined,
                          color: Color(0xFF087F73),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MOMENT',
                            style: TextStyle(
                              color: Color(0xFF087F73),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            '집중 타이머',
                            style: TextStyle(
                              color: Color(0xFF183A36),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _SessionCounter(count: _completedSessions),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    _hasCompleted ? '잘 해냈어요.' : '지금, 하나에만\n마음을 모아요.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF183A36),
                      fontSize: 30,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox.expand(
                            child: CircularProgressIndicator(
                              value: _progress,
                              strokeWidth: 8,
                              strokeCap: StrokeCap.round,
                              backgroundColor: const Color(0xFFDDE3D9),
                              color: const Color(0xFF087F73),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _timeLabel,
                                key: const ValueKey('timer-label'),
                                style: const TextStyle(
                                  color: Color(0xFF183A36),
                                  fontSize: 58,
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                status,
                                style: const TextStyle(
                                  color: Color(0xFF66736B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        key: const ValueKey('decrease-duration'),
                        tooltip: '5분 줄이기',
                        onPressed: _isRunning
                            ? null
                            : () => _changeDuration(-5),
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        '$_selectedMinutes분',
                        key: const ValueKey('duration-label'),
                        style: const TextStyle(
                          color: Color(0xFF183A36),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 18),
                      IconButton.filledTonal(
                        key: const ValueKey('increase-duration'),
                        tooltip: '5분 늘리기',
                        onPressed: _isRunning ? null : () => _changeDuration(5),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          key: const ValueKey('timer-toggle'),
                          onPressed: _isRunning ? _pauseTimer : _startTimer,
                          icon: Icon(
                            _isRunning ? Icons.pause_rounded : Icons.play_arrow,
                          ),
                          label: Text(_isRunning ? '잠시 멈춤' : '집중 시작'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            backgroundColor: const Color(0xFF087F73),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.outlined(
                        key: const ValueKey('timer-reset'),
                        tooltip: '타이머 초기화',
                        onPressed: _resetTimer,
                        icon: const Icon(Icons.restart_alt),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(54, 54),
                          foregroundColor: const Color(0xFF33524A),
                          side: const BorderSide(color: Color(0xFFB9C7BC)),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '한 번에 한 가지, 지금 할 수 있는 만큼',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF66736B).withValues(alpha: 0.9),
                      fontSize: 13,
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
}

class _SessionCounter extends StatelessWidget {
  const _SessionCounter({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EAE1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 17,
            color: Color(0xFF087F73),
          ),
          const SizedBox(width: 6),
          Text(
            '완료 $count회',
            style: const TextStyle(
              color: Color(0xFF33524A),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

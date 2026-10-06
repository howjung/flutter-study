import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const OmokApp());
}

/// 돌의 색과 현재 차례를 같은 타입으로 다루면, 색을 뒤집거나 비교할 때
/// 문자열보다 실수할 여지가 적다.
enum Stone { black, white }

class OmokApp extends StatelessWidget {
  const OmokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '오목',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const OmokPage(),
    );
  }
}

class OmokPage extends StatefulWidget {
  const OmokPage({super.key});

  @override
  State<OmokPage> createState() => _OmokPageState();
}

class _OmokPageState extends State<OmokPage> {
  static const int _boardSize = 15;
  final List<List<Stone?>> _board = List.generate(
    _boardSize,
    (_) => List<Stone?>.filled(_boardSize, null),
  );
  final List<(int, int)> _moves = [];

  Stone _currentStone = Stone.black;
  Stone? _winner;
  bool _isDraw = false;
  List<(int, int)> _winningLine = [];

  String get _statusText {
    if (_winner == Stone.black) return '흑 승리! 🎉';
    if (_winner == Stone.white) return '백 승리! 🎉';
    if (_isDraw) return '무승부';
    return _currentStone == Stone.black ? '흑 차례' : '백 차례';
  }

  /// 탭한 칸이 비어 있고 게임이 계속 중일 때만 착수한다.
  /// 승리 여부는 "방금 둔 돌"에서만 검사해도 된다. 기존 돌의 연결은
  /// 새 돌을 포함하지 않는 한 직전 수에서도 이미 검사됐기 때문이다.
  void _placeStone(int row, int column) {
    if (_winner != null || _isDraw || _board[row][column] != null) return;

    setState(() {
      final stone = _currentStone;
      _board[row][column] = stone;
      _moves.add((row, column));

      final winningLine = _findWinningLine(row, column, stone);
      if (winningLine != null) {
        _winner = stone;
        _winningLine = winningLine;
      } else if (_moves.length == _boardSize * _boardSize) {
        _isDraw = true;
      } else {
        _currentStone = stone == Stone.black ? Stone.white : Stone.black;
      }
    });
  }

  /// 네 축을 각각 양방향으로 훑어, 가운데의 새 돌을 포함한 연속 구간을 만든다.
  /// 한 방향만 보면 새 돌의 반대편에 이어져 있던 돌을 놓치므로, 양쪽을 모두
  /// 모은 뒤 길이가 5 이상인지 확인한다. 6목 이상도 승리로 인정한다.
  List<(int, int)>? _findWinningLine(int row, int column, Stone stone) {
    const directions = [(0, 1), (1, 0), (1, 1), (1, -1)];

    for (final direction in directions) {
      final before = _collectSameStones(
        row,
        column,
        -direction.$1,
        -direction.$2,
        stone,
      ).reversed.toList();
      final after = _collectSameStones(
        row,
        column,
        direction.$1,
        direction.$2,
        stone,
      );
      final line = [...before, (row, column), ...after];

      if (line.length >= 5) {
        // 6목 이상일 때도 마지막 수가 포함되는 5개를 골라 표시한다.
        final lastMoveIndex = before.length;
        final start = math.min(math.max(0, lastMoveIndex - 4), line.length - 5);
        return line.sublist(start, start + 5);
      }
    }
    return null;
  }

  List<(int, int)> _collectSameStones(
    int row,
    int column,
    int rowStep,
    int columnStep,
    Stone stone,
  ) {
    final stones = <(int, int)>[];
    var nextRow = row + rowStep;
    var nextColumn = column + columnStep;
    while (
        nextRow >= 0 &&
        nextRow < _boardSize &&
        nextColumn >= 0 &&
        nextColumn < _boardSize &&
        _board[nextRow][nextColumn] == stone) {
      stones.add((nextRow, nextColumn));
      nextRow += rowStep;
      nextColumn += columnStep;
    }
    return stones;
  }

  /// 기록의 마지막 좌표만 지우고, 남은 돌 수의 홀짝으로 차례를 다시 계산한다.
  /// 흑이 첫 수(0개일 때)를 두므로 짝수 개가 남으면 흑, 홀수 개면 백 차례다.
  void _undo() {
    if (_moves.isEmpty) return;
    setState(() {
      final lastMove = _moves.removeLast();
      _board[lastMove.$1][lastMove.$2] = null;
      _winner = null;
      _isDraw = false;
      _winningLine = [];
      _currentStone = _moves.length.isEven ? Stone.black : Stone.white;
    });
  }

  void _newGame() {
    setState(() {
      for (final row in _board) {
        row.fillRange(0, _boardSize, null);
      }
      _moves.clear();
      _currentStone = Stone.black;
      _winner = null;
      _isDraw = false;
      _winningLine = [];
    });
  }

  /// 화면 가장자리에 여백을 두고 격자를 그렸기 때문에 같은 여백과 간격을 써서
  /// 로컬 탭 좌표를 가장 가까운 교점으로 반올림한다. clamp로 판 밖 인덱스는 막는다.
  void _handleBoardTap(TapUpDetails details, Size size) {
    const inset = 20.0;
    final cellSize = (size.width - inset * 2) / (_boardSize - 1);
    final column = ((details.localPosition.dx - inset) / cellSize)
        .round()
        .clamp(0, _boardSize - 1);
    final row = ((details.localPosition.dy - inset) / cellSize)
        .round()
        .clamp(0, _boardSize - 1);
    _placeStone(row, column);
  }

  @override
  Widget build(BuildContext context) {
    final shownStone = _winner ?? _currentStone;
    return Scaffold(
      appBar: AppBar(title: const Text('오목')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StoneIndicator(stone: shownStone),
                  const SizedBox(width: 10),
                  Text(_statusText, style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = Size.square(constraints.maxWidth);
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: (details) => _handleBoardTap(details, size),
                          child: CustomPaint(
                            painter: _OmokBoardPainter(
                              board: _board,
                              moves: _moves,
                              winningLine: _winningLine,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _moves.isEmpty ? null : _undo,
                      icon: const Icon(Icons.undo),
                      label: const Text('무르기'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _newGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text('새 게임'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoneIndicator extends StatelessWidget {
  const _StoneIndicator({required this.stone});

  final Stone stone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: stone == Stone.black ? Colors.black : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black54),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 3, offset: Offset(1, 2))],
      ),
    );
  }
}

class _OmokBoardPainter extends CustomPainter {
  const _OmokBoardPainter({
    required this.board,
    required this.moves,
    required this.winningLine,
  });

  final List<List<Stone?>> board;
  final List<(int, int)> moves;
  final List<(int, int)> winningLine;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 20.0;
    final cellSize = (size.width - inset * 2) / 14;
    final boardRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(boardRect, Paint()..color = const Color(0xFFE3B56B));

    final gridPaint = Paint()
      ..color = const Color(0xFF5B3A18)
      ..strokeWidth = 1;
    for (var index = 0; index < 15; index++) {
      final position = inset + index * cellSize;
      canvas.drawLine(Offset(inset, position), Offset(size.width - inset, position), gridPaint);
      canvas.drawLine(Offset(position, inset), Offset(position, size.height - inset), gridPaint);
    }

    final starPaint = Paint()..color = const Color(0xFF3E270F);
    for (final row in [3, 7, 11]) {
      for (final column in [3, 7, 11]) {
        canvas.drawCircle(_point(row, column, cellSize), 3.5, starPaint);
      }
    }

    final radius = cellSize * 0.43;
    for (var row = 0; row < 15; row++) {
      for (var column = 0; column < 15; column++) {
        final stone = board[row][column];
        if (stone == null) continue;
        final center = _point(row, column, cellSize);
        canvas.drawCircle(
          center + const Offset(1.5, 2),
          radius,
          Paint()..color = Colors.black.withValues(alpha: 0.28),
        );
        canvas.drawCircle(
          center,
          radius,
          Paint()..color = stone == Stone.black ? Colors.black : Colors.white,
        );
        if (stone == Stone.white) {
          canvas.drawCircle(center, radius, Paint()..style = PaintingStyle.stroke..color = Colors.black45);
        }
      }
    }

    // 승리한 정확히 다섯 교점을 잇는다. 돌을 모두 그린 뒤에 그려 선이 확실히 보인다.
    if (winningLine.length == 5) {
      final first = winningLine.first;
      final last = winningLine.last;
      canvas.drawLine(
        _point(first.$1, first.$2, cellSize),
        _point(last.$1, last.$2, cellSize),
        Paint()
          ..color = Colors.redAccent
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
    }

    if (moves.isNotEmpty) {
      final lastMove = moves.last;
      canvas.drawCircle(_point(lastMove.$1, lastMove.$2, cellSize), radius * 0.18, Paint()..color = Colors.red);
    }
  }

  Offset _point(int row, int column, double cellSize) {
    return Offset(20 + column * cellSize, 20 + row * cellSize);
  }

  @override
  bool shouldRepaint(_OmokBoardPainter oldDelegate) => true;
}

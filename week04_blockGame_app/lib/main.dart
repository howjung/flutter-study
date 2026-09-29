import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: BrickBreakerGame(),
          autofocus: true,
        ),
      ),
    ),
  );
}

// ==========================================
// 1. 게임 메인 클래스
// ==========================================
class BrickBreakerGame extends FlameGame 
    with HasCollisionDetection, DragCallbacks, KeyboardEvents {
  late Paddle paddle;
  late Ball ball;

  int score = 0;
  int lives = 3;
  bool isGameOver = false;
  bool isGameWon = false;

  // 키보드 이동 관련 변수
  int horizontalDirection = 0; // -1: 좌, 1: 우, 0: 정지
  final double paddleSpeed = 400.0; // 패들 이동 속도

  late TextComponent scoreText;
  late TextComponent livesText;
  late TextComponent statusText;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    // 화면 테두리 충돌 영역 추가
    add(ScreenHitbox());

    // 구성 요소 초기화
    resetGame();
  }

  void resetGame() {
    // 기존 컴포넌트 제거
    removeAll(children);

    score = 0;
    lives = 3;
    isGameOver = false;
    isGameWon = false;
    horizontalDirection = 0;

    // 화면 테두리 다시 추가
    add(ScreenHitbox());

    // 패들 추가
    paddle = Paddle()
      ..position = Vector2(size.x / 2, size.y - 60)
      ..size = Vector2(100, 20);
    add(paddle);

    // 공 추가
    ball = Ball()
      ..position = Vector2(size.x / 2, size.y - 100)
      ..radius = 10;
    add(ball);

    // 벽돌 배치 (5행 7열)
    const rows = 5;
    const columns = 7;
    const brickGap = 5.0;
    final brickWidth = (size.x - (columns + 1) * brickGap) / columns;
    const brickHeight = 20.0;

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
    ];

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        final brick = Brick(
          color: colors[r % colors.length],
        )
          ..position = Vector2(
            brickGap + c * (brickWidth + brickGap),
            60 + r * (brickHeight + brickGap),
          )
          ..size = Vector2(brickWidth, brickHeight);
        add(brick);
      }
    }

    // UI 텍스트 추가
    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
    add(scoreText);

    livesText = TextComponent(
      text: 'Lives: $lives',
      position: Vector2(size.x - 100, 20),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
    add(livesText);

    statusText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 32, color: Colors.yellow, fontWeight: FontWeight.bold),
      ),
    );
    add(statusText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameOver || isGameWon) return;

    // 키보드 입력을 통한 패들 이동 처리
    if (horizontalDirection != 0) {
      paddle.position.x += horizontalDirection * paddleSpeed * dt;
      paddle.position.x = paddle.position.x.clamp(paddle.size.x / 2, size.x - paddle.size.x / 2);
    }

    // 공이 바닥으로 떨어진 경우 처리
    if (ball.position.y > size.y) {
      lives--;
      livesText.text = 'Lives: $lives';

      if (lives <= 0) {
        isGameOver = true;
        statusText.text = 'GAME OVER\nTap or press R to Restart';
      } else {
        // 공 위치 및 속도 리셋
        ball.position = Vector2(size.x / 2, size.y - 100);
        ball.velocity = Vector2(200, -200);
      }
    }

    // 모든 벽돌을 깼는지 확인
    final remainingBricks = children.whereType<Brick>();
    if (remainingBricks.isEmpty && !isGameWon) {
      isGameWon = true;
      ball.velocity = Vector2.zero();
      statusText.text = 'YOU WIN!\nTap or press R to Restart';
    }
  }

  // 키보드 이벤트 처리 (A / D 키 및 방향키 대응)
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isA = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isD = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isA && !isD) {
      horizontalDirection = -1;
    } else if (isD && !isA) {
      horizontalDirection = 1;
    } else {
      horizontalDirection = 0;
    }

    // R키 입력 시 재시작 (게임 오버 / 승리 시)
    if (keysPressed.contains(LogicalKeyboardKey.keyR)) {
      if (isGameOver || isGameWon) {
        resetGame();
      }
    }

    return KeyEventResult.handled;
  }

  // 화면 드래그로 패들 이동
  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (isGameOver || isGameWon) return;

    paddle.position.x += event.localDelta.x;
    paddle.position.x = paddle.position.x.clamp(paddle.size.x / 2, size.x - paddle.size.x / 2);
  }

  // 게임 오버/승리 상태에서 화면 클릭 시 재시작
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (isGameOver || isGameWon) {
      resetGame();
    }
  }
}

// ==========================================
// 2. 패들 컴포넌트
// ==========================================
class Paddle extends PositionComponent with CollisionCallbacks {
  Paddle() : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.blueAccent;
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      paint,
    );
  }
}

// ==========================================
// 3. 공 컴포넌트
// ==========================================
class Ball extends CircleComponent with CollisionCallbacks, HasGameReference<BrickBreakerGame> {
  Vector2 velocity = Vector2(200, -200);

  Ball() : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
    paint = Paint()..color = Colors.white;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver || game.isGameWon) return;

    position += velocity * dt;

    // 좌우 벽 반사
    if (position.x - radius <= 0 || position.x + radius >= game.size.x) {
      velocity.x = -velocity.x;
    }
    // 천장 반사
    if (position.y - radius <= 0) {
      velocity.y = -velocity.y;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Paddle) {
      // 패들과 충돌 시 부딪힌 위치에 따라 반사 각도 조절
      velocity.y = -velocity.y.abs();
      double hitPoint = (position.x - other.position.x) / (other.size.x / 2);
      velocity.x = hitPoint * 300;
    } else if (other is Brick) {
      // 벽돌 파괴 및 점수 획득
      other.removeFromParent();
      velocity.y = -velocity.y;
      game.score += 10;
      game.scoreText.text = 'Score: ${game.score}';
    }
  }
}

// ==========================================
// 4. 벽돌 컴포넌트
// ==========================================
class Brick extends PositionComponent with CollisionCallbacks {
  final Color color;

  Brick({required this.color});

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(4)),
      paint,
    );
  }
}
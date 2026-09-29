import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MemoryMatchApp());
}

class MemoryMatchApp extends StatelessWidget {
  const MemoryMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '기억의 별자리',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF246B72),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F5F3),
        useMaterial3: true,
      ),
      home: const MemoryMatchScreen(),
    );
  }
}

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  static const List<_CardFace> _faces = [
    _CardFace('별', Icons.star_rounded, Color(0xFFE6B84F)),
    _CardFace('달', Icons.nightlight_round, Color(0xFF5B79A5)),
    _CardFace('행성', Icons.public, Color(0xFF438C79)),
    _CardFace('로켓', Icons.rocket_launch_rounded, Color(0xFFE2765D)),
    _CardFace('위성', Icons.satellite_alt_rounded, Color(0xFF846DA7)),
    _CardFace('혜성', Icons.auto_awesome, Color(0xFF388CA0)),
  ];

  late List<_MemoryCard> _cards;
  int? _firstCardIndex;
  int _moves = 0;
  int _matchedPairs = 0;
  bool _isResolving = false;
  bool _hasWon = false;
  Timer? _hideCardsTimer;

  @override
  void initState() {
    super.initState();
    _cards = _createDeck();
  }

  List<_MemoryCard> _createDeck() {
    final cardFaces = [..._faces, ..._faces]..shuffle();
    return cardFaces.map(_MemoryCard.new).toList();
  }

  void _flipCard(int index) {
    if (_isResolving || _hasWon) return;
    final card = _cards[index];
    if (card.isFaceUp || card.isMatched) return;

    setState(() {
      _cards[index] = card.copyWith(isFaceUp: true);
      final firstIndex = _firstCardIndex;
      if (firstIndex == null) {
        _firstCardIndex = index;
        return;
      }

      _moves++;
      final firstCard = _cards[firstIndex];
      if (firstCard.face.label == card.face.label) {
        _cards[firstIndex] = firstCard.copyWith(isMatched: true);
        _cards[index] = _cards[index].copyWith(isMatched: true);
        _firstCardIndex = null;
        _matchedPairs++;
        if (_matchedPairs == _faces.length) _hasWon = true;
        return;
      }

      _isResolving = true;
      _hideCardsTimer = Timer(const Duration(milliseconds: 850), () {
        if (!mounted) return;
        setState(() {
          _cards[firstIndex] = _cards[firstIndex].copyWith(isFaceUp: false);
          _cards[index] = _cards[index].copyWith(isFaceUp: false);
          _firstCardIndex = null;
          _isResolving = false;
        });
      });
    });
  }

  void _startNewGame() {
    _hideCardsTimer?.cancel();
    setState(() {
      _cards = _createDeck();
      _firstCardIndex = null;
      _moves = 0;
      _matchedPairs = 0;
      _isResolving = false;
      _hasWon = false;
    });
  }

  @override
  void dispose() {
    _hideCardsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = _hasWon
        ? '별자리를 모두 복원했어요!'
        : _isResolving
        ? '기억을 되짚는 중...'
        : _matchedPairs == 0
        ? '두 장씩 뒤집어 같은 별을 찾아보세요.'
        : '좋아요, 다음 짝을 찾아볼까요?';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF193D46),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFFE6B84F),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ORBIT MEMORY',
                              style: TextStyle(
                                color: Color(0xFF46777A),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.3,
                              ),
                            ),
                            Text(
                              '기억의 별자리',
                              style: TextStyle(
                                color: Color(0xFF193D46),
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.outlined(
                        key: const ValueKey('new-memory-game'),
                        tooltip: '새 게임',
                        onPressed: _startNewGame,
                        icon: const Icon(Icons.refresh_rounded),
                        style: IconButton.styleFrom(
                          foregroundColor: const Color(0xFF31575B),
                          side: const BorderSide(color: Color(0xFFB8CBC5)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    _hasWon ? '모든 조각이\n제자리를 찾았어요.' : '별 조각을 모아\n하늘을 완성해요.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF193D46),
                      fontSize: 29,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF688084),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _ScoreLabel(
                          title: '찾은 짝',
                          value: '$_matchedPairs / ${_faces.length}',
                          icon: Icons.interests_outlined,
                          color: const Color(0xFF397E70),
                          valueKey: const ValueKey('pair-score'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ScoreLabel(
                          title: '뒤집은 횟수',
                          value: '$_moves번',
                          icon: Icons.touch_app_outlined,
                          color: const Color(0xFFD6785F),
                          valueKey: const ValueKey('move-score'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  GridView.builder(
                    key: const ValueKey('memory-board'),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _cards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.92,
                        ),
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      return _MemoryCardTile(
                        key: ValueKey('memory-card-$index'),
                        card: card,
                        onTap: () => _flipCard(index),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFFD29D38),
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        _hasWon
                            ? '새 게임 버튼으로 다시 도전할 수 있어요.'
                            : '짝이 아닌 카드는 잠시 후 다시 뒤집혀요.',
                        style: const TextStyle(
                          color: Color(0xFF688084),
                          fontSize: 12,
                        ),
                      ),
                    ],
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

class _MemoryCard {
  const _MemoryCard(this.face, {this.isFaceUp = false, this.isMatched = false});

  final _CardFace face;
  final bool isFaceUp;
  final bool isMatched;

  _MemoryCard copyWith({bool? isFaceUp, bool? isMatched}) {
    return _MemoryCard(
      face,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

class _CardFace {
  const _CardFace(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

class _MemoryCardTile extends StatelessWidget {
  const _MemoryCardTile({super.key, required this.card, required this.onTap});

  final _MemoryCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isVisible = card.isFaceUp || card.isMatched;

    return Semantics(
      button: true,
      label: card.isMatched
          ? '${card.face.label}, 짝 맞춤'
          : isVisible
          ? '${card.face.label}, 공개됨'
          : '뒤집지 않은 카드',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: card.isMatched ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: card.isMatched
                  ? const Color(0xFFDCECE4)
                  : isVisible
                  ? const Color(0xFFFCFCF8)
                  : const Color(0xFF193D46),
              border: Border.all(
                color: card.isMatched
                    ? const Color(0xFF83B9A2)
                    : isVisible
                    ? card.face.color.withValues(alpha: 0.48)
                    : const Color(0xFF315963),
                width: card.isMatched ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x120F3439),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: isVisible
                    ? Icon(
                        card.face.icon,
                        key: ValueKey(card.face.label),
                        color: card.face.color,
                        size: 34,
                      )
                    : const Icon(
                        Icons.add,
                        key: ValueKey('hidden-card'),
                        color: Color(0xFF8EADB0),
                        size: 25,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreLabel extends StatelessWidget {
  const _ScoreLabel({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.valueKey,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Key valueKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCF8),
        border: Border.all(color: const Color(0xFFDCE5E1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF688084),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  key: valueKey,
                  style: const TextStyle(
                    color: Color(0xFF193D46),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

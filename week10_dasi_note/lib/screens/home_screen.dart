import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/mistake.dart';
import '../widgets/side_menu.dart';

/// 이 너비(px) 이상이면 PC 배치(사이드바가 펼쳐짐), 미만이면 폰 배치(☰로 열기).
const double kWideBreakpoint = 800;

/// 다시노트의 첫 화면. 상단바 + 사이드바 + 본문(요약 카드, 오답 목록) 구조.
///
/// 화면에 보이는 데이터(과목, 오답)는 모두 이 State가 들고 있고,
/// 바뀔 때마다 setState로 화면을 다시 그린다. (저장은 메모리뿐: 앱을 다시 켜면 사라진다)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // 1단계에서는 비어 있다. 2단계(오답 적기)부터 채워진다.
  // 과목 목록(_subjects)도 2단계에서 여기에 추가한다.
  final List<Mistake> _mistakes = [];

  // PC에서 사이드바를 펼칠지 여부. 폰에서는 Drawer가 따로 열고 닫는다.
  bool _sideOpen = true;

  int get _doneCount => _mistakes.where((m) => m.done).length;
  int get _todoCount => _mistakes.length - _doneCount;

  void _onMenuPressed(bool wide) {
    if (wide) {
      setState(() => _sideOpen = !_sideOpen);
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= kWideBreakpoint;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bg,
      // 폰: 사이드바는 Drawer 안에 들어간다 (☰로 열고 바깥을 누르면 닫힘)
      drawer: wide
          ? null
          : const Drawer(
              width: 270,
              backgroundColor: AppColors.paper,
              child: SafeArea(child: SideMenu()),
            ),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              done: _doneCount,
              total: _mistakes.length,
              onMenu: () => _onMenuPressed(wide),
              showTagline: wide,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (wide && _sideOpen)
                    const SizedBox(
                      width: 240,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: AppColors.line),
                          ),
                        ),
                        child: SideMenu(),
                      ),
                    ),
                  Expanded(
                    child: _Content(
                      wide: wide,
                      total: _mistakes.length,
                      todo: _todoCount,
                      done: _doneCount,
                      onAdd: _openAddSheet,
                    ),
                  ),
                ],
              ),
            ),
            if (!wide) _BottomBar(onAdd: _openAddSheet),
          ],
        ),
      ),
    );
  }

  /// 2단계에서 실제 입력 팝업으로 바꾼다. 지금은 팝업이 열리는 길만 확인한다.
  void _openAddSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const Padding(
        padding: EdgeInsets.all(24),
        child: Text('오답 적기 입력칸은 2단계에서 만듭니다.'),
      ),
    );
  }
}

/// 맨 위: ☰ 버튼, 앱 이름, 한 줄 소개(PC만), 복습 점수, 진행 막대.
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.done,
    required this.total,
    required this.onMenu,
    required this.showTagline,
  });

  final int done;
  final int total;
  final VoidCallback onMenu;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onMenu,
                  tooltip: '메뉴 열기·닫기',
                  icon: const Icon(Icons.menu),
                ),
                const SizedBox(width: 4),
                const Text(
                  '다시노트',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                // 남는 폭은 이 Expanded 하나가 모두 차지해서 점수 칩이 오른쪽 끝에 붙는다.
                Expanded(
                  child: showTagline
                      ? const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            '틀린 것, 중요한 것만 모아 다시 보기',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13, color: AppColors.muted),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '복습 $done / $total',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            color: AppColors.accent,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}

/// 본문: 경로 표시, 제목, 요약 카드 3개, 오답 목록 카드.
class _Content extends StatelessWidget {
  const _Content({
    required this.wide,
    required this.total,
    required this.todo,
    required this.done,
    required this.onAdd,
  });

  final bool wide;
  final int total;
  final int todo;
  final int done;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(wide ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오답노트 › 전체',
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '오답노트',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              // PC에서는 제목 줄 오른쪽, 폰에서는 화면 아래 고정 버튼을 쓴다.
              if (wide)
                FilledButton(
                  onPressed: onAdd,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('＋ 오답 적기'),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatCard(label: '전체 오답', value: total, color: AppColors.field),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(label: '복습 전', value: todo, color: AppColors.todo),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(label: '복습 완료', value: done, color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 오답 목록 카드. 목록 자체는 3단계에서 만든다.
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.paper,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.line)),
                  ),
                  child: const Text(
                    '오답 목록',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                if (total == 0) const _EmptyState(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 요약 카드 하나: 이름 + 숫자. 숫자는 사용자가 입력한 오답에서 계산한 값이다.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // 테두리 색을 한쪽만 다르게 하면 둥근 모서리와 함께 못 쓰므로,
    // 바깥 테두리는 한 색으로 두고 왼쪽 색 막대를 따로 붙인다.
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.muted)),
                    const SizedBox(height: 2),
                    Text('$value',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 오답이 하나도 없을 때의 안내 (PRD 조건: 빈 상태).
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 28, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '아직 기록한 오답이 없습니다',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6),
          Text(
            "'오답 적기'로 첫 문항을 추가해 보세요.",
            style: TextStyle(fontSize: 15, color: AppColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// 폰 배치: 맨 아래 고정 버튼.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onAdd,
          child: const Text('＋ 오답 적기'),
        ),
      ),
    );
  }
}

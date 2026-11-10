import 'package:flutter/material.dart';

import '../app_theme.dart';

/// 왼쪽 사이드바. PC에서는 화면 옆에 붙고, 폰에서는 Drawer 안에 들어간다.
///
/// 이번 구현에서 동작하는 메뉴는 '오답노트'뿐이다.
/// '복습 모드'와 '통계'는 후속 기능이라 눌러도 아무 일도 일어나지 않고 '준비 중'만 보인다.
/// 과목 목록과 '＋ 새 과목'은 2단계에서 이 위젯에 추가한다.
class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.paper,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: const [
          _Label('메뉴'),
          _NavItem(icon: '▣', title: '오답노트', selected: true),
          _NavItem(icon: '☐', title: '복습 모드', comingSoon: true),
          _NavItem(icon: '☐', title: '통계', comingSoon: true),
          _Label('과목'),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.title,
    this.selected = false,
    this.comingSoon = false,
  });

  final String icon;
  final String title;
  final bool selected;
  final bool comingSoon; // true면 눌러도 아무 일도 없고 '준비 중' 표시

  @override
  Widget build(BuildContext context) {
    final color = comingSoon ? AppColors.muted : AppColors.ink;

    return Semantics(
      button: true,
      selected: selected,
      enabled: !comingSoon,
      child: InkWell(
        onTap: comingSoon ? null : () {},
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentSoft : null,
            border: Border(
              left: BorderSide(
                width: 3,
                color: selected ? AppColors.accent : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 26,
                child: Text(icon, style: const TextStyle(color: AppColors.muted)),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (comingSoon) ...[
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '준비 중',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

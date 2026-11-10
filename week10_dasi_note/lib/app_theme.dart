import 'package:flutter/material.dart';

/// 앱 전체에서 쓰는 색. 화면 예시(HTML)의 흰 바탕 + 청록 한 가지 규칙을 따른다.
/// 색을 바꾸고 싶으면 이 파일만 고치면 된다.
class AppColors {
  static const paper = Color(0xFFFFFFFF);
  static const bg = Color(0xFFF1F3F6); // 본문 바탕(카드 뒤)
  static const panel = Color(0xFFF4F5F7);
  static const ink = Color(0xFF1B2330);
  static const muted = Color(0xFF596579);
  static const line = Color(0xFFDDE1E8);
  static const accent = Color(0xFF0F766E);
  static const accentSoft = Color(0xFFE0F0ED);
  static const danger = Color(0xFFB3261E);
  static const todo = Color(0xFFB7791F); // 요약 카드 '복습 전' 강조색
  static const field = Color(0xFF8791A0);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: AppColors.accent).copyWith(
    primary: AppColors.accent,
    onPrimary: Colors.white,
    surface: AppColors.paper,
    onSurface: AppColors.ink,
    error: AppColors.danger,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.paper,
    // 글꼴은 이 한 곳에서만 정한다. 지금은 지정하지 않아서 Flutter 기본 글꼴을 쓴다.
    // 나중에 바꾸려면 여기에 fontFamily: '...' 한 줄만 넣으면 된다.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48), // 터치 영역 48px 이상 (PRD)
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 시각 선택기: 아래에서 올라오는 휠(돌려서 고르는) 방식, 24시간제.
// iOS 날짜 선택기처럼 시와 분을 손가락으로 돌려 고른다.
// 추가 패키지 없이 Flutter 기본 위젯(CupertinoDatePicker)만 쓴다.
// 버튼 문구를 직접 한글로 쓰므로 별도 지역화 설정이 필요 없다.

/// 시각을 고르는 방법. 취소하면 null을 돌려준다.
/// 화면(main.dart)은 이 형태만 알면 되므로, 테스트에서는 정해진 값을 돌려주는 가짜로 바꿀 수 있다.
/// [title]은 시트 맨 위에 보여 줄 제목이다. (예: "정한 시각 선택")
typedef TimePicker = Future<TimeOfDay?> Function(
  BuildContext context,
  TimeOfDay? current,
  String title,
);

/// 앱의 기본 시각 선택기. 이미 고른 시각이 있으면 그 시각에서, 없으면 지금 시각에서 시작한다.
Future<TimeOfDay?> pickTimeWithWheel(
  BuildContext context,
  TimeOfDay? current,
  String title,
) {
  return showTimeWheelSheet(
    context,
    current ?? TimeOfDay.now(),
    title: title,
  );
}

/// 아래에서 올라오는 시각 선택 시트를 열고, "확인"을 누르면 고른 시각을, "취소"나 바깥을 누르면 null을 돌려준다.
Future<TimeOfDay?> showTimeWheelSheet(
  BuildContext context,
  TimeOfDay initial, {
  String title = '시각을 골라 주세요',
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    // 기본값은 화면 높이의 9/16까지만 올라와서 낮은 창에서는 내용이 넘친다.
    // 화면 높이를 쓸 수 있게 하고, 넓은 창에서는 폭을 480으로 제한한다.
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: 480),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _TimeWheelSheet(initial: initial, title: title),
  );
}

class _TimeWheelSheet extends StatefulWidget {
  const _TimeWheelSheet({required this.initial, required this.title});

  final TimeOfDay initial;
  final String title;

  @override
  State<_TimeWheelSheet> createState() => _TimeWheelSheetState();
}

class _TimeWheelSheetState extends State<_TimeWheelSheet> {
  // 휠을 돌리지 않고 "확인"을 눌러도 처음 보여 준 시각이 그대로 선택되게 한다.
  late TimeOfDay _picked = widget.initial;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 216,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true, // 오전/오후 없이 00~23시
                initialDateTime: DateTime(
                  2000,
                  1,
                  1,
                  widget.initial.hour,
                  widget.initial.minute,
                ),
                onDateTimeChanged: (d) =>
                    _picked = TimeOfDay(hour: d.hour, minute: d.minute),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, _picked),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

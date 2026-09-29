import 'package:flutter/material.dart';

void main() {
  runApp(const LunarShiftApp());
}

class LunarShiftApp extends StatelessWidget {
  const LunarShiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '달 기지 교대일지',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF39745E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F0E8),
        useMaterial3: true,
      ),
      home: const LunarShiftScreen(),
    );
  }
}

class LunarShiftScreen extends StatefulWidget {
  const LunarShiftScreen({super.key});

  @override
  State<LunarShiftScreen> createState() => _LunarShiftScreenState();
}

class _LunarShiftScreenState extends State<LunarShiftScreen> {
  static const int _shiftGoal = 5;

  int _oxygen = 78;
  int _power = 62;
  int _morale = 71;
  int _completedShifts = 0;
  bool _missionOver = false;
  bool _missionSucceeded = false;
  String _latestEvent = '관제 센터 연결 완료. 오늘의 교대를 시작하세요.';
  final List<String> _eventLog = [];

  bool get _isCritical => _oxygen <= 25 || _power <= 25 || _morale <= 25;

  String get _statusLabel {
    if (_missionOver) {
      return _missionSucceeded ? '임무 완료' : '기지 위험';
    }
    return _isCritical ? '주의가 필요해요' : '모든 시스템 정상';
  }

  Color get _statusColor {
    if (_missionOver && !_missionSucceeded) return const Color(0xFFE8A18C);
    if (_isCritical) return const Color(0xFFE8B86F);
    return const Color(0xFF9AD0B4);
  }

  int _clampResource(int value) => value.clamp(0, 100);

  void _recordEvent(String message) {
    _latestEvent = message;
    _eventLog.insert(0, message);
    if (_eventLog.length > 3) _eventLog.removeLast();
  }

  void _alignSolarPanels() {
    if (_missionOver) return;
    setState(() {
      final gained = _power == 100 ? 0 : 24;
      _power = _clampResource(_power + gained);
      _recordEvent(gained == 0 ? '전력 저장고가 가득 찼습니다.' : '태양광 패널 정렬 · 전력 충전');
    });
  }

  void _runGreenhouse() {
    if (_missionOver) return;
    setState(() {
      if (_power < 12) {
        _recordEvent('온실 가동에 전력이 더 필요합니다. 태양광을 먼저 충전하세요.');
        return;
      }
      _power -= 12;
      _oxygen = _clampResource(_oxygen + 13);
      _morale = _clampResource(_morale + 4);
      _recordEvent('온실 가동 · 산소와 승무원 사기가 회복됐습니다.');
    });
  }

  void _takeBreak() {
    if (_missionOver) return;
    setState(() {
      if (_oxygen < 8) {
        _recordEvent('휴식 구역에 산소가 부족합니다. 온실을 가동하세요.');
        return;
      }
      _oxygen -= 7;
      _morale = _clampResource(_morale + 18);
      _recordEvent('공용실 영화 시간 · 승무원 사기가 올랐습니다.');
    });
  }

  void _endShift() {
    if (_missionOver) return;
    setState(() {
      _oxygen = _clampResource(_oxygen - 14);
      _power = _clampResource(_power - 11);
      _morale = _clampResource(_morale - 8);
      _completedShifts++;

      if (_oxygen == 0 || _power == 0 || _morale == 0) {
        _missionOver = true;
        _recordEvent('필수 자원이 바닥났습니다. 임무를 다시 시작해 주세요.');
      } else if (_completedShifts >= _shiftGoal) {
        _missionOver = true;
        _missionSucceeded = true;
        _recordEvent('5교대 생존 성공! 달 기지가 안정 궤도에 진입했습니다.');
      } else {
        _recordEvent('교대 $_completedShifts 종료 · 다음 교대를 준비하세요.');
      }
    });
  }

  void _restartMission() {
    setState(() {
      _oxygen = 78;
      _power = 62;
      _morale = 71;
      _completedShifts = 0;
      _missionOver = false;
      _missionSucceeded = false;
      _eventLog.clear();
      _recordEvent('새 임무가 시작됐습니다. 기지 상태를 확인하세요.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildMissionPanel(),
                  const SizedBox(height: 22),
                  _buildShiftProgress(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('기지 상태', '세 자원을 균형 있게 유지하세요'),
                  const SizedBox(height: 12),
                  _buildResourcePanel(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('교대 중 행동', '행동마다 자원 변화가 달라요'),
                  const SizedBox(height: 12),
                  _ActionRow(
                    key: const ValueKey('solar-action'),
                    icon: Icons.wb_sunny_outlined,
                    color: const Color(0xFFD18A3B),
                    title: '태양광 패널 정렬',
                    detail: '전력 최대 +24',
                    onTap: _missionOver ? null : _alignSolarPanels,
                  ),
                  const SizedBox(height: 8),
                  _ActionRow(
                    key: const ValueKey('greenhouse-action'),
                    icon: Icons.eco_outlined,
                    color: const Color(0xFF39745E),
                    title: '온실 가동',
                    detail: '전력 -12 · 산소 +13 · 사기 +4',
                    onTap: _missionOver ? null : _runGreenhouse,
                  ),
                  const SizedBox(height: 8),
                  _ActionRow(
                    key: const ValueKey('break-action'),
                    icon: Icons.movie_outlined,
                    color: const Color(0xFF6483A0),
                    title: '공용실 영화 시간',
                    detail: '산소 -7 · 사기 +18',
                    onTap: _missionOver ? null : _takeBreak,
                  ),
                  const SizedBox(height: 24),
                  _buildEventLog(),
                  const SizedBox(height: 18),
                  if (_missionOver)
                    OutlinedButton.icon(
                      key: const ValueKey('restart-mission'),
                      onPressed: _restartMission,
                      icon: const Icon(Icons.replay),
                      label: const Text('새 임무 시작'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                    )
                  else
                    FilledButton.icon(
                      key: const ValueKey('end-shift'),
                      onPressed: _endShift,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('교대 마치기'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: const Color(0xFF263B34),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF263B34),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.public, color: Color(0xFFE8B86F), size: 23),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LUNAR STATION 07',
                style: TextStyle(
                  color: Color(0xFF64736A),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                '달 기지 교대일지',
                style: TextStyle(
                  color: Color(0xFF263B34),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFE4E8DD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '교대 ${_completedShifts + 1}',
            style: const TextStyle(
              color: Color(0xFF3F5D4F),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMissionPanel() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF263B34),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _statusLabel,
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _missionSucceeded
                      ? '기지가 살아남았어요.'
                      : _missionOver
                      ? '기지에 비상 상황이 발생했어요.'
                      : '다섯 번의 교대를\n무사히 넘겨 보세요.',
                  style: const TextStyle(
                    color: Color(0xFFF3F0E7),
                    fontSize: 22,
                    height: 1.3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.rocket_launch_outlined,
            color: Color(0xFFE8B86F),
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildShiftProgress() {
    return Row(
      children: [
        const Text(
          '생존 기록',
          style: TextStyle(
            color: Color(0xFF34483D),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: List.generate(_shiftGoal, (index) {
              final isComplete = index < _completedShifts;
              return Expanded(
                child: Container(
                  height: 8,
                  margin: EdgeInsets.only(
                    right: index == _shiftGoal - 1 ? 0 : 5,
                  ),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? const Color(0xFF39745E)
                        : const Color(0xFFD8DCD2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$_completedShifts/$_shiftGoal',
          style: const TextStyle(
            color: Color(0xFF64736A),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF263B34),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            subtitle,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Color(0xFF758078), fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildResourcePanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAF5),
        border: Border.all(color: const Color(0xFFDDE0D6)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _ResourceMeter(
            key: const ValueKey('oxygen-meter'),
            icon: Icons.air,
            title: '산소',
            value: _oxygen,
            color: const Color(0xFF398A78),
          ),
          const Divider(height: 1, color: Color(0xFFE5E6DE)),
          _ResourceMeter(
            key: const ValueKey('power-meter'),
            icon: Icons.bolt,
            title: '전력',
            value: _power,
            color: const Color(0xFFD18A3B),
          ),
          const Divider(height: 1, color: Color(0xFFE5E6DE)),
          _ResourceMeter(
            key: const ValueKey('morale-meter'),
            icon: Icons.groups_2_outlined,
            title: '승무원 사기',
            value: _morale,
            color: const Color(0xFF6483A0),
          ),
        ],
      ),
    );
  }

  Widget _buildEventLog() {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E9E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.sensors, size: 17, color: Color(0xFF557062)),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '최근 교신',
                  style: TextStyle(
                    color: Color(0xFF557062),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _latestEvent,
                  key: const ValueKey('latest-event'),
                  style: const TextStyle(
                    color: Color(0xFF34483D),
                    fontSize: 12,
                    height: 1.35,
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

class _ResourceMeter extends StatelessWidget {
  const _ResourceMeter({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Row(
        children: [
          Icon(icon, color: color, size: 19),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF34483D),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 8,
                backgroundColor: const Color(0xFFE4E6DF),
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 42,
            child: Text(
              '$value%',
              key: ValueKey(
                'resource-${title == '산소'
                    ? 'oxygen'
                    : title == '전력'
                    ? 'power'
                    : 'morale'}-value',
              ),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF263B34),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFBFAF5),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 62),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDE0D6)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 21),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF263B34),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail,
                      style: const TextStyle(
                        color: Color(0xFF758078),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: onTap == null
                    ? const Color(0xFFB8BEB5)
                    : const Color(0xFF849087),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

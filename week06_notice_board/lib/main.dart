import 'package:flutter/material.dart';

void main() => runApp(const NoticeApp());

enum LoadStatus { idle, loading, success, failure }

class NoticeApp extends StatelessWidget {
  const NoticeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '6주차 공지',
        theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
        home: const NoticePage(),
      );
}

Future<String> fetchNotice({required bool fail}) async {
  await Future<void>.delayed(const Duration(seconds: 1));
  if (fail) throw Exception('NOTICE_UNAVAILABLE');
  return '6주차 실습 자료가 열렸습니다.';
}

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  LoadStatus _status = LoadStatus.idle;
  String? _notice;
  String? _error;
  bool _failNext = false;
  int _requestCount = 0;

  Future<void> loadNotice() async {
    if (_status == LoadStatus.loading) return;
    final fail = _failNext;
    _requestCount += 1;
    // TODO_START: setState에서 loading으로 바꾸고 이전 결과와 오류를 지우세요.
    setState(() {
      _status = LoadStatus.loading;
      _notice = null;
      _error = null;
    });
    try {
      final text = await fetchNotice(fail: fail);
      if (!mounted) return;
      debugPrint('NOTICE_RESULT: $text');
      setState(() {
        _notice = text;
        _status = LoadStatus.success;
      });
    } catch (error) {
      if (!mounted) return;
      debugPrint('NOTICE_LOAD_FAILED: $error');
      setState(() {
        _error = '공지를 불러오지 못했습니다.';
        _status = LoadStatus.failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = _status == LoadStatus.loading;
    return Scaffold(
      appBar: AppBar(title: const Text('6주차 공지')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('상태: ${_status.name}', key: const Key('status')),
                Text('요청 횟수: $_requestCount', key: const Key('requests')),
                SwitchListTile(
                  title: const Text('실패 상황 만들기'),
                  subtitle: const Text('켜면 다음 요청이 실패합니다.'),
                  value: _failNext,
                  onChanged: loading ? null : (value) {
                    setState(() => _failNext = value);
                  },
                ),
                const SizedBox(height: 24),
                if (_status == LoadStatus.idle)
                  const Text('버튼을 눌러 공지를 불러오세요.'),
                if (loading) ...[
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 12),
                  const Text('공지를 불러오는 중입니다.'),
                ],
                if (_status == LoadStatus.success) Text(_notice ?? ''),
                if (_status == LoadStatus.failure) Text(_error ?? ''),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('load'),
                  onPressed: loading ? null : loadNotice,
                  child: Text(_status == LoadStatus.failure
                      ? '다시 시도' : '공지 불러오기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

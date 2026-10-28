import 'package:flutter/material.dart';

import '../note_store.dart';
import 'note_list_screen.dart';
import 'search_screen.dart';

/// F1: 과목 추가/목록
class SubjectListScreen extends StatelessWidget {
  final NoteStore store;

  const SubjectListScreen({super.key, required this.store});

  Future<void> _addSubject(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('과목 추가'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: '예: 자료구조'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('추가'),
          ),
        ],
      ),
    );
    if (name != null) store.addSubject(name);
  }

  Future<bool> _confirmDelete(BuildContext context, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('과목 삭제'),
        content: Text('"$name"과 이 과목의 모든 메모가 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final subjects = store.subjects;
        return Scaffold(
          appBar: AppBar(
            title: const Text('내 과목'),
            actions: [
              IconButton(
                tooltip: '전체 검색',
                icon: const Icon(Icons.search),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchScreen(store: store),
                  ),
                ),
              ),
            ],
          ),
          body: subjects.isEmpty
              ? const Center(child: Text('아래 + 버튼으로 과목을 추가해 보세요.'))
              : ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, i) {
                    final s = subjects[i];
                    return Dismissible(
                      key: ValueKey(s.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _confirmDelete(context, s.name),
                      onDismissed: (_) => store.deleteSubject(s.id),
                      background: Container(
                        color: Theme.of(context).colorScheme.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(s.name),
                        subtitle: Text('메모 ${store.noteCountOf(s.id)}개'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NoteListScreen(store: store, subjectId: s.id),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            tooltip: '과목 추가',
            onPressed: () => _addSubject(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

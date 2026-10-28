import 'package:flutter/material.dart';

import '../note_store.dart';
import 'note_edit_screen.dart';

/// F3, F5: 과목별 메모 목록과 중요 메모 필터
class NoteListScreen extends StatefulWidget {
  final NoteStore store;
  final String subjectId;

  const NoteListScreen({
    super.key,
    required this.store,
    required this.subjectId,
  });

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  bool _starredOnly = false;

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final subject = store.subjectById(widget.subjectId);
        if (subject == null) {
          return const Scaffold(body: Center(child: Text('삭제된 과목입니다.')));
        }
        final notes = store.notesOf(widget.subjectId, starredOnly: _starredOnly);
        return Scaffold(
          appBar: AppBar(
            title: Text(subject.name),
            actions: [
              IconButton(
                tooltip: _starredOnly ? '전체 보기' : '중요 메모만 보기',
                icon: Icon(_starredOnly ? Icons.star : Icons.star_border),
                onPressed: () => setState(() => _starredOnly = !_starredOnly),
              ),
            ],
          ),
          body: notes.isEmpty
              ? Center(
                  child: Text(
                    _starredOnly ? '중요 표시한 메모가 없습니다.' : '아래 + 버튼으로 메모를 남겨 보세요.',
                  ),
                )
              : ListView.separated(
                  itemCount: notes.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final n = notes[i];
                    return ListTile(
                      title: Text(n.text, maxLines: 3, overflow: TextOverflow.ellipsis),
                      subtitle: Text(_formatDate(n.createdAt)),
                      trailing: IconButton(
                        tooltip: n.isStarred ? '중요 해제' : '중요 표시',
                        icon: Icon(
                          n.isStarred ? Icons.star : Icons.star_border,
                          color: n.isStarred ? Colors.amber : null,
                        ),
                        onPressed: () =>
                            store.updateNote(n.id, isStarred: !n.isStarred),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteEditScreen(
                            store: store,
                            subjectId: widget.subjectId,
                            note: n,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            tooltip: '메모 추가',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    NoteEditScreen(store: store, subjectId: widget.subjectId),
              ),
            ),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

String _formatDate(DateTime d) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${d.year}.${two(d.month)}.${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
}

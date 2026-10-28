import 'package:flutter/material.dart';

import '../note_store.dart';
import 'note_edit_screen.dart';

/// F4: 모든 과목에서 키워드 검색
class SearchScreen extends StatefulWidget {
  final NoteStore store;

  const SearchScreen({super.key, required this.store});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '모든 과목에서 검색',
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _keyword = v),
        ),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final results = store.search(_keyword);
          if (_keyword.trim().isEmpty) {
            return const Center(child: Text('찾을 키워드를 입력하세요.'));
          }
          if (results.isEmpty) {
            return const Center(child: Text('검색 결과가 없습니다.'));
          }
          return ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final n = results[i];
              final subject = store.subjectById(n.subjectId);
              return ListTile(
                title: Text(n.text, maxLines: 3, overflow: TextOverflow.ellipsis),
                subtitle: Text(subject?.name ?? ''),
                trailing: n.isStarred
                    ? const Icon(Icons.star, color: Colors.amber)
                    : null,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NoteEditScreen(
                      store: store,
                      subjectId: n.subjectId,
                      note: n,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

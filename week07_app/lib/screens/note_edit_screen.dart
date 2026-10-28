import 'package:flutter/material.dart';

import '../models.dart';
import '../note_store.dart';

/// F2, F6: 메모 추가/수정/삭제. [note]가 null이면 새 메모.
class NoteEditScreen extends StatefulWidget {
  final NoteStore store;
  final String subjectId;
  final Note? note;

  const NoteEditScreen({
    super.key,
    required this.store,
    required this.subjectId,
    this.note,
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late final TextEditingController _controller;
  late bool _starred;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note?.text ?? '');
    _starred = widget.note?.isStarred ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('메모 내용을 입력해 주세요.')));
      return;
    }
    if (_isEditing) {
      widget.store.updateNote(widget.note!.id, text: text, isStarred: _starred);
    } else {
      widget.store.addNote(widget.subjectId, text, isStarred: _starred);
    }
    Navigator.pop(context);
  }

  void _delete() {
    widget.store.deleteNote(widget.note!.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '메모 수정' : '새 메모'),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: '삭제',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          IconButton(
            tooltip: '저장',
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: !_isEditing,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: '필기 내용을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('시험에 중요한 메모'),
              value: _starred,
              onChanged: (v) => setState(() => _starred = v),
            ),
          ],
        ),
      ),
    );
  }
}

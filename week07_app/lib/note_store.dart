import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// 과목과 메모를 보관하고 기기 안에 저장하는 저장소.
class NoteStore extends ChangeNotifier {
  static const _key = 'note_store_v1';

  final SharedPreferences _prefs;
  final List<Subject> _subjects = [];
  final List<Note> _notes = [];
  int _idSeed = DateTime.now().microsecondsSinceEpoch;

  NoteStore(this._prefs) {
    _load();
  }

  List<Subject> get subjects => List.unmodifiable(_subjects);

  /// 과목의 메모를 최신순으로 반환한다. [starredOnly]가 true면 중요 메모만.
  List<Note> notesOf(String subjectId, {bool starredOnly = false}) {
    final list = _notes
        .where((n) => n.subjectId == subjectId && (!starredOnly || n.isStarred))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  int noteCountOf(String subjectId) =>
      _notes.where((n) => n.subjectId == subjectId).length;

  Subject? subjectById(String id) {
    for (final s in _subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// 모든 과목에서 키워드가 포함된 메모를 찾는다. 대소문자는 구분하지 않는다.
  List<Note> search(String keyword) {
    final q = keyword.trim().toLowerCase();
    if (q.isEmpty) return [];
    final list = _notes.where((n) => n.text.toLowerCase().contains(q)).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void addSubject(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _subjects.add(Subject(id: _newId(), name: trimmed));
    _changed();
  }

  void deleteSubject(String id) {
    _subjects.removeWhere((s) => s.id == id);
    _notes.removeWhere((n) => n.subjectId == id);
    _changed();
  }

  void addNote(String subjectId, String text, {bool isStarred = false}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _notes.add(
      Note(
        id: _newId(),
        subjectId: subjectId,
        text: trimmed,
        isStarred: isStarred,
        createdAt: DateTime.now(),
      ),
    );
    _changed();
  }

  void updateNote(String id, {String? text, bool? isStarred}) {
    final i = _notes.indexWhere((n) => n.id == id);
    if (i < 0) return;
    final trimmed = text?.trim();
    if (trimmed != null && trimmed.isEmpty) return;
    _notes[i] = _notes[i].copyWith(text: trimmed, isStarred: isStarred);
    _changed();
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    _changed();
  }

  String _newId() => (_idSeed++).toString();

  void _changed() {
    _save();
    notifyListeners();
  }

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _subjects.addAll(
        (data['subjects'] as List).map(
          (e) => Subject.fromJson(e as Map<String, dynamic>),
        ),
      );
      _notes.addAll(
        (data['notes'] as List).map(
          (e) => Note.fromJson(e as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      // 저장 데이터가 깨졌으면 빈 상태로 시작한다.
      _subjects.clear();
      _notes.clear();
    }
  }

  void _save() {
    _prefs.setString(
      _key,
      jsonEncode({
        'subjects': _subjects.map((s) => s.toJson()).toList(),
        'notes': _notes.map((n) => n.toJson()).toList(),
      }),
    );
  }
}

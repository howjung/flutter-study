import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:week07_app/main.dart';
import 'package:week07_app/note_store.dart';

Future<NoteStore> _newStore() async {
  SharedPreferences.setMockInitialValues({});
  return NoteStore(await SharedPreferences.getInstance());
}

void main() {
  group('NoteStore', () {
    test('과목별 메모 추가와 조회', () async {
      final store = await _newStore();
      store.addSubject('자료구조');
      store.addSubject('운영체제');
      final a = store.subjects[0].id;
      final b = store.subjects[1].id;

      store.addNote(a, '스택은 LIFO');
      store.addNote(b, '프로세스와 스레드');

      expect(store.notesOf(a).map((n) => n.text), ['스택은 LIFO']);
      expect(store.noteCountOf(b), 1);
    });

    test('빈 입력은 무시한다', () async {
      final store = await _newStore();
      store.addSubject('  ');
      expect(store.subjects, isEmpty);
    });

    test('모든 과목에서 검색하고 대소문자를 구분하지 않는다', () async {
      final store = await _newStore();
      store.addSubject('자료구조');
      store.addSubject('운영체제');
      store.addNote(store.subjects[0].id, 'Stack 구조');
      store.addNote(store.subjects[1].id, '스택 영역 메모리');

      expect(store.search('stack'), hasLength(1));
      expect(store.search('스택'), hasLength(1));
      expect(store.search(' '), isEmpty);
    });

    test('중요 표시와 필터', () async {
      final store = await _newStore();
      store.addSubject('자료구조');
      final s = store.subjects.first.id;
      store.addNote(s, '일반');
      store.addNote(s, '중요', isStarred: true);

      expect(store.notesOf(s, starredOnly: true).map((n) => n.text), ['중요']);
    });

    test('과목 삭제 시 메모도 삭제된다', () async {
      final store = await _newStore();
      store.addSubject('자료구조');
      final s = store.subjects.first.id;
      store.addNote(s, '메모');
      store.deleteSubject(s);

      expect(store.subjects, isEmpty);
      expect(store.search('메모'), isEmpty);
    });

    test('다시 열어도 데이터가 유지된다 (F7)', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final first = NoteStore(prefs);
      first.addSubject('자료구조');
      first.addNote(first.subjects.first.id, '유지되는 메모', isStarred: true);

      final second = NoteStore(prefs);
      expect(second.subjects.single.name, '자료구조');
      final note = second.notesOf(second.subjects.single.id).single;
      expect(note.text, '유지되는 메모');
      expect(note.isStarred, isTrue);
    });
  });

  testWidgets('과목을 추가하고 메모를 남기는 흐름', (tester) async {
    final store = await _newStore();
    await tester.pumpWidget(NoteApp(store: store));

    expect(find.text('아래 + 버튼으로 과목을 추가해 보세요.'), findsOneWidget);

    await tester.tap(find.byTooltip('과목 추가'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '자료구조');
    await tester.tap(find.text('추가'));
    await tester.pumpAndSettle();
    expect(find.text('자료구조'), findsOneWidget);

    await tester.tap(find.text('자료구조'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('메모 추가'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '큐는 FIFO');
    await tester.tap(find.byTooltip('저장'));
    await tester.pumpAndSettle();

    expect(find.text('큐는 FIFO'), findsOneWidget);
  });
}

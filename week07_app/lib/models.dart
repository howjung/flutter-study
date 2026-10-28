class Subject {
  final String id;
  final String name;

  const Subject({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory Subject.fromJson(Map<String, dynamic> json) =>
      Subject(id: json['id'] as String, name: json['name'] as String);
}

class Note {
  final String id;
  final String subjectId;
  final String text;
  final bool isStarred;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.subjectId,
    required this.text,
    required this.createdAt,
    this.isStarred = false,
  });

  Note copyWith({String? text, bool? isStarred}) => Note(
    id: id,
    subjectId: subjectId,
    text: text ?? this.text,
    isStarred: isStarred ?? this.isStarred,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectId': subjectId,
    'text': text,
    'isStarred': isStarred,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String,
    subjectId: json['subjectId'] as String,
    text: json['text'] as String,
    isStarred: json['isStarred'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime? createdAt;
  final String category;
  final int categoryColor;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.createdAt,
    this.category = '',
    this.categoryColor = 0xFFFF0000,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'category': category,
      'categoryColor': categoryColor,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      category: map['category'] ?? '',
      categoryColor: map['categoryColor'] ?? 0xFFFF0000,
    );
  }
}

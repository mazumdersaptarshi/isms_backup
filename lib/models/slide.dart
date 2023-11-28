class Slide {
  String id;
  String? title;
  String? content;
  int? index;

  Slide({required this.id, this.title, this.content, this.index});

  factory Slide.fromMap(Map<String, dynamic> map) {
    return Slide(
        id: map['id'],
        title: map['title'] ?? 'n/a',
        index: map['index'] ?? 'n/a',
        content: map['content'] ?? 'n/a');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title ?? 'n/a',
      'index': index,
      'content': content ?? 'n/a'
    };
  }
}

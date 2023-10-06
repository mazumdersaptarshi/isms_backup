class Slide {
  String id;
  int index;
  String title;
  String content;

  Slide(
      {required this.id,
      this.index = 0,
      required this.title,
      required this.content});

  factory Slide.fromMap(Map<String, dynamic> map) {
    return Slide(
        id: map['id'],
        title: map['title'],
        index: map['index'],
        content: map['content']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'index': index, 'content': content};
  }
}

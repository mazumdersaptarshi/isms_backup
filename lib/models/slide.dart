class Slide {
  String id;
  String title;
  String content;
  int? index;

  Slide(
      {required this.id,
      required this.title,
      required this.content,
      this.index});

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

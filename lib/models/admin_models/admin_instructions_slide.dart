// ignore_for_file: file_names

class AdminInstructionsSlide {
  String? title;
  String? content;

  AdminInstructionsSlide({this.title, this.content});

  factory AdminInstructionsSlide.fromMap(Map<String, dynamic> map) {
    return AdminInstructionsSlide(
        title: map['title'] ?? '', content: map['content'] ?? 'n/a');
  }
}

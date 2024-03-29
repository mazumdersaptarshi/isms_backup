import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';

class ExamInfo implements SelectableItem {
  String examId;

  String? examTitle;

  ExamInfo({required this.examId, this.examTitle});

  @override
  String get itemId => examId;

  @override
  String get itemName => examTitle!;
}

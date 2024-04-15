import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ExamPage extends StatefulWidget {
  ExamPage({
    super.key,
    required this.examId,
  });

  String examId = 'none';
  String examName = 'none';

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  late String _loggedInUserUid;

  @override
  void initState() {
    super.initState();

    _loggedInUserUid = Provider.of<LoggedInState>(context, listen: false).currentUserUid!;
    Provider.of<ExamProvider>(context, listen: false).getExam(examId: widget.examId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IsmsAppBar(context: context),
      // drawer: IsmsDrawer(context: context),
      body: Container(
        child: Column(
          children: [Text(widget.examId), Text(widget.examName)],
        ),
      ),
    );
  }
}

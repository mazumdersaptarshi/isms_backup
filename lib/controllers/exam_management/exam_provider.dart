import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isms/models/course/enums.dart';
import 'package:isms/models/course/exam_full.dart';
import 'package:isms/models/course/section_full.dart';
import 'package:isms/models/course/element.dart' as ExamElement;

class ExamProvider extends ChangeNotifier {
  String localGetURL3 = 'http://127.0.0.1:5000/get3?flag=';
  String localPostURL = 'http://127.0.0.1:5000/insert-update-request';
  String remoteGetURL3 =
      'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/get3?flag=';
  String remotePostURL =
      'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/insert-update-request';
  bool examInProgress = false;

  Future<dynamic> getExamContent({required String examId}) async {
    Map<String, dynamic> params = {
      "examID": examId,
    };
    String jsonStringParams = jsonEncode(params);
    String encodedJsonStringParams = Uri.encodeComponent(jsonStringParams);
    var remoteURL = Uri.parse(
        'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/insert-update-course-assignments-post');

    http.Response response = await http
        .get(Uri.parse(remoteGetURL3 + 'exam_content' + '&param1=$examId' + '&params=$encodedJsonStringParams'));
    List<dynamic> jsonResponse = jsonDecode(response.body);

    print('jsonresp: ${jsonResponse[0][0]}');

    List<SectionFull> sections = [];
    jsonResponse.first.first['contentJdoc']['examSections'].forEach((element) {
      List<ExamElement.Element> sectionElements = [];
      element['sectionElements'].forEach((element) {
        sectionElements.add(ExamElement.Element(
          elementId: element['elementId'],
          elementType: element['elementType'],
          elementContent: element['elementContent'],
          elementTitle: element['elementTitle'],
        ));
      });
      SectionFull sf = SectionFull(
        sectionElements: sectionElements,
        sectionId: element['sectionId'],
        sectionSummary: element['sectionSummary'],
        sectionTitle: element['sectionTitle'],
      );
      sections.add(sf);
    });

    print(sections);
    ExamFull ef = ExamFull(
      courseId: jsonResponse.first.first['contentJdoc']['courseId'],
      examId: jsonResponse.first.first['contentJdoc']['examId'],
      examVersion: jsonResponse.first.first['contentVersion'],
      examTitle: jsonResponse.first.first['contentJdoc']['examTitle'],
      examSummary: jsonResponse.first.first['contentJdoc']['examSummary'],
      examDescription: jsonResponse.first.first['contentJdoc']['examDescription'],
      examPassMark: jsonResponse.first.first['passMark'],
      examEstimatedCompletionTime: jsonResponse.first.first['estimatedCompletionTime'],
      examSections: sections,
    );
    // ExamFull examFull = ExamFull.fromJson(jsonResponse.first.first['contentJdoc']);
    print(ef);
    return ef;
  }

  Future<dynamic> insertUserExamAttempt({
    required String CSRFToken,
    required String JWT,
    required String uid,
    required String courseId,
    required String examId,
    required double examVersion,
    required bool passed,
    required int score,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    Map<String, dynamic> params = {
      "userID": uid,
      "courseID": courseId,
      "examID": examId,
      "examVersion": examVersion,
      "passed": passed,
      "score": score,
      "startedAt": startTime.toIso8601String(),
      "finishedAt": endTime.toIso8601String(),
    };
    String jsonStringParams = jsonEncode(params);
    String encodedJsonStringParams = Uri.encodeComponent(jsonStringParams);
    var headers = {
      'Authorization': 'Bearer $JWT',
      'Content-Type': 'application/json',
      'X-CSRF-Token': CSRFToken,
    };
    var url = Uri.parse('$remotePostURL?flag=insert_user_exam_attempt');

    var response = await http.post(url, headers: headers, body: jsonStringParams);

    // print(response.body);
  }
}

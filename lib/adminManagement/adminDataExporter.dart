import 'dart:convert';
// import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/course.dart';
import "package:universal_html/html.dart" as html;

import '../models/customUser.dart';

class DataExporter {
  String? collectionDataToDownload = 'users';
  DataExporter({this.collectionDataToDownload});

  Future<void> downloadCSV() async {
    //Download Users data
    var csvData;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionDataToDownload!)
        .get();
    if (collectionDataToDownload == 'users') {
      csvData = getUsersDataAsCSV(querySnapshot);
    } else if (collectionDataToDownload == 'courses') {
      csvData = getCoursesDataAsCSV(querySnapshot);
    }
    // Loop through the documents to populate the CSV data

    print(csvData);
    // Create the CSV content
    StringBuffer buffer = StringBuffer();
    csvData.forEach((row) {
      buffer.writeAll(row, ',');
      buffer.write('\n');
    });
    print(buffer);
    // Convert to Uint8List
    Uint8List bytes = Uint8List.fromList(utf8.encode(buffer.toString()));

    // Create Blob and download the file
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'data.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  List<List<dynamic>> getUsersDataAsCSV(QuerySnapshot querySnapshot) {
    final List<QueryDocumentSnapshot> allData = querySnapshot.docs;

    List<List<dynamic>> csvData = [
      // Define the headers
      ['username', 'uid', 'email', 'courses_started', 'courses_completed']
    ];
    print(allData);
    // Loop through the documents to populate the CSV data
    for (QueryDocumentSnapshot snapshot in allData) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      CustomUser userInfo = CustomUser.fromMap(data);

      csvData.add([
        userInfo.username.toString(),
        userInfo.uid.toString(),
        userInfo.email.toString(),
        userInfo.courses_started.toString(),
        userInfo.courses_completed.toString()
      ]);
    }
    return csvData;
  }

  List<List<dynamic>> getCoursesDataAsCSV(QuerySnapshot querySnapshot) {
    final List<QueryDocumentSnapshot> allData = querySnapshot.docs;

    List<List<dynamic>> csvData = [
      // Define the headers
      [
        'name',
        'id',
        'exams',
        'examsCount',
        'modules',
        'modulesCount',
        'createdAt'
      ]
    ];
    print(allData);
    // Loop through the documents to populate the CSV data
    for (QueryDocumentSnapshot snapshot in allData) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Course coursesInfo = Course.fromMap(data);

      csvData.add([
        coursesInfo.name.toString(),
        coursesInfo.id.toString(),
        coursesInfo.exams.toString(),
        coursesInfo.examsCount.toString(),
        coursesInfo.modules.toString(),
        coursesInfo.modulesCount.toString(),
        data['createdAt'].toString(),
      ]);
    }
    return csvData;
  }
}

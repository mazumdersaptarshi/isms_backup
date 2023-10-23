import 'dart:convert';
// import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:universal_html/html.dart" as html;

import '../models/customUser.dart';

class DataExporter {
  String? collectionDataToDownload = 'users';
  DataExporter({this.collectionDataToDownload});
  Future<void> downloadCSV() async {
    //Download Users data
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionDataToDownload!)
        .get();
    final List<QueryDocumentSnapshot> allData = querySnapshot.docs;

    // Initialize a list to store the CSV data
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
}

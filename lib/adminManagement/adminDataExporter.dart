import 'dart:convert';
// import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:isms/models/course.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;
import "package:universal_html/html.dart" as html;

import '../models/customUser.dart';

class DataExporter {
  String? collectionDataToDownload = 'users';
  DataExporter({this.collectionDataToDownload});

  Future<void> downloadCSV() async {
    //Download Users data
    var csvData;
    QuerySnapshot querySnapshot;
    querySnapshot = await FirebaseFirestore.instance
        .collection(collectionDataToDownload!)
        .get();
    if (collectionDataToDownload == 'users') {
      csvData = getUsersDataAsCSV(querySnapshot);
    } else if (collectionDataToDownload == 'courses') {
      csvData = await getCoursesDataAsCSV(querySnapshot);
    }
    // Loop through the documents to populate the CSV data

    print(csvData);

    final buffer = ListToCsvConverter().convert(csvData);
    Uint8List bytes = Uint8List.fromList(utf8.encode(buffer));

    print(bytes);
    // Convert to Uint8List
    // Uint8List bytes = Uint8List.fromList(utf8.encode(buffer.toString()));

    // Create Blob and download the file
    //Older way of downloading data
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'data.csv')
      ..click();
    html.Url.revokeObjectUrl(url);

    List<List<String>> listOfLists = [
      ['1', 'Bilal Saeed', '1374934', '912839812'],
      ['2', 'Ahmar', '21341234', '192834821']
    ]; //Outter List which contains the data List
    List<String> header = ['a', 'b'];
    exportCSV.myCSV([], csvData);
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
      DocumentReference docRef = snapshot.reference;
      CollectionReference subCollectionRef =
          docRef.collection('subCollectionName');

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

  Future<List<List>> getCoursesDataAsCSV(QuerySnapshot querySnapshot) async {
    final List<QueryDocumentSnapshot> allData = querySnapshot.docs;

    List<List<String>> csvData = [
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
    // print(allData);
    // Loop through the documents to populate the CSV data

    for (QueryDocumentSnapshot snapshot in allData) {
      var examsModulesDataMap = await getExamsModulesDataForCourse(snapshot);
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Course coursesInfo = Course.fromMap(data);

      csvData.add([
        coursesInfo.name.toString(),
        coursesInfo.id.toString(),
        examsModulesDataMap['examsData']
            .toString(), //getting the exams data from the result returned by getExamsModulesDataForCourse
        coursesInfo.examsCount.toString(),
        examsModulesDataMap['modulesData']
            .toString(), //getting the modules data from the result returned by getExamsModulesDataForCourse
        coursesInfo.modulesCount.toString(),
        formattedDate(data['createdAt'])
        // data['createdAt'].toString(),
      ]);
    }
    return csvData;
  }

  //This function is for getting the exams and modules data for a particular course, and convert it into a map of Exams and Modules
  Future<Map<String, List<dynamic>>> getExamsModulesDataForCourse(
      QueryDocumentSnapshot queryDocumentSnapshot) async {
    List<dynamic> examsData = [];
    List<dynamic> modulesData = [];

    //fetching exams data for that course
    try {
      CollectionReference examsCollection =
          queryDocumentSnapshot.reference.collection("exams");
      QuerySnapshot examsCollectionSnapshot = await examsCollection.get();
      print('----------------------------------');
      for (var doc in examsCollectionSnapshot.docs) {
        examsData.add(doc.data());
        // Perform operations using data
      }
    } catch (e) {
      print(e);
      examsData = [];
    }

    //fetching modules data for that course

    try {
      CollectionReference modulesCollection =
          queryDocumentSnapshot.reference.collection("modules");
      QuerySnapshot modulesCollectionSnapshot = await modulesCollection.get();
      print('----------------------------------');
      for (var doc in modulesCollectionSnapshot.docs) {
        modulesData.add(doc.data());
        // Perform operations using data
      }
    } catch (e) {
      print(e);
      modulesData = [];
    }
    return {'examsData': examsData, 'modulesData': modulesData};
  }

  String formattedDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(dateTime);
    print(formattedDate);
    return formattedDate;
  }
}

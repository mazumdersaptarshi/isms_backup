// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

// import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:isms/models/course.dart';
import 'package:isms/utilityFunctions/csvDataHandler.dart';

import '../models/customUser.dart';
import '../utilityFunctions/exportAsCSV.dart';

class DataExporter {
  String? collectionDataToDownload = 'users';
  DataExporter({this.collectionDataToDownload});

  Future<void> downloadCSV() async {
    //Download Users data
    List<List> csvData=[];
    QuerySnapshot querySnapshot;
    querySnapshot = await FirebaseFirestore.instance
        .collection(collectionDataToDownload!)
        .get();
    if (collectionDataToDownload == 'users') {
      csvData = getUsersDataAsCSV(querySnapshot);
    } else if (collectionDataToDownload == 'courses') {
      csvData = await getCoursesDataAsCSV(querySnapshot);
    } else if (collectionDataToDownload == 'adminconsole') {
      getCoursesProgressDataAsCSV(querySnapshot);
    }
    // Loop through the documents to populate the CSV data

    if (kDebugMode) {
      print(csvData);
    }

    final buffer = const ListToCsvConverter().convert(csvData);
    Uint8List bytes = Uint8List.fromList(utf8.encode(buffer));

    if (kDebugMode) {
      print(bytes);
    }

    await Future.delayed(const Duration(
        seconds:
            1)); //Introducing delay to prevent spamming of download button in case download finishes too fast
    // exportAsCSV(csvData[0], csvData.sublist(1));
  }

  Future<void> getCoursesProgressDataAsCSV(QuerySnapshot querySnapshot) async {
    var allCourseItemsCollection = FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allcourses')
        .collection('allCourseItems');
    var allCourseItemsData = await allCourseItemsCollection.get();

    List<List<String>> csvData = [
      [
        'Course Title',
        'Course ID',
        'Course Creation Date',
        'Course Started',
        'Course Completed'
      ],
    ];
    for (var courseItemDoc in allCourseItemsData.docs) {
      // Access fields inside the sub-document
      var courseItem = courseItemDoc.data();

      // Process or print the field data as needed
      if (kDebugMode) {
        print(courseItem);
      }
      String courseName = courseItem['course_name'] ?? '';
      String courseId = courseItem['course_id'] ?? '';
      String creationDate =
          CSVDataHandler.timestampToReadableDate(courseItem['createdAt'])
                  .toString() ??
              '';
      List<String> courseCompletedUsers = [];
      List<String> courseStartedUsers = [];

      for (var user in courseItem['course_started'] ?? []) {
        courseStartedUsers.add(user['username'] ?? '');
      }
      for (var user in courseItem['course_completed'] ?? []) {
        courseCompletedUsers.add(user['username'] ?? '');
      }
      List<String> row = [
        courseName,
        courseId,
        creationDate,
        courseStartedUsers.toString(),
        courseCompletedUsers.toString()
      ];

      csvData.add(row);
      exportAsCSV(csvData[0], csvData.sublist(1),
          '$courseName -Progress Cumulative Report');
    }
  }

  List<List<String>> getUsersDataAsCSV(QuerySnapshot querySnapshot) {
    final List<QueryDocumentSnapshot> allData = querySnapshot.docs;

    List<List<String>> csvData = [
      // Define the headers
      ['username', 'email', 'courses_enrolled', 'courses_completed']
    ];
    if (kDebugMode) {
      print(allData);
    }
    // Loop through the documents to populate the CSV data

    for (QueryDocumentSnapshot snapshot in allData) {
      List<String> currentUserCoursesEnrolled = [];
      List<String> currentUserCoursesCompleted = [];
      List<String> currentUserCoursesCompletedIDs = [];
      List<String> currentUserModulesCompletedIDs = [];

      Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;
      CustomUser userInfo = CustomUser.fromMap(dataMap);

      List<List<String>> userCsvData = [
        // Define the headers
        [
          'username',
          'email',
          'Course Title',
          'Modules Started',
          'is Course completed',
          'is Module Completed'
        ]
      ];
      for (var course in dataMap['courses_completed']) {
        String courseTitle = course['course_name'] ?? '';
        String courseId = course['courseID'] ?? '';
        currentUserCoursesCompleted.add(courseTitle);
        currentUserCoursesCompletedIDs.add(courseId);
      }
      debugPrint(
          'currentUserCoursesCompletedIDs: $currentUserCoursesCompletedIDs');

      for (var course in dataMap['courses_started']) {
        String courseTitle = course['course_name'] ?? '';
        //String courseId = course['courseID'] ?? '';
        if (course['modules_completed'] != null) {
          debugPrint(course['modules_completed']);
          for (var module in course['modules_completed']) {
            try {
              currentUserModulesCompletedIDs.add(module['module_id']);
            } catch (e) {
              log(e.toString());
            }
          }
        }
        String moduleCompleted = 'no';
        if (course['modules_started'] != null) {
          for (var module in course['modules_started']) {
            if (kDebugMode) {
              print('$module ${userInfo.username}');
              print(currentUserModulesCompletedIDs);
            }

            try {
              if (currentUserModulesCompletedIDs
                  .contains(module['module_id'])) {
                moduleCompleted = 'yes';
              }
            } catch (e) {
              log(e.toString());
            }

            String courseCompleted = 'no';
            if (currentUserCoursesCompletedIDs.contains(course['courseID'])) {
              courseCompleted = 'yes';
            }
            currentUserCoursesEnrolled.add(courseTitle);
            debugPrint('ududud');
            try {
              List<String> row = [
                userInfo.username,
                userInfo.email,
                courseTitle,
                module['module_name'],
                courseCompleted,
                moduleCompleted
              ];
              userCsvData.add(row);
            } catch (e) {
              log(e.toString());
            }
          }
        }
      }
      exportAsCSV(userCsvData[0], userCsvData.sublist(1), userInfo.username);

      csvData.add([
        userInfo.username.toString(),
        userInfo.email.toString(),
        // userInfo.courses_started.toString(),
        currentUserCoursesEnrolled.toString(),
        // userInfo.courses_completed.toString()
        currentUserCoursesCompleted.toString(),
      ]);
    }

    String filePrefixName = 'Users_Overview';

    exportAsCSV(csvData[0], csvData.sublist(1), filePrefixName);
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
      Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;
      Course coursesInfo = Course.fromMap(dataMap);

      debugPrint(
          'examsModulesDataMap: ${examsModulesDataMap['modulesData'].toString()}');
      // var examsData = CSVDataHandler.mapsToReadableStringConverter(
      //     examsModulesDataMap['examsData']!);
      // var modulesData = CSVDataHandler.mapsToReadableStringConverter(
      //     examsModulesDataMap['modulesData']!);
      exportCourseOverviewDetails(dataMap, coursesInfo.name);
      exportCourseModulesSlides(
          examsModulesDataMap['modulesData']!, coursesInfo.name);
      exportCourseModulesQuestions(
          examsModulesDataMap['modulesData']!, coursesInfo.name);
      exportCourseExams(examsModulesDataMap['examsData']!, coursesInfo.name);

      csvData.add([
        coursesInfo.name.toString(),
        coursesInfo.id.toString(),
        examsModulesDataMap['examsData'].toString(),
        coursesInfo.examsCount.toString(),
        examsModulesDataMap['modulesData'].toString(),
        CSVDataHandler.timestampToReadableDate(dataMap['createdAt'])
      ]);
      // print(modulesData);
      // csvData.add([
      //   // data['name'].toString(),
      //   coursesInfo.name.toString(),
      //   coursesInfo.id.toString(),
      //
      //   examsData, //getting the exams data from the result returned by getExamsModulesDataForCourse
      //   coursesInfo.examsCount.toString(),
      //   // examsModulesDataMap['modulesData']
      //   //     .toString(), //getting the modules data from the result returned by getExamsModulesDataForCourse
      //   modulesData,
      //   coursesInfo.modulesCount.toString(),
      //   CSVDataHandler.timestampToReadableDate(data['createdAt'])
      //   // data['createdAt'].toString(),
      // ]);
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
      debugPrint('----------------------------------');
      for (var doc in examsCollectionSnapshot.docs) {
        examsData.add(doc.data());
        // Perform operations using data
      }
    } catch (e) {
      log(e.toString());
      examsData = [];
    }

    //fetching modules data for that course

    try {
      CollectionReference modulesCollection =
          queryDocumentSnapshot.reference.collection("modules");
      QuerySnapshot modulesCollectionSnapshot = await modulesCollection.get();
      debugPrint('----------------------------------');

      modulesData = await getModuleData(modulesCollectionSnapshot, modulesData);
    } catch (e) {
      log(e.toString());
      modulesData = [];
    }
    return {
      'examsData': examsData,
      'modulesData': modulesData,
    };
  }

  Future<List> getModuleData(QuerySnapshot modulesCollectionSnapshot,
      List<dynamic> moduleDataType) async {
    for (var doc in modulesCollectionSnapshot.docs) {
      var docData = doc.data() as Map<String, dynamic>;
      debugPrint('docData: ${doc.data()}');
      DocumentReference docRef = doc.reference;
      CollectionReference colRef = docRef.collection('slides');
      QuerySnapshot subCollectionSnapshot = await colRef.get();
      var moduleSlides = [];
      for (QueryDocumentSnapshot subDoc in subCollectionSnapshot.docs) {
        if (kDebugMode) {
          print(subDoc.data());
          print('titlee: ${subDoc['title']}');
          print('contentt: ${subDoc['content']}');
        }
        moduleSlides.add(subDoc.data());
      }
      debugPrint('moduleSlides: $moduleSlides');
      docData['slides'] = moduleSlides;
      debugPrint('newDocData: ${docData['slides']}');

      moduleDataType.add(docData);
    }

    for (var doc in modulesCollectionSnapshot.docs) {
      var docData = doc.data() as Map<String, dynamic>;
      debugPrint('docData: ${doc.data()}');
      DocumentReference docRef = doc.reference;
      CollectionReference colRef = docRef.collection('exams');
      QuerySnapshot subCollectionSnapshot = await colRef.get();
      var moduleExams = [];
      for (QueryDocumentSnapshot subDoc in subCollectionSnapshot.docs) {
        if (kDebugMode) {
          print(subDoc.data());
          print('titlee: ${subDoc['title']}');
          print('passing marks: ${subDoc['passing_marks']}');
        }
        moduleExams.add(subDoc.data());
      }
      debugPrint('moduleSlides: $moduleExams');
      docData['exams'] = moduleExams;
      debugPrint('newDocData: ${docData['slides']}');

      moduleDataType.add(docData);
    }
    return moduleDataType;
  }

  // This downloads the details of the Courses separately

  Future<void> exportCourseOverviewDetails(
      Map<String, dynamic> dataMap, String courseName) async {
    List<List<String>> csvData = [
      // Define the headers
      [
        'Course Title',
        'Course ID',
        'Number of Course exams',
        'Modules',
        'Number of Modules',
        'Creation Date'
      ]
    ];

    // Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    csvData.add([
      // data['name'].toString(),
      dataMap['name'].toString(),
      dataMap['id'].toString(),
      dataMap['examsCount'].toString(),
      dataMap['modulesCount'].toString(),
      CSVDataHandler.timestampToReadableDate(dataMap['createdAt'])
      // data['createdAt'].toString(),
    ]);
    String filePrefixName = '${courseName}_Overview';

    exportAsCSV(csvData[0], csvData.sublist(1), filePrefixName);
  }

  Future<void> exportCourseModulesSlides(List<dynamic> dataMap,
      [String? courseName]) async {
    List<List<String>> csvData = [];

    List<String> headers = [
      'Module Name',
      'Module Description',
      'Module Index',
      'Module ID',
      'Module Creation Date',
      'Number of Modules',
      'Slide Title',
      'Slide Content',
      'Slide Index',
      'Slide Id',
      'Slide Creation Date',
      'Number of Slides'
    ];
    csvData.add(headers);
    int modulesCount = dataMap.length;

    for (var module in dataMap) {
      String moduleTitle = module['title'] ?? '';
      String moduleDescription = module['contentDescription'] ?? '';
      String moduleIndex = module['index'].toString();

      String moduleId = module['id'].toString();
      String moduleCreationDate =
          CSVDataHandler.timestampToReadableDate(module['createdAt'])
              .toString();

      // Loop through each slide in the module
      var slides = module['slides'] ?? [];
      for (var slide in slides) {
        String slideTitle = slide['title'] ?? '';
        String slideContent = slide['content'] ?? '';
        slideContent = slideContent
            .replaceAll("<p>", "")
            .replaceAll("</p>", "")
            .replaceAll("<div><br></div>", ""); // Remove HTML tags
        String slideIndex = slide['index'].toString();
        String slideId = slide['id'].toString();
        String slideCreationDate =
            CSVDataHandler.timestampToReadableDate(slide['createdAt'])
                .toString();
        String slidesCount = slides.length.toString();

        // Create the CSV row and add it to csvData
        List<String> row = [
          moduleTitle,
          moduleDescription,
          moduleIndex,
          moduleId,
          moduleCreationDate,
          modulesCount.toString(),
          slideTitle,
          slideContent,
          slideIndex,
          slideId,
          slideCreationDate,
          slidesCount
        ];

        csvData.add(row);
      }
    }
    String filePrefixName = '${courseName}_Modules_Slides';

    exportAsCSV(csvData[0], csvData.sublist(1), filePrefixName);
  }

  Future<void> exportCourseModulesQuestions(List<dynamic> dataMap,
      [String? courseName]) async {
    List<List<String>> csvData = [];
    List<String> headers = [
      'Module Name',
      'Module Description',
      'Module Index',
      'Module ID',
      'Module Creation Date',
      'Question ID',
      'Question Text',
      'Options',
      'Passing Marks',
    ];

    csvData.add(headers);
    for (var module in dataMap) {
      String moduleTitle = module['title'] ?? '';
      String moduleDescription = module['contentDescription'] ?? '';
      String moduleIndex = module['index'].toString();

      String moduleId = module['id'].toString();
      String moduleCreationDate =
          CSVDataHandler.timestampToReadableDate(module['createdAt'])
              .toString();
      var exams = module['exams'] ?? [];
      for (var exam in exams) {
        String passingMarks = exam['passing_marks'].toString();
        var questionAnswerSet = exam['question_answer_set'] ?? [];
        debugPrint('questionAnswerSet: $questionAnswerSet');
        for (var set in questionAnswerSet) {
          String questionId = set['questionID'].toString();
          String questionText = set['questionName'] ?? '';
          String options = set['options'].toString();

          debugPrint('$questionId, $options');
          List<String> row = [
            moduleTitle,
            moduleDescription,
            moduleIndex,
            moduleId,
            moduleCreationDate,
            questionId,
            questionText,
            options,
            passingMarks,
          ];
          csvData.add(row);
        }
      }
    }
    String filePrefixName = '${courseName}_Modules_Questions';
    exportAsCSV(csvData[0], csvData.sublist(1), filePrefixName);
  }

  Future<void> exportCourseExams(List<dynamic> dataMap,
      [String? courseName]) async {
    List<List<String>> csvData = [];
    List<String> headers = [
      'Exam Index',
      'Title',
      'Exam ID',
      'Question ID',
      'Question',
      'Options',
      'Passing Marks',
    ];
    csvData.add(headers);
    for (var exam in dataMap) {
      String index = exam['index'].toString();
      String title = exam['title'] ?? '';
      String examId = exam['exam_ID'] ?? '';
      String passingMarks = exam['passing_marks'].toString();
      for (var setItem in exam['question_answer_set']) {
        String question = setItem['questionName'] ?? '';
        String questionId = setItem['questionID'] ?? '';
        String options = setItem['options'].toString();

        List<String> row = [
          index,
          title,
          examId,
          questionId,
          question,
          options,
          passingMarks,
        ];
        csvData.add(row);
      }
    }
    String filePrefixName = '${courseName}_Course_Exams';
    exportAsCSV(csvData[0], csvData.sublist(1), filePrefixName);
  }

  Future<void> exportCoursesProgressDetails(
      Map<String, dynamic> dataMap, String fileName) async {}
}

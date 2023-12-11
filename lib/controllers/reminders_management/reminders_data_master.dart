import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class RemindersDataMaster {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<List<dynamic>> fetchRemindersFromFirestore(
      String? domain) async {
    Map<String, dynamic> data = {};
    // await Future.delayed(Duration(seconds: 10));
    DocumentSnapshot docSnapshot = await db
        .collection('reminders') // Replace with your collection name
        .doc('allreminders')
        .collection("${domain ?? 'n/a'}")
        .doc('reminders') // Replace with your document ID
        .get();
    if (docSnapshot.exists) {
      data = docSnapshot.data() as Map<String, dynamic>;
      print(data);
    }

    return data['remindersList'];
  }

  static Future<List<dynamic>> fetchRemindersFromJSON(String? domain) async {
    String jsonString =
        await rootBundle.loadString('assets/data/domain01/remindersList.json');
    return json.decode(jsonString);
  }
}

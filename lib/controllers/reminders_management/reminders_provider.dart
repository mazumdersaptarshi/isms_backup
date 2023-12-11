import 'package:flutter/foundation.dart';
import 'package:isms/controllers/reminders_management/reminders_data_master.dart';
// import 'package:isms/remindersManagement/reminders_data_master.dart';

class RemindersProvider with ChangeNotifier {
  List<dynamic> allReminders = [];
  static bool remindersFetched = false;
  RemindersProvider() {
    remindersFetched = false;
  }
  Future<Map<String, List<Map<String, dynamic>>>> getAllReminders() async {
    if (!remindersFetched) {
      // allReminders =
      //     await RemindersDataMaster.fetchRemindersFromFirestore('domain01');
      allReminders =
          await RemindersDataMaster.fetchRemindersFromJSON('domain01');

      remindersFetched = true;
    }
    print(remindersFetched);
    return groupByDate(allReminders);
    // return allReminders;
  }

  Map<String, List<Map<String, dynamic>>> groupByDate(
      List<dynamic> allReminders) {
    Map<String, List<Map<String, dynamic>>> groupedByDate = {};

    for (var item in allReminders) {
      if (!groupedByDate.containsKey(item['date'])) {
        groupedByDate[item['date']] = [];
      }
      groupedByDate[item['date']]!.add(item);
    }
    groupedByDate.forEach((key, value) {
      print('\n');
      print(key);

      print(groupedByDate[key]);
    });
    return groupedByDate;
  }
}

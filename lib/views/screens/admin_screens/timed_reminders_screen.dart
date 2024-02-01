import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/reminders_management/reminders_provider.dart';
import '../../../controllers/user_management/logged_in_state.dart';
import '../../../utilities/platform_check.dart';

// import '../../../utilityFunctions/platform_check.dart';
// import '../../controllers/remindersManagement/reminders_provider.dart';
// // import '../../remindersManagement/reminders_provider.dart';
// // import '../../userManagement/logged_in_state.dart';
// import '../../controllers/userManagement/logged_in_state.dart';
// import '../../utilityFunctions/platform_check.dart';

class TimedRemindersScreen extends StatelessWidget {
  const TimedRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RemindersProvider remindersProvider = context.watch<RemindersProvider>();
    final loggedInState = context.watch<LoggedInState>();
    return Scaffold(
      // appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: Column(
        children: [
          FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
            future: remindersProvider.getAllReminders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while waiting for the future to complete
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Handle the error state
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // Handle the case when the data is available
                List<String>? dates = snapshot.data?.keys.toList(); // Get all the date keys
                return Expanded(
                  child: ListView.builder(
                    itemCount: dates?.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      String? date = dates?[index];
                      List<Map<String, dynamic>>? itemsForDate = snapshot.data?[date]!;

                      // Build your list item here using snapshot.data[index]
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.grey.shade700,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      date!,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                            ...buildListItems(itemsForDate!)
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                // Handle the case when there's no data (can show a message or an empty state widget)
                return Text('No data available');
              }
            },
          ),
        ],
      ),
    );
  }
}

List<Widget> buildListItems(List<Map<String, dynamic>> items) {
  List<Widget> listItems = [];
  for (var item in items) {
    listItems.add(
      Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (item.containsKey('number'))
                Expanded(
                  flex: 1,
                  child: Text(
                    item['number'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.containsKey('categoryName') && item['categoryName'] != "")
                      Container(
                        child: Text(
                          item['categoryName'] ?? 'n/a',
                          style: TextStyle(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          color: (item['categoryType'] == 'required')
                              ? Colors.red
                              : (item['categoryType'] == 'as_needed')
                                  ? Colors.yellow.shade800
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                    Row(
                      children: [
                        if (item.containsKey('actionItemLabel'))
                          Text(
                            '${item['actionItemLabel']}:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        if (item.containsKey('actionItemName'))
                          Text('${item['actionItemName']}', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    if (item.containsKey('documentItem')) Text('${item['documentItem']}' ?? ''),
                    if (item.containsKey('actionSubItems'))
                      if (item['actionSubItems'].length > 0)
                        ...buildListItems(
                            List.from(item['actionSubItems']).map((item) => item as Map<String, dynamic>).toList())
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return listItems;
}

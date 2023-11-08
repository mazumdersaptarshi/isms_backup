import 'package:flutter/material.dart';

Widget CourseModulesDetailsDropdownWidget(
    String title, List<dynamic> modules, BuildContext context) {
  return Container(
    padding: EdgeInsets.all(8),
    constraints: BoxConstraints(minHeight: 50),
    child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${title}:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          for (int i = 0; i < modules.length; i++)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: i % 2 == 1 ? Colors.grey.shade100 : Colors.transparent,
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: (modules[i] is Map<String, dynamic>)
                    ? Text(
                        '${modules[i]['module_name'].toString()!}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      )
                    : Text(''),
              ),
            )
        ],
      ),
    ),
  );
}

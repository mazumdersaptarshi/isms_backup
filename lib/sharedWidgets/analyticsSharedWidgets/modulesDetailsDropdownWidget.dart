// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

Widget CourseModulesDropdownWidget(String title, List<dynamic>? modulesStarted,
    List<dynamic>? modulesCompleted, BuildContext context) {
  List<String> modulesCompletedList = [];
  for (var module in modulesCompleted!) {
    modulesCompletedList.add(module['module_name']);
  }

  return Container(
    padding: const EdgeInsets.all(8),
    constraints: const BoxConstraints(minHeight: 50),
    child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          for (int i = 0; i < modulesStarted!.length; i++)
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: i % 2 == 1 ? Colors.grey.shade100 : Colors.transparent,
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: (modulesStarted[i] is Map<String, dynamic>)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            modulesStarted[i]['module_name'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          modulesCompletedList
                                  .contains(modulesStarted[i]['module_name'])
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.lightGreen,
                                )
                              : const Icon(
                                  Icons.pending_rounded,
                                  color: Colors.orangeAccent,
                                )
                        ],
                      )
                    : const Text(''),
              ),
            )
        ],
      ),
    ),
  );
}

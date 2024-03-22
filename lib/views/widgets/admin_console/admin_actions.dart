import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/course/course_exam_relationship.dart';
import 'package:isms/views/widgets/shared_widgets/custom_dropdown_widget.dart';
import 'package:isms/views/widgets/shared_widgets/custom_searchable_dropdown.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:isms/views/widgets/shared_widgets/multi_select_search_widget.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';

class AdminActions extends StatefulWidget {
  AdminActions({
    super.key,
    required this.courses,
    required this.allDomainUsersSummary,
  });

  List<CourseExamRelationship> courses = [CourseExamRelationship(courseId: 'ip78hd', courseTitle: 'oplkj')];
  List<UsersSummaryData> allDomainUsersSummary = [];

  @override
  State<AdminActions> createState() => _AdminActionsState();
}

class _AdminActionsState extends State<AdminActions> {
  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  late AdminState adminState;
  String? _selectedCourseForAssignmentAction = 'none';
  List<String> _selectedCoursesForAssignmentAction = [];
  String? _selectedUserIdForAssignmentAction = 'none';
  String? _selectedCourseEnableDisableValue = 'disable';
  int? _selectedYears;
  int? _selectedMonths;
  List<SelectableItem> _selectedCoursesList = [];
  List<SelectableItem> _selectedUsersList = [];

  // List<Map<String, dynamic>> allDomainUsersDropdown = [
  //   {'userId': 'none', 'name': 'none'}
  // ];
  TextEditingController _deadlineDateController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (_pickedDate != null) {
      setState(() {
        _deadlineDateController.text = _pickedDate.toString().split(" ")[0];
      });
    }
  }

  List<int> _buildTimeIntervalMenuItems(int count) {
    List<int> items = [];
    for (int i = 0; i <= count; i++) {
      items.add(i);
    }
    return items;
  }

  Future<String> _createOrUpdateUserCourseAssignments({
    required List<SelectableItem> courses,
    required List<SelectableItem> users,
    required String enabledOrDisabled,
    String? deadline,
    int? years,
    int? months,
  }) async {
    var message = await adminState.createOrUpdateUserCourseAssignments(
      courses: courses,
      users: users,
      enabled: enabledOrDisabled == 'enabled' ? true : false,
      deadline: deadline!,
      years: years.toString(),
      months: months.toString(),
    );
    print(message);
    return message.toString();
  }

  void _showMultiSelectCoursesModal(List<CourseExamRelationship> courses) async {
    final List<SelectableItem> selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: MultiSelectSearch(
            items: courses.sublist(1),
          ),
        );
      },
    );

    if (selected != null) {
      // Dialog was closed with selected items
      setState(() {
        _selectedCoursesList = selected;
      });
      print(_selectedCoursesList);
    }
  }

  void _showMultiSelectUsersModal(List<UsersSummaryData> users) async {
    final List<SelectableItem> selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: MultiSelectSearch(
            items: users,
          ),
        );
      },
    );

    if (selected != null) {
      // Dialog was closed with selected items
      setState(() {
        _selectedUsersList = selected;
      });
      print(_selectedUsersList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.fromLTRB(80, 12, 80, 30),
      decoration: BoxDecoration(
        border: Border.all(color: getTertiaryColor1()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HoverableSectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assign course to user',
                    style: TextStyle(
                      fontSize: 14,
                      color: getTertiaryTextColor1(),
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 40,
                  ),
                  Wrap(
                    spacing: 20, // Horizontal space between children
                    runSpacing: 20, // Vertical space between runs
                    alignment: WrapAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 8),
                            child: Text(
                              'Courses',
                              style: TextStyle(
                                fontSize: 12,
                                // fontWeight: FontWeight.bold,
                                color: getTertiaryTextColor1(), // Adjust the color to match your theme
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _showMultiSelectCoursesModal(widget.courses),
                            child: Container(
                              width: 150,
                              padding: EdgeInsets.symmetric(vertical: 13),
                              child: Row(
                                children: [
                                  Text('Select Courses'),
                                  Spacer(),
                                  Icon(Icons.arrow_drop_down_rounded),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 8),
                            child: Text(
                              'Users',
                              style: TextStyle(
                                fontSize: 12,
                                // fontWeight: FontWeight.bold,
                                color: getTertiaryTextColor1(), // Adjust the color to match your theme
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _showMultiSelectUsersModal(widget.allDomainUsersSummary),
                            child: Container(
                                width: 150,
                                padding: EdgeInsets.symmetric(vertical: 13),
                                child: Row(
                                  children: [
                                    Text('Select Users'),
                                    Spacer(),
                                    Icon(Icons.arrow_drop_down_rounded),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      CustomDropdownWidget<String>(
                        label: 'Status',
                        hintText: 'Status',
                        value: _selectedCourseEnableDisableValue,
                        items: ['enable', 'disable'],
                        onChanged: (value) {
                          setState(() => _selectedCourseEnableDisableValue = value);
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 8),
                            child: Text(
                              'Deadline',
                              style: TextStyle(
                                fontSize: 12,
                                // fontWeight: FontWeight.bold,
                                color: getTertiaryTextColor1(), // Adjust the color to match your theme
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _selectDate,
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: getTertiaryColor1()),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _deadlineDateController.text.isEmpty
                                        ? 'Select Deadline'
                                        : _deadlineDateController.text,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Icon(Icons.calendar_today, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Text('Recurring Interval'),
                      CustomDropdownWidget<int>(
                        label: 'Recurring Interval',
                        hintText: 'Years',
                        value: _selectedYears,
                        items: _buildTimeIntervalMenuItems(10),
                        onChanged: (value) {
                          setState(() {
                            _selectedYears = value!;
                          });
                        },
                      ),
                      CustomDropdownWidget<int>(
                        label: '',
                        hintText: 'Months',
                        value: _selectedMonths,
                        items: _buildTimeIntervalMenuItems(12),
                        onChanged: (value) {
                          setState(() {
                            _selectedMonths = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      if (_selectedCoursesList.length > 0)
                        SelectedItemsWidget(label: 'Selected Courses', selectedItemsList: _selectedCoursesList),
                      if (_selectedUsersList.length > 0)
                        SelectedItemsWidget(label: 'Selected Users', selectedItemsList: _selectedUsersList)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          print('${_selectedCourseForAssignmentAction} $_selectedUserIdForAssignmentAction '
                              '$_selectedCourseEnableDisableValue  ${_deadlineDateController.text} $_selectedYears'
                              ' $_selectedMonths');

                          var message = await _createOrUpdateUserCourseAssignments(
                            courses: _selectedCoursesList,
                            users: _selectedUsersList,
                            enabledOrDisabled: _selectedCourseEnableDisableValue!,
                            deadline: _deadlineDateController.text,
                            years: _selectedYears,
                            months: _selectedMonths,
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              if (message.contains('success')) {
                                return Dialog(
                                  child: Container(
                                      width: 500,
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            '${message}',
                                            style: TextStyle(
                                              color: Colors.lightGreen,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Icon(
                                            CupertinoIcons.check_mark_circled,
                                            color: Colors.lightGreen,
                                            size: 40,
                                          ),
                                        ],
                                      )),
                                );
                              } else
                                return Dialog(
                                  child: Container(
                                      width: 500,
                                      height: 100,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        '${message}',
                                        style: TextStyle(color: Colors.red),
                                      )),
                                );
                            },
                          );
                        },
                        child: Container(
                            width: 100,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.save),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Save'),
                              ],
                            ))),
                  ),
                ],
              ),
              onHover: (bool) {},
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedItemsWidget extends StatelessWidget {
  SelectedItemsWidget({
    super.key,
    required this.label,
    required this.selectedItemsList,
  });

  final List<SelectableItem> selectedItemsList;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100, // Set a fixed height for the list of selected courses
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("$label:",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontSize: 14,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: selectedItemsList.length,
            itemBuilder: (context, index) {
              return Text(
                selectedItemsList[index].itemName,
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: getTertiaryTextColor1(),
                  fontSize: 14,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

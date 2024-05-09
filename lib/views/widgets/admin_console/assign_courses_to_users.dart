import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/course/course_info.dart';
import 'package:isms/models/shared_widgets/custom_dropdown_item.dart';
import 'package:isms/views/widgets/shared_widgets/build_secondary_header.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/custom_dropdown_button_widget.dart';
import 'package:isms/views/widgets/shared_widgets/custom_dropdown_widget.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:isms/views/widgets/shared_widgets/multi_select_search_widget.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';
import 'package:isms/views/widgets/shared_widgets/selected_items_display_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssignCoursesToUserSection extends StatefulWidget {
  const AssignCoursesToUserSection({
    super.key,
    required this.courses,
    required this.allDomainUsersSummary,
    required this.CSRFToken,
    required this.JWT,
  });

  final List<CourseInfo> courses;
  final List<UsersSummaryData> allDomainUsersSummary;

  final String CSRFToken;
  final String JWT;

  @override
  State<AssignCoursesToUserSection> createState() => _AssignCoursesToUserSectionState();
}

class _AssignCoursesToUserSectionState extends State<AssignCoursesToUserSection> {
  @override
  void initState() {
    super.initState();
    // _buildEnableDisableDropdown(context);

    adminState = AdminState();
  }

  late AdminState adminState;
  String? _selectedCourseForAssignmentAction = 'none';
  List<String> _selectedCoursesForAssignmentAction = [];
  String? _selectedUserIdForAssignmentAction = 'none';
  String? _selectedCourseEnableDisableValue = 'disable';
  CustomDropdownItem<String>? _selectedCourseEnableDisable;

  // late List<CustomDropdownItem<String>> _enableDisableDropdownItems;

  List<CustomDropdownItem<String>> _enableDisableDropdownItems = [
    CustomDropdownItem(key: 'Enable', value: 'enable'),
    CustomDropdownItem(key: 'Disable', value: 'disable'),
  ];

  void _buildEnableDisableDropdown(BuildContext context) {
    print('Came here');
    List<CustomDropdownItem<String>> enableDisableDropdownItems = [
      CustomDropdownItem(key: 'Enable', value: 'enable', label: '${AppLocalizations.of(context)?.enable}'),
      CustomDropdownItem(key: 'Disable', value: 'disable', label: '${AppLocalizations.of(context)?.disable}'),
    ];
    _enableDisableDropdownItems = enableDisableDropdownItems;
    // return enableDisableDropdownItems;
  }

  List<CustomDropdownItem<int>> _years = [
    CustomDropdownItem(key: '1', value: 1),
    CustomDropdownItem(key: '2', value: 2),
    CustomDropdownItem(key: '3', value: 3),
    CustomDropdownItem(key: '4', value: 4),
    CustomDropdownItem(key: '5', value: 5),
    CustomDropdownItem(key: '6', value: 6),
    CustomDropdownItem(key: '7', value: 7),
    CustomDropdownItem(key: '8', value: 8),
    CustomDropdownItem(key: '9', value: 9),
    CustomDropdownItem(key: '10', value: 10),
  ];

  List<CustomDropdownItem<int>> _months = [
    CustomDropdownItem(key: '1', value: 1),
    CustomDropdownItem(key: '2', value: 2),
    CustomDropdownItem(key: '3', value: 3),
    CustomDropdownItem(key: '4', value: 4),
    CustomDropdownItem(key: '5', value: 5),
    CustomDropdownItem(key: '6', value: 6),
    CustomDropdownItem(key: '7', value: 7),
    CustomDropdownItem(key: '8', value: 8),
    CustomDropdownItem(key: '9', value: 9),
    CustomDropdownItem(key: '10', value: 10),
    CustomDropdownItem(key: '11', value: 11),
    CustomDropdownItem(key: '12', value: 12),
  ];

  List<SelectableItem> _selectedCoursesList = [];
  List<SelectableItem> _selectedUsersList = [];
  CustomDropdownItem<int>? _selectedYearsItem;
  CustomDropdownItem<int>? _selectedMonthsItem;

  void _showMultiSelectCoursesModal(List<CourseInfo> courses) async {
    final List<SelectableItem> selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: MultiSelectSearch(
            items: courses.sublist(1),
            selectedItemsList: _selectedCoursesList,
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

  void _showMultiSelectUsersModal(List<UsersSummaryData> users) async {
    final List<SelectableItem> selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: MultiSelectSearch(
            items: users,
            selectedItemsList: _selectedUsersList,
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

  Future<String> _createOrUpdateUserCourseAssignments({
    required List<SelectableItem> courses,
    required List<SelectableItem> users,
    required String enabledOrDisabled,
    String? deadline,
    int? years,
    int? months,
  }) async {
    // var message = await adminState.createOrUpdateUserCourseAssignments(
    //   courses: courses,
    //   users: users,
    //   enabled: enabledOrDisabled == 'enable' ? true : false,
    //   deadline: deadline!,
    //   years: years.toString(),
    //   months: months.toString(),
    // );
    // var message = await adminState.insertOrUpdateUserCourseAssignments(
    //   courses: courses,
    //   users: users,
    //   enabled: enabledOrDisabled == 'enable' ? true : false,
    //   deadline: deadline!,
    //   years: years.toString(),
    //   months: months.toString(),
    // );
    var message = await adminState.insertOrUpdateUserCourseAssignments(
      CSRFToken: widget.CSRFToken,
      JWT: widget.JWT,
      courses: courses,
      users: users,
      enabled: enabledOrDisabled == 'enable' ? true : false,
      deadline: deadline!,
      years: years.toString(),
      months: months.toString(),
    );
    return message.toString();
  }

  @override
  Widget build(BuildContext context) {
    List<CustomDropdownItem<String>> enableDisableDropdownItems = [
      CustomDropdownItem(key: 'Enable', value: 'enable', label: '${AppLocalizations.of(context)?.enable}'),
      CustomDropdownItem(key: 'Disable', value: 'disable', label: '${AppLocalizations.of(context)?.disable}'),
    ];
    return HoverableSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)?.assignCoursesToUsers}',
            style: TextStyle(
              fontSize: 16,
              color: ThemeConfig.primaryTextColor,
            ),
          ),
          // Divider(),
          SizedBox(
            height: 20,
          ),
          // Text(
          //   'Assign course to user',
          //   style: TextStyle(
          //     fontSize: 14,
          //     color: ThemeConfig.tertiaryTextColor1!,
          //   ),
          // ),
          // Divider(),
          // SizedBox(
          //   height: 40,
          // ),
          Wrap(
            spacing: 20, // Horizontal space between children
            runSpacing: 20, // Vertical space between runs
            alignment: WrapAlignment.start,
            children: [
              CustomDropdownButton(
                  label: '${AppLocalizations.of(context)?.courses}',
                  buttonText: '${AppLocalizations.of(context)?.selectCourses}',
                  onButtonPressed: () => _showMultiSelectCoursesModal(widget.courses)),
              CustomDropdownButton(
                label: '${AppLocalizations.of(context)?.users}',
                buttonText: '${AppLocalizations.of(context)?.selectUsers}',
                onButtonPressed: () => _showMultiSelectUsersModal(widget.allDomainUsersSummary),
              ),
              if (_enableDisableDropdownItems.isNotEmpty)
                CustomDropdownWidget<String>(
                  label: '${AppLocalizations.of(context)?.status}',
                  hintText: '${AppLocalizations.of(context)?.selectStatus}',
                  value: _selectedCourseEnableDisable,
                  items: _enableDisableDropdownItems,
                  onChanged: (CustomDropdownItem<String>? value) {
                    setState(() {
                      _selectedCourseEnableDisable = value!;
                      _selectedCourseEnableDisableValue = _selectedCourseEnableDisable?.value;
                    });
                  },
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 8),
                    child: Text(
                      '${AppLocalizations.of(context)?.deadline}',
                      style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                        color: ThemeConfig.tertiaryTextColor1!,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      width: 200,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: ThemeConfig.borderColor1, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _deadlineDateController.text.isEmpty
                                ? '${AppLocalizations.of(context)?.selectDeadline}'
                                : _deadlineDateController.text,
                            style: TextStyle(fontSize: 14, color: ThemeConfig.secondaryTextColor),
                          ),
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: ThemeConfig.secondaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              CustomDropdownWidget<int>(
                label: '${AppLocalizations.of(context)?.recurringInterval}',
                hintText: '${AppLocalizations.of(context)?.years}',
                value: _selectedYearsItem,
                items: _years,
                onChanged: (CustomDropdownItem<int>? value) {
                  setState(() {
                    _selectedYearsItem = value!;
                  });
                },
              ),
              CustomDropdownWidget<int>(
                label: '',
                hintText: '${AppLocalizations.of(context)?.months}',
                value: _selectedMonthsItem,
                items: _months,
                onChanged: (CustomDropdownItem<int>? value) {
                  setState(() {
                    _selectedMonthsItem = value!;
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
                SelectedItemsWidget(
                  label: AppLocalizations.of(context)!.selectedCourses,
                  selectedItemsList: _selectedCoursesList,
                ),
              if (_selectedUsersList.length > 0)
                SelectedItemsWidget(
                  label: AppLocalizations.of(context)!.selectedUsers,
                  selectedItemsList: _selectedUsersList,
                ),
            ],
          ),

          SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                style: ThemeConfig.elevatedRoundedButtonStyle,
                onPressed: () async {
                  var message = await _createOrUpdateUserCourseAssignments(
                    courses: _selectedCoursesList,
                    users: _selectedUsersList,
                    enabledOrDisabled: _selectedCourseEnableDisable!.value,
                    deadline: _deadlineDateController.text,
                    years: _selectedYearsItem?.value,
                    months: _selectedMonthsItem?.value,
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
                        Icon(
                          Icons.save,
                          color: ThemeConfig.secondaryTextColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${AppLocalizations.of(context)?.save}',
                          style: TextStyle(color: ThemeConfig.secondaryTextColor),
                        ),
                      ],
                    ))),
          ),

          // buildUsersCourseAssignmentsList()
        ],
      ),
      onHover: (bool) {},
    );
  }
}

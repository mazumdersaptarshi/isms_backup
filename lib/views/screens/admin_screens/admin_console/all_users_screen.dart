import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/admin_management/users_analytics.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/custom_expansion_tile.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  late AdminState adminState;

  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    Map _allUsers = {};
    List<int> _selectedUsers = [];

    List _getAllUsers() {
      _allUsers = UsersAnalytics.getAllUsersList(allUsersData: adminState.getAllUsersData);
      // print(_allUsers);
      var usersList = _allUsers.entries.toList();

      return usersList;
    }

    int _hoveredRowIndex = -1; // Index of the hovered row

    void _onRowEnter(int index) {
      setState(() {
        _hoveredRowIndex = index;
      });
    }

    void _onRowExit(int index) {
      setState(() {
        _hoveredRowIndex = -1;
      });
    }

    return Scaffold(
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: PlatformCheck.topNavBarWidget(context, loggedInState),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionHeader(title: 'All Users'),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.fromLTRB(150, 10, 150, 30),
            decoration: BoxDecoration(
              border: Border.all(color: getTertiaryColor1()),
              borderRadius: BorderRadius.circular(20),
            ),
            // Wrap DataTable in ClipRRect to apply the border radius
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Match container's border radius
              child: DataTable(
                headingRowHeight: 70,
                headingRowColor: MaterialStateProperty.resolveWith(
                  (states) => getPrimaryColorShade(30),
                ),

                // headingRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                //   return getPrimaryColorShade(50)!; // Choose your color
                // }),

                columns: [
                  // DataColumn(
                  //   label: Checkbox(
                  //     value: false,
                  //     onChanged: (bool? value) {},
                  //   ),
                  // ),
                  DataColumn(
                      label: Text(
                    'Username',
                    style: TextStyle(
                      color: getTertiaryTextColor1(),
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Email',
                    style: TextStyle(
                      color: getTertiaryTextColor1(),
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Role',
                    style: TextStyle(
                      color: getTertiaryTextColor1(),
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  DataColumn(label: Text('')),
                ],
                rows: List<DataRow>.generate(_getAllUsers().length, (index) {
                  final user = _getAllUsers()[index];
                  // Alternate row color based on index
                  final rowColor = MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      // If the row is selected, return a different color
                      if (states.contains(MaterialState.hovered)) {
                        print('Hovered state detected!');

                        return getPrimaryColorShade(50);
                      }

                      // If the row is selected, return a different color
                      if (states.contains(MaterialState.selected)) {
                        return primary;
                      } else
                        return null;

                      // Even rows will have a different color
                      return index % 2 == 0 ? getTertiaryColor1() : null;
                    },
                  );
                  return DataRow(
                    color: rowColor,
                    selected: _selectedUsers.contains(index),
                    onSelectChanged: (bool? isSelected) {
                      // Checkbox changed
                      setState(() {
                        if (isSelected != null) {
                          isSelected ? _selectedUsers.add(index) : _selectedUsers.remove(index);
                        }
                        print(_selectedUsers);
                      });
                    },
                    cells: [
                      DataCell(Text(
                        '${user.value['username']}',
                        style: TextStyle(fontSize: 14),
                      )),
                      DataCell(Text(
                        '${user.value['email']}',
                        style: TextStyle(fontSize: 14),
                      )),
                      DataCell(Row(
                        children: [
                          Text(
                            '${user.value['role']}',
                            style: TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_drop_down_rounded),
                          )
                        ],
                      )),
                      DataCell(
                        Container(
                          // Introduce a Container
                          alignment: Alignment.centerRight, // Align content to the right
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end, // Push buttons to the end
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle deletion for the user at index 'index'
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

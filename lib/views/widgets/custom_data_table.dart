import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/views/screens/admin_screens/admin_console/admin_user_details_screen.dart';
import 'package:isms/views/screens/testing/test_ui_type1/user_test_responses.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/search_bar_widget.dart';

class UsersSummaryTable extends StatefulWidget {
  UsersSummaryTable({Key? key, required this.usersList}) : super(key: key);
  List usersList = [];

  @override
  State<UsersSummaryTable> createState() => _UsersSummaryTableState();
}

class _UsersSummaryTableState extends State<UsersSummaryTable> {
  @override
  void initState() {
    super.initState();
  }

  bool _isExpanded = false; // State to manage expanded/collapsed view
  List columnHeaders = [];
  Map<int, bool> isHoveringMap = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionHeader(
          title: 'All Users',
          actionWidget1: SearchBarWidget(),
          actionWidget2: _buildToggleExpandButton(),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.fromLTRB(80, 12, 80, 30),
          // decoration: BoxDecoration(
          //   border: Border.all(color: ThemeConfig.secondaryColor),
          //   borderRadius: BorderRadius.circular(6),
          // ),
          child: Column(
            children: [
              _buildHeaderRow(),
              ...widget.usersList.asMap().entries.map((entry) {
                int index = entry.key;

                var value = entry.value;
                return _buildDataRow(item: value, index: index, listLength: widget.usersList.length);
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleExpandButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded; // Toggle the state
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              _isExpanded
                  ? CupertinoIcons.arrow_down_right_arrow_up_left
                  : CupertinoIcons.arrow_up_left_arrow_down_right,
              size: 18,
            ),
            SizedBox(
              width: 14,
            ),
            Text(
              _isExpanded ? "Less details" : "More details",
            ),
          ],
        ),
      ),
      style: TextButton.styleFrom(
        side: BorderSide(color: Colors.blue, width: 2), // Blue border of width 2
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // Rounded corners with a radius of 6
        ),
      ),
    );
  }

  // Header Row Builder
  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.all(8),
      // decoration: BoxDecoration(
      //     // Styling of the header row
      //     // color: ThemeConfig.secondaryColor,
      //     ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: Row(
          children: [
            // _buildHeaderCell(
            //   text: '',
            //   type: 'text',
            //   // icon: Icon(Icons.check_box_outline_blank_rounded),
            // ),
            _buildHeaderCell(
              text: 'Username',
              type: 'text',
            ),
            _buildHeaderCell(
              text: 'Email',
              type: 'text',
            ),
            _buildHeaderCell(
              text: 'Role',
              type: 'text',
            ),
            if (_isExpanded)
              _buildHeaderCell(
                text: 'Courses Learning Completed (%)',
                type: 'text',
              ),
            if (_isExpanded)
              _buildHeaderCell(
                text: 'Courses Assigned',
                type: 'text',
              ),
            if (_isExpanded)
              _buildHeaderCell(
                text: 'Average Score (%)',
                type: 'text',
              ),
            if (_isExpanded)
              _buildHeaderCell(
                text: 'Exams Taken',
                type: 'text',
              ),
            if (_isExpanded)
              _buildHeaderCell(
                text: 'Exams Pending',
                type: 'text',
              ),
            if (_isExpanded)
              _buildHeaderCell(
                text: 'Last Login',
                type: 'text',
              ),
            // Spacer(),
            // _buildHeaderCell(
            //   text: '',
            //   type: 'button',
            // ),
          ],
          // children: columnHeaders
          //     .map((header) => _buildHeaderCell(text: header, type: 'text'))
          //     .toList()
          //   ..add(_buildHeaderCell(
          //       text: '', type: 'text')), // For actions or icons column
        ),
      ),
    );
  }

  // Individual Data Row Builder
  Widget _buildDataRow({required dynamic item, int? index, int? listLength}) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          // Set hover state to true for this item
          isHoveringMap[index ?? 0] = true;
        });
      },
      onExit: (_) {
        setState(() {
          // Set hover state to false for this item
          isHoveringMap[index ?? 0] = false;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        // padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isHoveringMap[index ?? 0] == true ? ThemeConfig.hoverBorderColor! : Colors.transparent,
            width: 2,
            // isHoveringMap[index] == true ? primary! : Colors.grey.shade200,
          ),
          borderRadius: index == (listLength! - 1)
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : isHoveringMap[index ?? 0] == true
                  ? BorderRadius.all(Radius.circular(6))
                  // : BorderRadius.zero,
                  : BorderRadius.all(Radius.circular(6)),
          // color: isHoveringMap[index ?? 0] == true
          //     ? ThemeConfig.hoverFillColor1
          //     : Theme.of(context).scaffoldBackgroundColor,
          color: ThemeConfig.primaryCardColor,
          boxShadow: [
            BoxShadow(
              color: ThemeConfig.hoverShadowColor!,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // _buildDataCell(
            //   type: 'icon',
            //   icon: Icon(Icons.account_circle_rounded),
            //   isHovering: isHoveringMap[index ?? 0] ?? false,
            // ),
            _buildDataCell(
              text: item.name,
              type: 'text',
              icon: Icon(
                Icons.account_circle_rounded,
                color: ThemeConfig.iconFillColor1,
              ),
              isHovering: isHoveringMap[index ?? 0] ?? false,
              action: 'link',
              actionFunction: () => {
                context.goNamed(NamedRoutes.adminConsole.name, pathParameters: {'uid': item.uid})
                // Then close the drawer
              },
            ),
            _buildDataCell(
              text: item.emailId,
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            _buildDataCell(
              text: item.role,
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            if (_isExpanded)
              _buildDataCell(
                text: item.coursesLearningCompletedPercentage.toString(),
                type: 'text',
                isPercentage: true,
                isHovering: isHoveringMap[index ?? 0] ?? false,
              ),
            if (_isExpanded)
              _buildDataCell(
                text: item.coursesAssigned.toString(),
                type: 'text',
                isHovering: isHoveringMap[index ?? 0] ?? false,
              ),
            if (_isExpanded)
              _buildDataCell(
                text: item.averageScore.toString(),
                type: 'text',
                isHovering: isHoveringMap[index ?? 0] ?? false,
                isPercentage: true,
              ),
            if (_isExpanded)
              _buildDataCell(
                text: item.examsTaken.toString(),
                type: 'text',
                isHovering: isHoveringMap[index ?? 0] ?? false,
              ),
            if (_isExpanded)
              _buildDataCell(
                text: item.examsPending.toString(),
                type: 'text',
                isHovering: isHoveringMap[index ?? 0] ?? false,
              ),
            if (_isExpanded)
              _buildDataCell(
                text: item.lastLogin,
                type: 'text',
                isHovering: isHoveringMap[index ?? 0] ?? false,
                iconAlignment: 'right',
                icon: Icon(
                  Icons.watch_later_outlined,
                  size: 20,
                  color: ThemeConfig.iconFillColor1,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helpers for Header & Data Cells
  Widget _buildHeaderCell({String? text, required String type, Icon? icon}) {
    return Expanded(
      // Makes sure all columns have equal width
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        child: type == 'text'
            ? _getHeaderCellTextWidget(text: text!, icon: icon)
            : type == 'icon'
                ? _getHeaderCellIconWidget(icon: icon!)
                : _buildToggleExpandButton(),
      ),
    );
  }

  Widget _getHeaderCellIconWidget({required Icon icon}) {
    return IconButton(onPressed: () {}, icon: icon);
  }

  Widget _getHeaderCellTextWidget({required String text, Icon? icon}) {
    return Row(
      children: [
        if (icon != null)
          Row(
            children: [
              icon,
              SizedBox(
                width: 4,
              ),
            ],
          ),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.clip,
            softWrap: true,
            style: TextStyle(
              fontSize: 16,
              // fontWeight: FontWeight.bold,
              color: ThemeConfig.tertiaryTextColor1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataCell({
    String? text,
    required String type,
    bool? isHovering,
    Icon? icon,
    String? iconAlignment,
    bool? isPercentage,
    String? action,
    Function? actionFunction,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        child: (type == 'text' && action != null && action == 'link')
            ? _getDataCellActionLinkWidget(
                text: text!,
                isHovering: isHovering!,
                icon: icon,
                iconAlignment: iconAlignment,
                isPercentage: isPercentage,
                actionFunction: actionFunction,
              )
            : type == 'text'
                ? _getDataCellTextWidget(
                    text: text!,
                    isHovering: isHovering!,
                    icon: icon,
                    iconAlignment: iconAlignment,
                    isPercentage: isPercentage,
                  )
                : type == 'action'
                    ? _getDataCellIconsWidget(
                        isHovering: isHovering!,
                      )
                    : type == 'icon'
                        ? _getDataCellIconWidget(icon: icon!)
                        : null,
      ),
    );
  }

  Widget _getDataCellTextWidget(
      {required String text, bool? isHovering, Icon? icon, String? iconAlignment, bool? isPercentage}) {
    text = text == 'null' ? '0' : text;
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // if (iconAlignment != null && iconAlignment == 'left' && icon != null) icon,
        // Spacer(),
        if (isPercentage == null || isPercentage == false)
          Flexible(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: text == 'admin'
                      ? ThemeConfig.tertiaryColor1!
                      // : text == 'user'
                      //     ? Colors.grey.shade200
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                text,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(
                  fontSize: 14,
                  color: isHovering! ? ThemeConfig.hoverTextColor : ThemeConfig.primaryTextColor,
                ),
              ),
            ),
          ),
        if (iconAlignment != null && iconAlignment == 'right' && icon != null)
          Row(
            children: [
              SizedBox(
                width: 4,
              ),
              icon,
            ],
          ),
        if (isPercentage != null || isPercentage == true)
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(
                    value: double.parse(text) / 100.0,
                    valueColor: double.parse(text) > 70
                        ? AlwaysStoppedAnimation<Color>(Colors.lightGreen!)
                        : double.parse(text) > 45
                            ? AlwaysStoppedAnimation<Color>(Colors.orangeAccent!)
                            : AlwaysStoppedAnimation<Color>(Colors.red!),
                    backgroundColor: ThemeConfig.percentageIconBackgroundFillColor,
                    strokeWidth: 6.0,
                  ),
                ),
              ),
              Text(
                '${text}%',
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeConfig.primaryTextColor,
                ),
              ),
            ],
          )
      ],
    );
  }

  Widget _getDataCellIconWidget({required Icon icon}) {
    return IconButton(onPressed: () {}, icon: icon);
  }

  Widget _getDataCellIconsWidget({bool? isHovering}) {
    return Row(
      children: [
        Icon(
          Icons.edit,
          color: isHovering! ? ThemeConfig.primaryColor : Colors.black,
        ),
        SizedBox(
          width: 12,
        ),
        Icon(
          Icons.delete,
          color: isHovering! ? ThemeConfig.primaryColor : Colors.black,
        ),
      ],
    );
  }

  Widget _getDataCellActionLinkWidget(
      {required String text,
      bool? isHovering,
      Icon? icon,
      String? iconAlignment,
      bool? isPercentage,
      Function? actionFunction}) {
    return TextButton(
        onPressed: () => actionFunction!(),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // if (iconAlignment != null && iconAlignment == 'left' && icon != null) icon,
            // Spacer(),
            if (icon != null)
              Row(
                children: [
                  icon,
                  SizedBox(
                    width: 4,
                  ),
                ],
              ),
            if (isPercentage == null || isPercentage == false)
              Flexible(
                child: Container(
                  // padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: text == 'admin'
                          ? ThemeConfig.getPrimaryColorShade(50)
                          : text == 'user'
                              ? Colors.grey.shade200
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    text,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                      color: isHovering! ? ThemeConfig.hoverTextColor : ThemeConfig.primaryTextColor,
                    ),
                  ),
                ),
              ),
            if (iconAlignment != null && iconAlignment == 'right' && icon != null)
              Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  icon,
                ],
              ),
            if (isPercentage != null || isPercentage == true)
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: CircularProgressIndicator(
                      value: double.parse(text) / 100.0,
                      valueColor: double.parse(text) > 70
                          ? AlwaysStoppedAnimation<Color>(Colors.lightGreen!)
                          : double.parse(text) > 45
                              ? AlwaysStoppedAnimation<Color>(Colors.orangeAccent!)
                              : AlwaysStoppedAnimation<Color>(Colors.red!),
                      backgroundColor: Colors.grey.shade200,
                      strokeWidth: 5.0,
                    ),
                  ),
                  Text(
                    '${text}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeConfig.primaryTextColor,
                    ),
                  ),
                ],
              )
          ],
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/common_theme.dart';
import 'package:isms/views/screens/admin_screens/admin_console/admin_user_details_screen.dart';
import 'package:isms/views/screens/testing/test_ui_type1/user_test_responses.dart';

class CustomDataTable extends StatefulWidget {
  CustomDataTable({Key? key, required this.usersList}) : super(key: key);
  List usersList = [];

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  @override
  void initState() {
    super.initState();
  }

  bool _isExpanded = false; // State to manage expanded/collapsed view
  List columnHeaders = [];
  Map<int, bool> isHoveringMap = {};

  @override
  Widget build(BuildContext context) {
    print('usersList: ${widget.usersList}');
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.fromLTRB(80, 12, 80, 30),
      decoration: BoxDecoration(
        border: Border.all(color: getTertiaryColor1()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(20), // Match container's border radius

        child: Column(
          children: [
            _buildHeaderRow(),
            ...widget.usersList.asMap().entries.map((entry) {
              int index = entry.key;
              var value = entry.value;
              return _buildDataRow(
                  item: value,
                  index: index,
                  listLength: widget.usersList.length);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleExpandButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle the state
            });
          },
          style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
            (states) => Colors.transparent,
          )),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: primary,
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                _isExpanded ? "Less details" : "More details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
      ],
    );
  }

  // Header Row Builder
  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Styling of the header row
        color: Colors.grey.shade200,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Space cells out

          children: [
            _buildHeaderCell(
              text: '',
              type: 'icon',
              icon: Icon(Icons.check_box_outline_blank_rounded),
            ),
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
                text: 'Courses Completed (%)',
                type: 'text',
              ),
            if (_isExpanded)
              _buildHeaderCell(
                text: 'Courses Enrolled',
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
                text: 'Last Login',
                type: 'text',
              ),
            Spacer(),
            _buildHeaderCell(
              text: '',
              type: 'button',
            ),
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
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade200,
            // isHoveringMap[index] == true ? primary! : Colors.grey.shade200,
          ),
          borderRadius: index == (listLength! - 1)
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : BorderRadius.zero, // Border(

          color: isHoveringMap[index ?? 0] == true
              ? Colors.grey.shade100
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // Space cells out
          children: [
            _buildDataCell(
              type: 'icon',
              icon: Icon(Icons.check_box_outline_blank_rounded),
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            _buildDataCell(
                text: item.username,
                type: 'text',
                isHovering: isHoveringMap[index ?? 0] ?? false,
                action: 'link',
                actionFunction: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminUserDetailsScreen()))
                // icon: Icon(
                //   CupertinoIcons.profile_circled,
                //   color: Colors.grey.shade700,
                //   size: 20,
                // ),
                // iconAlignment: 'left',
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
                text: item.coursesCompletedPercentage.toString(),
                type: 'text',
                isPercentage: true,
                isHovering: isHoveringMap[index ?? 0] ?? false,
              ),
            if (_isExpanded)
              _buildDataCell(
                text: item.coursesEnrolled.toString(),
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
                text: item.lastLogin,
                type: 'text',
                isHovering: isHoveringMap[index ?? 0] ?? false,
                iconAlignment: 'right',
                icon: Icon(
                  Icons.watch_later_outlined,
                  size: 20,
                  color: Colors.grey.shade700,
                ),
              ),
            Spacer(),
            _buildDataCell(
              type: 'action',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
          ],
          // children: cellValues
          //     .map((cellValue) => _buildDataCell(
          //         text: cellValue.toString(),
          //         isHovering: isHoveringMap[index ?? 0] ?? false,
          //         type: 'text'))
          //     .toList(),
        ),
      ),
    );
  }

  // Helpers for Header & Data Cells
  Widget _buildHeaderCell({String? text, required String type, Icon? icon}) {
    return Expanded(
      // Makes sure all columns have equal width
      child: Container(
        padding: const EdgeInsets.all(8.0),
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
      mainAxisAlignment: MainAxisAlignment.end,
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
            textAlign: TextAlign.right,
            overflow: TextOverflow.clip,
            softWrap: true,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
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
        padding: const EdgeInsets.all(8.0),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (iconAlignment != null &&
                iconAlignment == 'left' &&
                icon != null)
              icon,
            Spacer(),
            if (isPercentage == null || isPercentage == false)
              Flexible(
                child: Container(
                  // padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: text == 'admin'
                          ? getPrimaryColorShade(50)
                          : text == 'user'
                              ? Colors.grey.shade200
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    text,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                      color: isHovering! ? primary : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            if (iconAlignment != null &&
                iconAlignment == 'right' &&
                icon != null)
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
                              ? AlwaysStoppedAnimation<Color>(
                                  Colors.orangeAccent!)
                              : AlwaysStoppedAnimation<Color>(Colors.red!),
                      backgroundColor: Colors.grey.shade200,
                      strokeWidth: 5.0,
                    ),
                  ),
                  Text(
                    '${text}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              )
          ],
        ));
  }

  Widget _getDataCellTextWidget(
      {required String text,
      bool? isHovering,
      Icon? icon,
      String? iconAlignment,
      bool? isPercentage}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (iconAlignment != null && iconAlignment == 'left' && icon != null)
          icon,
        Spacer(),
        if (isPercentage == null || isPercentage == false)
          Flexible(
            child: Container(
              // padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: text == 'admin'
                      ? getPrimaryColorShade(50)
                      : text == 'user'
                          ? Colors.grey.shade200
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                text,
                textAlign: TextAlign.right,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(
                  fontSize: 14,
                  color: isHovering! ? primary : Colors.grey.shade700,
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
                  color: Colors.grey.shade700,
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
      mainAxisAlignment: MainAxisAlignment.end, // Align these items to the end

      children: [
        Icon(
          Icons.edit,
          color: isHovering! ? primary : Colors.black,
        ),
        SizedBox(
          width: 12,
        ),
        Icon(
          Icons.delete,
          color: isHovering! ? primary : Colors.black,
        ),
      ],
    );
  }
}

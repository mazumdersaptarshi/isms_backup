import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

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
    // Populate _rowColors on initialization
    // columnHeaders = extractKeysFromUsersList(widget.usersList);
    // widget.usersList.isNotEmpty ? widget.usersList[0].keys.toList() : [];
  }

  List columnHeaders = [];
  Map<int, bool> isHoveringMap = {};
  List extractKeysFromUsersList(List usersList) {
    if (usersList.isNotEmpty) {
      // Assuming all maps in the list have the same structure,
      // we take the first item's value (which is a Map) and extract its keys.
      Map firstItemValue = usersList.first.value;
      List keys = firstItemValue.keys.toList();
      print("keys: $keys");
      return keys;
    }
    return [];
  }

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
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Space cells out

          children: [
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
            _buildHeaderCell(
              text: 'Courses Completed',
              type: 'text',
            ),
            _buildHeaderCell(
              text: 'Courses Enrolled',
              type: 'text',
            ),
            _buildHeaderCell(
              text: 'Average Score',
              type: 'text',
            ),
            _buildHeaderCell(
              text: 'Exams Taken',
              type: 'text',
            ),
            _buildHeaderCell(
              text: 'Last Login',
              type: 'text',
            ),
            Spacer(),
            _buildHeaderCell(
              text: '',
              type: 'icon',
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
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Space cells out
          children: [
            _buildDataCell(
              text: item.username,
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
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
            _buildDataCell(
              text: item.coursesCompletedPercentage.toString(),
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            _buildDataCell(
              text: item.coursesEnrolled.toString(),
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            _buildDataCell(
              text: item.averageScore.toString(),
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            _buildDataCell(
              text: item.examsTaken.toString(),
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            _buildDataCell(
              text: item.lastLogin,
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            Spacer(),
            _buildDataCell(
              type: 'icon',
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
  Widget _buildHeaderCell({
    String? text,
    required String type,
  }) {
    return Expanded(
      // Makes sure all columns have equal width
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: type == 'text' ? _getHeaderCellTextWidget(text: text!) : null,
      ),
    );
  }

  Widget _getHeaderCellTextWidget({required String text}) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildDataCell({
    String? text,
    required String type,
    bool? isHovering,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: type == 'text'
            ? _getDataCellTextWidget(
                text: text!,
                isHovering: isHovering!,
              )
            : type == 'icon'
                ? _getDataCellIconsWidget(
                    isHovering: isHovering!,
                  )
                : null,
      ),
    );
  }

  Widget _getDataCellTextWidget({
    required String text,
    bool? isHovering,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: isHovering! ? primary : Colors.grey.shade700,
      ),
    );
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

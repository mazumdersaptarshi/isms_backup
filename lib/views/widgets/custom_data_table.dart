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
  }

  Map<int, bool> isHoveringMap = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.fromLTRB(150, 12, 150, 30),
      decoration: BoxDecoration(
        border: Border.all(color: getTertiaryColor1()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Match container's border radius

        child: Column(
          children: [
            _buildHeaderRow(),
            ...widget.usersList.asMap().entries.map((entry) {
              final item = entry.value;
              return _buildDataRow(item: item.value, index: entry.key, listLength: widget.usersList.length);
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
            Spacer(),
            _buildHeaderCell(
              text: '',
              type: 'text',
            ),
          ],
        ),
      ),
    );
  }

  // Individual Data Row Builder
  Widget _buildDataRow({required Map item, int? index, int? listLength}) {
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
            color: isHoveringMap[index] == true ? primary! : Colors.grey.shade200,
          ),
          borderRadius: index == (listLength! - 1)
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : BorderRadius.zero, // Border(

          color: isHoveringMap[index ?? 0] == true ? getPrimaryColorShade(50) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Space cells out
          children: [
            _buildDataCell(
              text: item['username'],
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            _buildDataCell(
              text: item['email']!,
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            _buildDataCell(
              text: item['role']!,
              type: 'text',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
            Spacer(),
            _buildDataCell(
              type: 'icon',
              isHovering: isHoveringMap[index ?? 0] ?? false,
            ),
          ],
        ),
      ),
    );
  }

  // Helpers for Header & Data Cells
  Widget _buildHeaderCell({String? text, required String type}) {
    return Expanded(
      // Makes sure all columns have equal width
      child: Padding(
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

  Widget _buildDataCell({String? text, required String type, bool? isHovering}) {
    return Expanded(
      child: Padding(
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

  Widget _getDataCellTextWidget({required String text, bool? isHovering}) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, color: isHovering! ? primary : Colors.black),
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

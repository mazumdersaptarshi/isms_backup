import 'package:flutter/cupertino.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';

class SelectedItemsWidget extends StatefulWidget {
  SelectedItemsWidget({
    super.key,
    required this.label,
    required this.selectedItemsList,
  });

  final List<SelectableItem> selectedItemsList;
  final String label;

  @override
  State<SelectedItemsWidget> createState() => _SelectedItemsWidgetState();
}

class _SelectedItemsWidgetState extends State<SelectedItemsWidget> {
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
            child: widget.selectedItemsList.length > 1
                ? Text("${widget.label} (${widget.selectedItemsList.length}):",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.secondaryTextColor,
                      fontSize: 14,
                    ))
                : Text("${widget.label} :",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.secondaryTextColor,
                      fontSize: 14,
                    )),
          ),
          SizedBox(
            height: 5,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.selectedItemsList.length,
            itemBuilder: (context, index) {
              return Text(
                '${widget.selectedItemsList[index].itemName} ',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: ThemeConfig.tertiaryTextColor1!,
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

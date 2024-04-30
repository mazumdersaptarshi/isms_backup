import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';

class MultiSelectSearch extends StatefulWidget {
  final List<SelectableItem> items;
  List<SelectableItem>? selectedItemsList = [];

  MultiSelectSearch({Key? key, required this.items, this.selectedItemsList}) : super(key: key);

  @override
  _MultiSelectSearchState createState() => _MultiSelectSearchState();
}

class _MultiSelectSearchState extends State<MultiSelectSearch> {
  List<SelectableItem> _selectedItems = [];
  final TextEditingController _controller = TextEditingController();
  bool _selectAll = false;
  Map<int, bool> hoverStates = {};

  @override
  void initState() {
    super.initState();
    _selectAll = false;
  }

  void _updateSelectAllStatus() {
    setState(() {
      _selectAll = _selectedItems.length == widget.items.length;
    });
  }

  void _toggleSelectAll(bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedItems = List.from(widget.items);
      } else {
        _selectedItems.clear();
      }
      _selectAll = selected!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeConfig.primaryCardColor,
      // Apply the background color to the outer container
      padding: EdgeInsets.all(16.0),
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      // This makes sure to take full height
      child: Column(
        children: [
          Expanded(
            // This will ensure the content takes all the space except for the button
            child: Row(
              children: [
                Expanded(flex: 2, child: buildMultiSelectColumn(context)),
                Expanded(
                  flex: 1,
                  child: buildSelectedItemsDisplay(),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ThemeConfig.elevatedRoundedButtonStyle,
            onPressed: () {
              Navigator.of(context).pop(_selectedItems);
            },
            child: Container(
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
                style: TextStyle(color: ThemeConfig.secondaryTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMultiSelectColumn(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TextField(
            controller: _controller,
            style: TextStyle(
              color: ThemeConfig.primaryTextColor,
            ),
            decoration: InputDecoration(
              labelText: 'Search',
              labelStyle: TextStyle(color: ThemeConfig.tertiaryTextColor1),
              suffixIcon: Icon(Icons.search, color: ThemeConfig.tertiaryTextColor1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: ThemeConfig.primaryColor!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: ThemeConfig.tertiaryTextColor1), // Color when not focused
              ),
              filled: false,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        ListTile(
          hoverColor: ThemeConfig.hoverFillColor4,
          leading: Theme(
            data: ThemeData(
              unselectedWidgetColor: ThemeConfig.tertiaryTextColor1, // Color for the radio when not selected
            ),
            child: Checkbox(
              value: _selectAll,
              onChanged: _toggleSelectAll,
              activeColor: ThemeConfig.primaryColor,
            ),
          ),
          title: Text(
            'Select All',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeConfig.primaryTextColor,
            ),
          ),
          onTap: () => _toggleSelectAll(!_selectAll),
        ),
        Divider(color: Colors.grey.shade300),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              SelectableItem item = widget.items[index];
              bool isSelected = _selectedItems.contains(item);

              return Visibility(
                visible:
                    _controller.text.isEmpty || item.itemName.toLowerCase().contains(_controller.text.toLowerCase()),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => hoverStates[index] = true),
                  onExit: (_) => setState(() => hoverStates[index] = false),
                  child: Container(
                    decoration: BoxDecoration(
                      // Change border color based on hover state
                      border: Border.all(
                        color: hoverStates[index] ?? false ? ThemeConfig.hoverBorderColor1! : Colors.transparent,
                        width: 2, // Adjust the width as needed
                      ),
                      borderRadius: BorderRadius.circular(6), // Optional: if you want rounded corners
                    ),
                    margin: EdgeInsets.symmetric(vertical: 4), // Add space between list items
                    child: ListTile(
                      hoverColor: ThemeConfig.hoverFillColor4,
                      titleTextStyle: TextStyle(
                          color:
                              hoverStates[index] ?? false ? ThemeConfig.hoverTextColor : ThemeConfig.primaryTextColor),
                      subtitleTextStyle: TextStyle(
                        color: ThemeConfig.tertiaryTextColor1,
                      ),
                      title: Text(item.itemName),
                      subtitle: Text(
                        'ID: ${item.itemId}',
                        style: TextStyle(
                          color: ThemeConfig.tertiaryTextColor1,
                        ),
                      ),
                      leading: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: ThemeConfig.tertiaryTextColor1,
                        ),
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true && !_selectedItems.contains(item)) {
                                _selectedItems.add(item);
                              } else if (selected == false && _selectedItems.contains(item)) {
                                _selectedItems.remove(item);
                              }
                              _updateSelectAllStatus();
                            });
                          },
                          activeColor: ThemeConfig.primaryColor,
                        ),
                      ),
                      onTap: () => setState(() {
                        if (!_selectedItems.contains(item)) {
                          _selectedItems.add(item);
                        } else {
                          _selectedItems.remove(item);
                        }
                        _updateSelectAllStatus();
                      }),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildSelectedItemsDisplay() {
    if (widget.selectedItemsList != null && widget.selectedItemsList!.isNotEmpty) {
      _selectedItems = widget.selectedItemsList!;
    }
    return Container(
      padding: EdgeInsets.all(16.0),
      // color: ThemeConfig.secondaryCardColor, // Different background for visual separation
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          Text(
            "Selected(${_selectedItems.length}) :",
            style: TextStyle(
              color: ThemeConfig.primaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Divider(color: Colors.grey.shade300),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0, // horizontal space between chips
                  runSpacing: 8.0, // vertical space between lines
                  children: _selectedItems
                      .map((item) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ThemeConfig.hoverBorderColor1!, // Border color
                                width: 2, // Border width
                              ),
                              borderRadius: BorderRadius.circular(6), // Border radius
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Padding inside the container
                              child: Text(
                                item.itemName,
                                style: TextStyle(
                                  color: ThemeConfig.secondaryTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

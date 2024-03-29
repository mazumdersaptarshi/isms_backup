import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';

class MultiSelectSearch extends StatefulWidget {
  final List<SelectableItem> items;

  const MultiSelectSearch({Key? key, required this.items}) : super(key: key);

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
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: ThemeConfig.primaryColor!),
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
            leading: Checkbox(
              value: _selectAll,
              onChanged: _toggleSelectAll,
              activeColor: ThemeConfig.primaryColor,
            ),
            title: Text(
              'Select All',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () => _toggleSelectAll(!_selectAll),
          ),
          Divider(color: Colors.grey.shade300),
          Expanded(
            child: ListView.builder(
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
                          color: hoverStates[index] ?? false ? ThemeConfig.hoverBorderColor! : Colors.transparent,
                          width: 1, // Adjust the width as needed
                        ),
                        borderRadius: BorderRadius.circular(8), // Optional: if you want rounded corners
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4), // Add space between list items
                      child: ListTile(
                        hoverColor: ThemeConfig.hoverFillColor4,
                        titleTextStyle: TextStyle(
                            color: hoverStates[index] ?? false
                                ? ThemeConfig.hoverTextColor
                                : ThemeConfig.primaryTextColor),
                        subtitleTextStyle: TextStyle(color: ThemeConfig.getPrimaryColorShade(200)),
                        title: Text(item.itemName),
                        subtitle: Text('ID: ${item.itemId}'),
                        leading: Checkbox(
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
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop(_selectedItems);
            },
            child: Container(
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Text(textAlign: TextAlign.center, 'Submit'),
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

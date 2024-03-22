import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        // Select all items
        _selectedItems = List.from(widget.items);
      } else {
        // Clear all selections
        _selectedItems.clear();
      }
      _selectAll = selected!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          CheckboxListTile(
            title: Text('Select All'),

            value: _selectAll,
            onChanged: _toggleSelectAll,
            controlAffinity: ListTileControlAffinity.leading, // Position checkbox at the start of the tile
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                SelectableItem item = widget.items[index];
                bool isSelected = _selectedItems.contains(item);
                return _controller.text.isEmpty || item.itemName.toLowerCase().contains(_controller.text.toLowerCase())
                    ? CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        // Position checkbox at the start of the tile

                        title: Text(item.itemName),
                        subtitle: Text('ID: ${item.itemId}'),
                        value: isSelected,
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true && !_selectedItems.contains(item)) {
                              _selectedItems.add(item);
                            } else if (selected == false && _selectedItems.contains(item)) {
                              _selectedItems.remove(item);
                            }
                            _updateSelectAllStatus(); // Update the status of the Select All checkbox
                          });
                        },
                      )
                    : Container();
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedItems);
            },
            child: Text('Submit'),
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

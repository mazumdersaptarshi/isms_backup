import 'package:flutter/material.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';

class SingleSelectSearch extends StatefulWidget {
  final List<SelectableItem> items;

  const SingleSelectSearch({Key? key, required this.items}) : super(key: key);

  @override
  _SingleSelectSearchState createState() => _SingleSelectSearchState();
}

class _SingleSelectSearchState extends State<SingleSelectSearch> {
  SelectableItem? _selectedItem;
  final TextEditingController _controller = TextEditingController();

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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                SelectableItem item = widget.items[index];
                bool isSelected = _selectedItem == item;
                return _controller.text.isEmpty || item.itemName.toLowerCase().contains(_controller.text.toLowerCase())
                    ? RadioListTile<SelectableItem>(
                        title: Text(item.itemName),
                        subtitle: Text('ID: ${item.itemId}'),
                        value: item,
                        groupValue: _selectedItem,
                        onChanged: (SelectableItem? value) {
                          setState(() {
                            _selectedItem = value;
                          });
                        },
                      )
                    : Container();
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedItem);
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

import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart'; // Import your theme
import 'package:isms/controllers/theme_management/theme_config.dart';
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
  Map<int, bool> hoverStates = {};

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
                  borderSide: BorderSide(color: ThemeConfig.primaryColor!), // Use theme primary color
                ),
                filled: false,
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
                      child: ListTile(
                        hoverColor: ThemeConfig.hoverFillColor4,
                        // tileColor: hoverStates[index] ?? false ? getPrimaryColorShade(50) : Colors.transparent,
                        // Apply hover color
                        titleTextStyle: TextStyle(
                            color: hoverStates[index] ?? false
                                ? ThemeConfig.hoverTextColor
                                : ThemeConfig.primaryTextColor),
                        subtitleTextStyle: TextStyle(color: ThemeConfig.getPrimaryColorShade(200)),
                        title: Text(
                          item.itemName,
                        ),
                        subtitle: Text('ID: ${item.itemId}'),
                        leading: Radio<SelectableItem>(
                          hoverColor: ThemeConfig.getPrimaryColorShade(50),
                          value: item,
                          groupValue: _selectedItem,
                          onChanged: (SelectableItem? value) {
                            setState(() {
                              _selectedItem = value;
                            });
                          },
                          activeColor: ThemeConfig.primaryColor, // Use theme primary color
                        ),
                        onTap: () => setState(() {
                          _selectedItem = item;
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
              Navigator.of(context).pop(_selectedItem);
            },
            child: Container(
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
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

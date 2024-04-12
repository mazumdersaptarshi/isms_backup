import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _searchController = TextEditingController();
  String _searchValue = "";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Wrap the TextField in Expanded to use available space but leave room for the actionWidget
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust the spacing as needed
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),

            // Reduced vertical padding

            filled: true,
            fillColor: Colors.grey[200], // Adjust the search bar's fill color as needed
          ),
        ),
      ),
    );
  }
}

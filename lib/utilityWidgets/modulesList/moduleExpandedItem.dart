// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ModuleExpandedItem extends StatefulWidget {
  final Map<String, dynamic> info;
  final Function? onPressed;
  const ModuleExpandedItem({super.key, required this.info, this.onPressed});

  @override
  State<ModuleExpandedItem> createState() => _ModuleExpandedItemState();
}

class _ModuleExpandedItemState extends State<ModuleExpandedItem> {
  bool completed = false;

  /*void _toggleCompleted() {
    setState(() {
      completed = !completed;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.info['info_title']),
      trailing: const SizedBox(
        width: 30,
        height: 30,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(Icons.pages),
        ),
      ),
      onTap: () {
        widget.onPressed!();
      },
    );
  }
}

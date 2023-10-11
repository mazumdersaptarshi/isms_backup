import 'package:flutter/material.dart';

class ModuleExpandedItem extends StatefulWidget {
  final Map<String, dynamic> info;
  Function? onPressed;
  ModuleExpandedItem({required this.info, this.onPressed});

  @override
  _ModuleExpandedItemState createState() => _ModuleExpandedItemState();
}

class _ModuleExpandedItemState extends State<ModuleExpandedItem> {
  bool completed = false;

  void _toggleCompleted() {
    setState(() {
      completed = !completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.info['info_title']),
      trailing: SizedBox(
        width: 30,
        height: 30,
        child: SizedBox(
          width: 30,
          height: 30,
          child: widget.info['info_status']
              ? const Icon(Icons.check_circle_rounded, color: Colors.green)
              : const Icon(Icons.circle, color: Colors.orange),
        ),
      ),
      onTap: () {
        widget.onPressed!();
      },
    );
  }
}

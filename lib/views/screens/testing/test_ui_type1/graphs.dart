import 'package:flutter/material.dart';

class GraphsPage extends StatelessWidget {
  const GraphsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphs'),
      ),
      body: Center(
        child: Text('Content for Graphs Page'),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:isms/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Object? obj = await getFromFirebase();
  if (obj != null)
    runApp(HtmlExample(
      object: obj!,
    ));
}

Future<Map<String, dynamic>?> getFromFirebase() async {
  DocumentSnapshot docSnap =
      await FirebaseFirestore.instance.collection("test").doc("1").get();

  print("DISPLAYYYY ${docSnap.data().runtimeType}");
  return docSnap.data() as Map<String, dynamic>;
}

class HtmlExample extends StatelessWidget {
  HtmlExample({required this.object});
  Object object;
  @override
  Widget build(BuildContext context) {
    var objjj = object as Map;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HTML Example'),
        ),
        body: Center(
          child: ListView(
            children: [
              HtmlWidget(
                '''
                ${objjj['data']}
                ''',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

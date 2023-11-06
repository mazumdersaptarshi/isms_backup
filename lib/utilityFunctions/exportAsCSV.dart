library to_csv;

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

exportAsCSV(List<String> headerRow, List<List<String>> listOfListOfStrings,
    String fileNamePrefix,
    {bool sharing = false}) async {
  debugPrint("***** Gonna Create cv *****");
  //create the final list of lists containing the header and the data
  List<List<String>> headerAndDataList = [];
  headerAndDataList.add(headerRow);
  for (var dataRow in listOfListOfStrings) {
    headerAndDataList.add(dataRow);
  }
  String csvData = const ListToCsvConverter().convert(headerAndDataList);
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);
  if (kIsWeb) {
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '${fileNamePrefix ?? 'csv_export'}_$formattedDate.csv';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  } else if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isWindows ||
      Platform.isMacOS) {
    final bytes = utf8.encode(csvData);
    Uint8List bytes2 = Uint8List.fromList(bytes);
    MimeType type = MimeType.csv;
    final xFile = await FileSaver.instance.saveAs(
        name: '${fileNamePrefix ?? 'csv_export'}_$formattedDate.csv',
        bytes: bytes2,
        ext: 'csv',
        mimeType: type);
    if (sharing == true) {
      final xFile = XFile.fromData(
        bytes2,
        mimeType: 'csv',
        name: 'CSV File',
      );
      await Share.shareXFiles([xFile]);
    }
  }
}

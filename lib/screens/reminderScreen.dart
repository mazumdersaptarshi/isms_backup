import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

Future<void> setExpiryDate(
  String uid,
  String certificateName,
  DateTime? expiryDate,
) async {
  DocumentReference adminDocRef = FirebaseFirestore.instance
      .collection('adminconsole')
      .doc('allAdmins')
      .collection('admins')
      .doc(uid);

  await adminDocRef.get().then((doc) async {
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List certifications = data['certifications'] as List? ?? [];
      int existingIndex = certifications
          .indexWhere((cert) => cert['certification_name'] == certificateName);

      Map<String, dynamic> certificateDetails = {
        'certification_name': certificateName,
        'expiredTime':
            expiryDate != null ? Timestamp.fromDate(expiryDate) : null,
        'reminderSent': false,
      };

      if (existingIndex != -1) {
        certifications[existingIndex] = certificateDetails;
      } else {
        certifications.add(certificateDetails);
      }

      await adminDocRef.update({'certifications': certifications});
    } else {
      await adminDocRef.set({
        'certifications': [
          {
            'certification_name': certificateName,
            'expiredTime':
                expiryDate != null ? Timestamp.fromDate(expiryDate) : null,
            'reminderSent': false,
          },
        ],
      });
    }
  });
}

class ReminderLine extends StatefulWidget {
  final String text;
  final Function(String, DateTime?) setExpiryDateForCertificate;
  final DateTime? initialExpiryDate; // Added parameter

  ReminderLine({
    Key? key,
    required this.text,
    required this.setExpiryDateForCertificate,
    this.initialExpiryDate, // Updated constructor
  }) : super(key: key);

  @override
  _ReminderLineState createState() => _ReminderLineState();
}

class _ReminderLineState extends State<ReminderLine> {
  late DateTime selectedDate;
  DateTime? expiryDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    expiryDate = widget.initialExpiryDate; // Set initial expiry date
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              CupertinoButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Select Date"),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        content: SizedBox(
                          height: 300,
                          width: 500,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: selectedDate,
                            minimumDate: DateTime(2023),
                            maximumDate: DateTime(2100),
                            onDateTimeChanged: (DateTime newDate) {
                              setState(() {
                                selectedDate = newDate;
                              });
                            },
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              DateTime? pickedTime = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Select Time"),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 20),
                                    content: SizedBox(
                                      height: 300,
                                      child: CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: selectedDate,
                                        onDateTimeChanged: (DateTime newDate) {
                                          setState(() {
                                            selectedDate = DateTime(
                                              selectedDate.year,
                                              selectedDate.month,
                                              selectedDate.day,
                                              newDate.hour,
                                              newDate.minute,
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(selectedDate);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.deepOrange,
                                            ),
                                            SizedBox(width: 10),
                                            Text("Set time"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (pickedTime != null) {
                                widget.setExpiryDateForCertificate(
                                  loggedInState.currentUserUid!,
                                  pickedTime,
                                );
                                setState(() {
                                  expiryDate = pickedTime;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.deepOrange,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Set Date",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 254),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_calendar,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Set",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              if (expiryDate != null)
                Icon(
                  Icons.check,
                  color: Colors.deepPurpleAccent.shade100,
                ),
              if (expiryDate == null && widget.initialExpiryDate != null)
                Icon(
                  Icons.check,
                  color: Colors.deepPurpleAccent.shade100,
                ),
              if (expiryDate == null && widget.initialExpiryDate == null)
                Icon(
                  Icons.error,
                  color: Colors.grey,
                ),
              SizedBox(width: 5),
              Text(
                expiryDate != null
                    ? 'Expiry date: ${DateFormat('yyyy/MM/dd').format(expiryDate!)} at ${DateFormat('hh:mm a').format(expiryDate!)}'
                    : widget.initialExpiryDate != null
                        ? 'Expiry date: ${DateFormat('yyyy/MM/dd').format(widget.initialExpiryDate!)} at ${DateFormat('hh:mm a').format(widget.initialExpiryDate!)}'
                        : 'Expiry date: Not set',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  late LoggedInState loggedInState;
  DateTime? expiryDatePeople;
  DateTime? expiryDatePlayers;
  DateTime? expiryDateVendors;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    loggedInState = Provider.of<LoggedInState>(context);
    await getExpiryDates();
  }

  Future<void> getExpiryDates() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allAdmins')
        .collection('admins')
        .doc(loggedInState.currentUserUid!)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List certifications = data['certifications'] as List? ?? [];
      for (var cert in certifications) {
        if (cert['certification_name'] == 'People') {
          setState(() {
            expiryDatePeople = cert['expiredTime']?.toDate();
          });
        } else if (cert['certification_name'] == 'Players') {
          setState(() {
            expiryDatePlayers = cert['expiredTime']?.toDate();
          });
        } else if (cert['certification_name'] == 'Vendors') {
          setState(() {
            expiryDateVendors = cert['expiredTime']?.toDate();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade100,
        title: const Text('Set expiry date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ReminderLine(
              text: "People",
              setExpiryDateForCertificate: (uid, date) =>
                  setExpiryDate(uid, "People", date),
              initialExpiryDate: expiryDatePeople, // Pass initial expiry date
            ),
            ReminderLine(
              text: "Players",
              setExpiryDateForCertificate: (uid, date) =>
                  setExpiryDate(uid, "Players", date),
              initialExpiryDate: expiryDatePlayers, // Pass initial expiry date
            ),
            ReminderLine(
              text: "Vendors",
              setExpiryDateForCertificate: (uid, date) =>
                  setExpiryDate(uid, "Vendors", date),
              initialExpiryDate: expiryDateVendors, // Pass initial expiry date
            ),
          ],
        ),
      ),
    );
  }
}

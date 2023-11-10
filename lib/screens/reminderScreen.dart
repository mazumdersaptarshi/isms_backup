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

  ReminderLine({
    Key? key,
    required this.text,
    required this.setExpiryDateForCertificate,
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
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
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
                        title: const Text("Select Date"),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        content: SizedBox(
                          height: 200,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: selectedDate,
                            minimumDate: DateTime(2023),
                            maximumDate: DateTime(2050),
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
                                    title: const Text("Select Time"),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 20),
                                    content: SizedBox(
                                      height: 200,
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
                                        child: const Row(
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
                            child: const Row(
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
                child: const Row(
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
          const SizedBox(height: 5),
          Row(
            children: [
              if (expiryDate != null)
                const Icon(
                  Icons.check,
                  color: Colors.grey,
                ),
              if (expiryDate == null)
                const Icon(
                  Icons.error,
                  color: Colors.grey,
                ),
              const SizedBox(width: 5),
              Text(
                expiryDate != null
                    ? 'Expiry date: ${DateFormat('yyyy/MM/dd').format(expiryDate!)} at ${DateFormat('hh:mm a').format(expiryDate!)}'
                    : 'Expiry date: Not set',
                style: const TextStyle(fontSize: 12, color: Colors.black87),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loggedInState = Provider.of<LoggedInState>(context);
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
            ),
            ReminderLine(
              text: "Players",
              setExpiryDateForCertificate: (uid, date) =>
                  setExpiryDate(uid, "Players", date),
            ),
            ReminderLine(
              text: "Vendors",
              setExpiryDateForCertificate: (uid, date) =>
                  setExpiryDate(uid, "Vendors", date),
            ),
          ],
        ),
      ),
    );
  }
}

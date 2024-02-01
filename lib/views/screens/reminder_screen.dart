// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'package:isms/userManagement/logged_in_state.dart';
// import 'package:isms/utilityFunctions/platform_check.dart';
import 'package:provider/provider.dart';

import '../../controllers/user_management/logged_in_state.dart';
import '../../utilities/platform_check.dart';

// import '../controllers/userManagement/logged_in_state.dart';

Future<void> setExpiryDate(
  String uid,
  String certificateName,
  DateTime? expiryDate,
) async {
  DocumentReference adminDocRef =
      FirebaseFirestore.instance.collection('adminconsole').doc('allAdmins').collection('admins').doc(uid);

  await adminDocRef.get().then((doc) async {
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List certifications = data['certifications'] as List? ?? [];
      int existingIndex = certifications.indexWhere((cert) => cert['certification_name'] == certificateName);

      Map<String, dynamic> certificateDetails = {
        'certification_name': certificateName,
        'expiredTime': expiryDate != null ? Timestamp.fromDate(expiryDate) : null,
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
            'expiredTime': expiryDate != null ? Timestamp.fromDate(expiryDate) : null,
            'reminderSent': false,
          },
        ],
      });
    }
  });
}

Future<void> checkAndCreateUserDocument(
  String uid,
  String currentUserEmail,
  String currentUserName,
) async {
  DocumentReference adminDocRef =
      FirebaseFirestore.instance.collection('adminconsole').doc('allAdmins').collection('admins').doc(uid);

  bool docExists = await adminDocRef.get().then((doc) => doc.exists);

  if (!docExists) {
    await adminDocRef.set({
      'email': currentUserEmail,
      'name': currentUserName,
      'certifications': [],
    });
  }
}

class ReminderLine extends StatefulWidget {
  final String text;
  final Function(String, DateTime?) setExpiryDateForCertificate;
  final DateTime? initialExpiryDate; // Added parameter

  const ReminderLine({
    Key? key,
    required this.text,
    required this.setExpiryDateForCertificate,
    this.initialExpiryDate, // Updated constructor
  }) : super(key: key);

  @override
  State<ReminderLine> createState() => _ReminderLineState();
}

class _ReminderLineState extends State<ReminderLine> {
  late DateTime selectedDate;
  DateTime? expiryDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    expiryDate = widget.initialExpiryDate;
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width) *
              0.8,
        ),
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                                      title: const Text("Select Time"),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                      content: SizedBox(
                                        height: 300,
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.time,
                                          initialDateTime: selectedDate,
                                          use24hFormat: true,
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
                                            Navigator.of(context).pop(selectedDate);
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
                      String? currentUserUid = loggedInState.currentUserUid;
                      if (currentUserUid != null) {
                        widget.setExpiryDateForCertificate(currentUserUid, pickedDate);
                        setState(() {
                          expiryDate = pickedDate;
                        });
                      } else {}
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
                        style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                if (widget.initialExpiryDate != null && DateTime.now().isAfter(widget.initialExpiryDate!))
                  Row(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Certification expired on',
                            style: TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                          Text(
                            '${DateFormat('yyyy/MM/dd').format(widget.initialExpiryDate!)} at ${DateFormat('HH:mm').format(widget.initialExpiryDate!)}',
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (expiryDate != null && !DateTime.now().isAfter(widget.initialExpiryDate!))
                  Icon(
                    Icons.check,
                    color: Colors.deepPurpleAccent.shade100,
                  ),
                if (expiryDate == null &&
                    widget.initialExpiryDate != null &&
                    !DateTime.now().isAfter(widget.initialExpiryDate!))
                  Icon(
                    Icons.check,
                    color: Colors.deepPurpleAccent.shade100,
                  ),
                if (expiryDate == null && widget.initialExpiryDate == null)
                  const Icon(
                    Icons.error,
                    color: Colors.grey,
                  ),
                const SizedBox(width: 5),
                if (!(widget.initialExpiryDate != null && DateTime.now().isAfter(widget.initialExpiryDate!)))
                  Text(
                    expiryDate != null
                        ? 'Expiry date: ${DateFormat('yyyy/MM/dd').format(expiryDate!)} at ${DateFormat('HH:mm').format(expiryDate!)}'
                        : widget.initialExpiryDate != null
                            ? 'Expiry date: ${DateFormat('yyyy/MM/dd').format(widget.initialExpiryDate!)} at ${DateFormat('HH:mm').format(widget.initialExpiryDate!)}'
                            : 'Expiry date: Not set',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
              ],
            ),
          ],
        ),
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
  String? userRole;
  DateTime? expiryDatePeople;
  DateTime? expiryDatePlayers;
  DateTime? expiryDateVendors;
  List<dynamic> allReminders = [];
  bool _areDatesFetched = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getExpiryDates(String uid) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allAdmins')
        .collection('admins')
        .doc(uid)
        .get();
    print('udhh');
    if (doc.exists && mounted) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('certifications')) {
        List certifications = data['certifications'] as List? ?? [];

        for (var cert in certifications) {
          if (cert is Map<String, dynamic>) {
            DateTime? expiryTime = cert['expiredTime']?.toDate();
            String? certName = cert['certification_name'] as String?;

            if (certName != null) {
              switch (certName) {
                case 'People':
                  setState(() {
                    expiryDatePeople = expiryTime;
                  });
                  break;
                case 'Players':
                  setState(() {
                    expiryDatePlayers = expiryTime;
                  });
                  break;
                case 'Vendors':
                  setState(() {
                    expiryDateVendors = expiryTime;
                  });
                  break;
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = Provider.of<LoggedInState>(context, listen: false);

    print(loggedInState.currentUserUid!);
    getExpiryDates(loggedInState.currentUserUid!);

    return Scaffold(
        // appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(
                children: [
                  ReminderLine(
                    text: "People",
                    setExpiryDateForCertificate: (uid, date) => setExpiryDate(uid, "People", date),
                    initialExpiryDate: expiryDatePeople, // Pass initial expiry date
                  ),
                  ReminderLine(
                    text: "Vendors",
                    setExpiryDateForCertificate: (uid, date) => setExpiryDate(uid, "Vendors", date),
                    initialExpiryDate: expiryDateVendors, // Pass initial expiry date
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context));
  }
}

// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

// Utility function to set the expiry date for a certification
Future<void> setExpiryDate(
  String uid,
  String certificateName,
  DateTime expiryDate,
) async {
  DocumentReference adminDocRef = FirebaseFirestore.instance
      .collection('adminconsole')
      .doc('allAdmins')
      .collection('admins')
      .doc(uid);

  await adminDocRef.get().then((doc) async {
    if (doc.exists) {
      // Existing admin document logic
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List certifications = data['certifications'] as List? ?? [];
      int existingIndex = certifications
          .indexWhere((cert) => cert['certification_name'] == certificateName);

      Map<String, dynamic> certificateDetails = {
        'certification_name': certificateName,
        'expiredTime': Timestamp.fromDate(expiryDate),
        'reminderSent': false,
      };

      if (existingIndex != -1) {
        certifications[existingIndex] = certificateDetails;
      } else {
        certifications.add(certificateDetails);
      }

      await adminDocRef.update({'certifications': certifications});
    } else {
      // If the document does not exist, set the initial admin document
      await adminDocRef.set({
        'certifications': [
          {
            'certification_name': certificateName,
            'expiredTime': Timestamp.fromDate(expiryDate),
            'reminderSent': false,
          },
        ],
      });
    }
  });
}

class ReminderLine extends StatelessWidget {
  final String text;
  final Function(String, DateTime) setExpiryDateForCertificate;

  const ReminderLine(
      {super.key,
      required this.text,
      required this.setExpiryDateForCertificate});

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                 if (!context.mounted) return;
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  DateTime expiryDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute);

                  // Call the passed setExpiryDate function
                  setExpiryDateForCertificate(
                    loggedInState.currentUserUid!, // Assuming this is the UID
                    expiryDate,
                  );
                }
              }
            },
            child: const Text("Set Expiry Date"),
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
      appBar: AppBar(title: const Text('Reminder Screen')),
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

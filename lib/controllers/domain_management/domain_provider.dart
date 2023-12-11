import 'package:cloud_firestore/cloud_firestore.dart';

class DomainProvider {
  Future<String> getUserDomain(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('domains')
        .where("users", arrayContains: uid)
        .get();
    for (var documentSnapshot in querySnapshot.docs) {
      if (documentSnapshot.exists) {
        return (documentSnapshot.id);
      }
    }
    return "";
  }
}

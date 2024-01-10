import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isms/services/firebase/config/config.dart';
import 'package:logging/logging.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Logger _logger = Logger('FirebaseService');
  static Map<String, dynamic> _userData = {};

  static Future<Map<String, dynamic>> getUserDataFromFirestore(
      String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('${FirebaseConfig.usersCollectionName}')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        _userData = userDoc.data() as Map<String, dynamic>;
        _logger.info('User data fetched for user ${uid}');
        return _userData;
      } else {
        _logger.severe('No user found with the uid!');
        return {};
      }
    } catch (e) {
      _logger.severe('Error fetching data from Firestore: $e');
      return {};
    }
  }
}

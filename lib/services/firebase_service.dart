
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> setValue(String collection, String document, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(document).set(data);
      print('Data set successfully');
    } catch (e) {
      print('Error setting data: $e');
      rethrow;
    }
  }

  static Future<void> updateValue(String collection, String document, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(document).update(data);
      print('Data updated successfully');
    } catch (e) {
      print('Error updating data: $e');
      rethrow;
    }
  }
}
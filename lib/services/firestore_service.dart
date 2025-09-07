import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // Add Safe Walk session
  Future<void> addSession(Map<String, dynamic> data) async {
    await _db.collection('sessions').add(data);
  }

  // Add SOS event
  Future<void> addSOSEvent(Map<String, dynamic> data) async {
    await _db.collection('sos_events').add(data);
  }

  // Add evidence metadata
  Future<void> addEvidence(Map<String, dynamic> data) async {
    await _db.collection('evidence').add(data);
  }
}
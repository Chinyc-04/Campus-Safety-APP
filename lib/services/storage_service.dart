import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadEvidence(String filePath, String fileName) async {
    final ref = _storage.ref().child('evidence/$fileName');
    await ref.putFile(File(filePath));
    return await ref.getDownloadURL();
  }
}
import 'storage_service.dart';
import 'firestore_service.dart';

class EvidenceService {
  final _storage = StorageService();
  final _firestore = FirestoreService();

  Future<void> uploadEvidence(String filePath, String fileName, Map<String, dynamic> metadata) async {
    final url = await _storage.uploadEvidence(filePath, fileName);
    metadata['fileUrl'] = url;
    await _firestore.addEvidence(metadata);
  }
}
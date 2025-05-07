import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'dart:developer' as developer;

class DetectionService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadDetectionImage(
      File imageFile, List<dynamic> detections) async {
    try {
      final fileName =
          'detection_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final ref = _storage.ref().child('detections/$fileName');

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      // TODO: Sauvegarder les détections dans Firestore si nécessaire

      return downloadUrl;
    } catch (e) {
      developer.log('Erreur lors de l\'upload de l\'image', error: e);
      rethrow;
    }
  }

  Future<void> deleteDetection(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      developer.log('Erreur lors de la suppression de l\'image', error: e);
      rethrow;
    }
  }
}

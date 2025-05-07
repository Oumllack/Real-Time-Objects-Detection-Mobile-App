import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadDetectionImage(
      File imageFile, List<Map<String, dynamic>> detections) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final ref = _storage.ref().child('detections/$fileName');

      // Upload de l'image
      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();

      // Upload des métadonnées de détection
      final metadataRef = _storage.ref().child('detections/$fileName.json');
      final metadata = {
        'timestamp': DateTime.now().toIso8601String(),
        'detections': detections,
      };
      await metadataRef.putString(metadata.toString());

      return imageUrl;
    } catch (e) {
      print('Erreur lors de l\'upload: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDetectionHistory() async {
    try {
      final ListResult result =
          await _storage.ref().child('detections').listAll();
      final List<Map<String, dynamic>> history = [];

      for (var item in result.items) {
        if (item.name.endsWith('.json')) {
          final data = await item.getData();
          if (data != null) {
            history.add({
              'metadata': String.fromCharCodes(data),
              'timestamp': item.name.split('.').first,
            });
          }
        }
      }

      return history;
    } catch (e) {
      print('Erreur lors de la récupération de l\'historique: $e');
      return [];
    }
  }
}

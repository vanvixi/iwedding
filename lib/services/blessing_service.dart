import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding/models/blessing.dart';

class BlessingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'blessings';

  Future<void> addBlessing({
    required String name,
    required String message,
  }) async {
    try {
      await _firestore.collection(_collection).add({
        'name': name.trim(),
        'message': message.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Blessing>> getBlessings({int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => Blessing.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error loading blessings: $e');
      return [];
    }
  }

  /// Stream để lắng nghe real-time updates của các lời chúc
  Stream<List<Blessing>> getBlessingsStream({int limit = 20}) {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Blessing.fromFirestore(doc))
            .toList());
  }

  /// Xóa một lời chúc (cho admin)
  Future<void> deleteBlessing(String blessingId) async {
    try {
      await _firestore.collection(_collection).doc(blessingId).delete();
    } catch (e) {
      print('Error deleting blessing: $e');
      rethrow;
    }
  }
}

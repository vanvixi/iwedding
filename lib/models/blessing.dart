import 'package:cloud_firestore/cloud_firestore.dart';

/// Model đại diện cho một lời chúc mừng
class Blessing {
  final String id;
  final String name;
  final String message;
  final DateTime timestamp;

  Blessing({
    required this.id,
    required this.name,
    required this.message,
    required this.timestamp,
  });

  /// Tạo Blessing từ Firestore document
  factory Blessing.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Blessing(
      id: doc.id,
      name: data['name'] ?? 'Anonymous',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Chuyển đổi Blessing thành Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

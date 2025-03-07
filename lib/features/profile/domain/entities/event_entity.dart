import 'package:cloud_firestore/cloud_firestore.dart';

class EventEntity {
  final String id;
  final String name;
  final DateTime date;
  final String cover;

  EventEntity({
    required this.id,
    required this.name,
    required this.date,
    required this.cover,
  });

  factory EventEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventEntity(
      id: doc.id,
      name: data['name'] ?? 'Unknown Event',
      date: (data['date'] as Timestamp).toDate(),
      cover: data['cover'] ?? 'assets/images/default_event.png',
    );
  }
}

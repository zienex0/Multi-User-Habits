import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final String frequency;
  final String goal;
  final String measurement;
  final bool isActive;
  final Timestamp creationDate;

  Habit(
      {required this.id,
      required this.name,
      required this.description,
      required this.creatorId,
      required this.frequency,
      required this.goal,
      required this.measurement,
      required this.isActive,
      required this.creationDate});

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
    if (data.isEmpty) {
      throw Exception('Document data is null');
    }

    return Habit(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        creatorId: data['creatorId'] ?? '',
        frequency: data['frequency'] ?? '',
        goal: data['goal'] ?? '',
        isActive: data['isActive'] ?? false,
        measurement: data['measurement'] ?? '',
        creationDate: data['creationDate']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creatorId': creatorId,
      'frequency': frequency,
      'goal': goal,
      'isActive': isActive,
      'measurement': measurement,
    };
  }
}

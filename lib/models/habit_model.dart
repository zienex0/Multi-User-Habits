import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String? id;
  final String name;
  final String description;
  final String creatorId;
  final double goal;
  final String measurement;
  final bool isActive;
  final bool isPrivate;
  final DateTime creationDate;

  // FREQUENCY IS NOT IMPORTANT, ALL HABITS WILL BE DAILY

  Habit(
      {this.id,
      required this.name,
      required this.description,
      required this.creatorId,
      required this.goal,
      required this.measurement,
      required this.isActive,
      required this.isPrivate,
      required this.creationDate});

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      throw Exception("Habit document doesnt exist or is null");
    }

    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

    return Habit(
        id: doc.id,
        name: data['name'],
        description: data['description'] ?? '',
        creatorId: data['creatorId'],
        goal: (data['goal'] is int)
            ? (data['goal'] as int).toDouble()
            : data['goal'] as double,
        isActive: data['isActive'] ?? false,
        isPrivate: data['isPrivate'],
        measurement: data['measurement'] ?? '',
        creationDate: (data['creationDate'] as Timestamp).toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creatorId': creatorId,
      'goal': goal,
      'isActive': isActive,
      'isPrivate': isPrivate,
      'measurement': measurement,
      'creationDate': Timestamp.fromDate(creationDate),
    };
  }
}

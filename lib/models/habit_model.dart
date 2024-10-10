import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  String title;
  String description;
  final String creatorUid;
  double dailyGoal;
  String joinCode;
  String measurement;
  DateTime creationDate;
  List<String> userUids;

  Habit(
      {required this.id,
      required this.title,
      required this.description,
      required this.creatorUid,
      required this.dailyGoal,
      required this.joinCode,
      required this.measurement,
      required this.creationDate,
      required this.userUids});

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      throw Exception("Habit document doesnt exist or is null");
    }

    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

    return Habit(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      creatorUid: data['creatorUid'],
      dailyGoal: (data['dailyGoal'] is int)
          ? (data['dailyGoal'] as int).toDouble()
          : data['dailyGoal'] as double,
      joinCode: data['joinCode'],
      measurement: data['measurement'],
      creationDate: (data['creationDate'] as Timestamp).toDate(),
      userUids: List<String>.from(data['userUids'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'creatorUid': creatorUid,
      'dailyGoal': dailyGoal,
      'joinCode': joinCode,
      'measurement': measurement,
      'creationDate': Timestamp.fromDate(creationDate),
      'userUids': userUids,
    };
  }
}

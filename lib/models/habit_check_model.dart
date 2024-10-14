import 'package:cloud_firestore/cloud_firestore.dart';

class HabitCheck {
  String id;
  String habitId;
  double quantity;
  String userNote;
  String userUid;

  HabitCheck(
      {required this.id,
      required this.habitId,
      required this.quantity,
      required this.userNote,
      required this.userUid});

  factory HabitCheck.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      throw "HabitCheck document not found, failed to create a habit check model";
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return HabitCheck(
        id: doc.id,
        habitId: data['habitId'],
        quantity: (data['quantity'] is int)
            ? (data['quantity'] as int).toDouble()
            : data['quantity'] as double,
        userNote: data['userNote'],
        userUid: data['userUid']);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/habit_check_model.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class DbHabitChecks {
  CollectionReference habitChecksCollection =
      FirebaseFirestore.instance.collection("habitChecks");
  final DbHabits _dbHabits = DbHabits();

  Future<List<HabitCheck>> getHabitChecks(String habitId) async {
    try {
      QuerySnapshot querySnapshot = await habitChecksCollection
          .where('habitId', isEqualTo: habitId)
          .get();
      List<HabitCheck> habitChecks = querySnapshot.docs
          .map((doc) => HabitCheck.fromFirestore(doc))
          .toList();
      return habitChecks;
    } catch (e) {
      print("Error while getting habit checks from habit with id $habitId: $e");
      return [];
    }
  }

  Stream<List<HabitCheck>> getHabitChecksStream(String habitId) {
    return habitChecksCollection
        .where('habitId', isEqualTo: habitId)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs
          .map((doc) => HabitCheck.fromFirestore(doc))
          .toList();
    });
  }

  Stream<double> getHabitChecksCompletionSum(String habitId) {
    return getHabitChecksStream(habitId).map((habitChecks) {
      double completionSum = 0;
      for (HabitCheck habitCheck in habitChecks) {
        completionSum += habitCheck.quantity;
      }
      return completionSum;
    });
  }

  // TODO Get only one specified user habit checks completion sum function

  Future<HabitCheck?> addHabitCheck({
    required String habitId,
    required double quantity,
    required String userNote,
    required String userUid,
  }) async {
    Habit? habit = await _dbHabits.getHabit(habitId);
    if (habit == null) {
      print(
          "Failed to add habit check because habit with habit id of $habitId was not found");
      return null;
    }

    try {
      Timestamp timestampCompletionDateNow = Timestamp.now();
      DocumentReference doc = await habitChecksCollection.add({
        'habitId': habitId,
        'quantity': quantity,
        'userNote': userNote,
        'userUid': userUid,
        'completionDate': timestampCompletionDateNow,
      });
      return HabitCheck(
          id: doc.id,
          habitId: habitId,
          quantity: quantity,
          userNote: userNote,
          userUid: userUid,
          completionDate: timestampCompletionDateNow.toDate());
    } catch (e) {
      print("Error while adding a habit check to a habit with id $habitId. $e");
      return null;
    }
  }
}

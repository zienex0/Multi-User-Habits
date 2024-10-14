import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/habit_check_model.dart';

class DbHabitChecks {
  CollectionReference habitChecksCollection =
      FirebaseFirestore.instance.collection("habitChecks");

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

  Future<double> getHabitChecksCompletionSum(String habitId) async {
    List<HabitCheck> habitChecks = await getHabitChecks(habitId);
    if (habitId.isEmpty) {
      return 0;
    }

    double completionSum = 0;
    for (HabitCheck habitCheck in habitChecks) {
      completionSum += habitCheck.quantity;
    }

    return completionSum;
  }
}

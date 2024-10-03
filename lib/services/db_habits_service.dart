import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class DbHabits {
  CollectionReference habitCollection =
      FirebaseFirestore.instance.collection('habits');

  Future<List<Habit>> getAllHabits() async {
    QuerySnapshot snapshot = await habitCollection.get();
    List<Habit> habits =
        snapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList();
    return habits;
  }

  Future<Habit?> getHabitData(String habitId) async {
    try {
      DocumentSnapshot habitDoc = await habitCollection.doc(habitId).get();
      if (habitDoc.exists) {
        return Habit.fromFirestore(habitDoc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching habit: $e');
      return null;
    }
  }
}

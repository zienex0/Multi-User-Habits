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

  Future<void> addHabit(Habit habit) async {
    try {
      // Create the habit without an id first
      DocumentReference docRef = await habitCollection.add(habit.toMap());

      // Once the document is added, update the habit's id with Firestore's generated id
      habit.id = docRef.id;

      // Update the document in Firestore with the id
      await docRef.update({'id': habit.id});

      print("Created a new habit with id: ${habit.id}");
    } catch (error) {
      print("Failed to add a new habit: $error");
    }
  }
}

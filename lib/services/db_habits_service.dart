import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class DbHabits {
  CollectionReference habitCollection =
      FirebaseFirestore.instance.collection('habits');

  Future<Habit?> getHabit(String habitId) async {
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

  Future<List<Habit>> getUserConnectedHabits(String userUid) async {
    try {
      QuerySnapshot querySnapshot =
          await habitCollection.where('userUids', arrayContains: userUid).get();
      List<Habit> habits =
          querySnapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList();
      return habits;
    } catch (e) {
      print("Error while getting user connected habits: $e");
      return [];
    }
  }

  Future<Habit?> addHabit(
      {required String title,
      required String description,
      required Timestamp creationDate,
      required String measurement,
      required double dailyGoal,
      required String creatorUid,
      required String joinCode,
      required List<String> userUids}) async {
    try {
      DocumentReference docRef = await habitCollection.add({
        'title': title,
        'description': description,
        'creationDate': creationDate,
        'measurement': measurement,
        'dailyGoal': dailyGoal,
        'creatorUid': creatorUid,
        'joinCode': joinCode,
        'userUids': userUids
      });

      Habit habit = Habit(
          id: docRef.id,
          title: title,
          description: description,
          creatorUid: creatorUid,
          dailyGoal: dailyGoal,
          joinCode: joinCode,
          measurement: measurement,
          creationDate: creationDate.toDate(),
          userUids: userUids);
      print("Created a new habit with id: ${docRef.id}");
      return habit;
    } catch (error) {
      print("Failed to add a new habit: $error");
      return null;
    }
  }
}

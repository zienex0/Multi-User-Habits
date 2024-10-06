import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/user_habit_model.dart';
import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/db_users_service.dart';

class DbUserHabits {
  CollectionReference userHabits =
      FirebaseFirestore.instance.collection('userHabits');

  DbUsers dbUsers = DbUsers();

  Future<List<UserHabit>> getAllRawHabitCompletions(String habitId) async {
    QuerySnapshot habitHistory =
        await userHabits.where('habitId', isEqualTo: habitId).get();

    List<UserHabit> allHabitCompletionHistory = [];
    for (var doc in habitHistory.docs) {
      allHabitCompletionHistory.add(UserHabit.fromFirestore(doc));
    }

    return allHabitCompletionHistory;
  }

  Future<List<User>> getAllUniqueUsersFromHabit(String habitId) async {
    QuerySnapshot habitHistory =
        await userHabits.where('habitId', isEqualTo: habitId).get();

    Set<String> uniqueUserIdsFromHabit = {};

    for (var doc in habitHistory.docs) {
      uniqueUserIdsFromHabit.add(doc['userId'] as String);
    }

    List<User> uniqueUsers = [];
    for (var userId in uniqueUserIdsFromHabit) {
      User? user = await dbUsers.getUserData(userId);
      if (user != null) {
        uniqueUsers.add(user);
      }
    }

    return uniqueUsers;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/models/user_habit_model.dart';
import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/db_users_service.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class DbUserHabits {
  CollectionReference userHabits =
      FirebaseFirestore.instance.collection('userHabits');

  DbUsers dbUsers = DbUsers();
  DbHabits dbHabits = DbHabits();

  Future<List<UserHabit>> getAllRawHabitCompletions(String habitId) async {
    QuerySnapshot habitHistory =
        await userHabits.where('habitId', isEqualTo: habitId).get();

    List<UserHabit> allHabitCompletionHistory = [];
    for (var doc in habitHistory.docs) {
      allHabitCompletionHistory.add(UserHabit.fromFirestore(doc));
    }

    return allHabitCompletionHistory;
  }

  Future<List<CustomUser>> getAllUniqueUsersFromHabit(String habitId) async {
    QuerySnapshot habitHistory =
        await userHabits.where('habitId', isEqualTo: habitId).get();

    Set<String> uniqueUserUidsFromHabit = {};

    for (var doc in habitHistory.docs) {
      uniqueUserUidsFromHabit.add(doc['userUid'] as String);
    }

    List<CustomUser> uniqueUsers = [];
    for (var userUid in uniqueUserUidsFromHabit) {
      CustomUser? user = await dbUsers.getUserDataByUserUid(userUid);
      if (user != null) {
        uniqueUsers.add(user);
      }
    }

    return uniqueUsers;
  }

  Future<List<Habit>> getAllUniqueHabitsFromUserUid(String userUid) async {
    QuerySnapshot userCompletions =
        await userHabits.where('userUid', isEqualTo: userUid).get();

    if (userCompletions.docs.isEmpty) {
      return [];
    }

    Set<String> uniqueHabitIds = {};
    for (var doc in userCompletions.docs) {
      uniqueHabitIds.add(doc['habitID'] as String);
    }

    List<Habit> userUniqueHabits = [];

    for (var habitId in uniqueHabitIds) {
      Habit? habit = await dbHabits.getHabitData(habitId);
      if (habit != null) {
        userUniqueHabits.add(habit);
      }
    }
    return userUniqueHabits;
  }
}

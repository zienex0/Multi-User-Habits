import 'package:flutter/material.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/services/db_user_habits_service.dart';
// import 'package:multiuser_habits/models/user_model.dart';

class HabitsProvider extends ChangeNotifier {
  final DbHabits dbHabitsCollection = DbHabits();
  final DbUserHabits dbUserHabits = DbUserHabits();

  List<Habit> _habits = [];

  List<Habit> get habits => _habits;
  // Habit? selectedHabit;
  // List<User> _habitUsers = [];

  bool _isLoadingHabits = false;
  bool get isLoadingHabits => _isLoadingHabits;

  // Future<void> fetchAllHabits() async {
  //   _isLoadingHabits = true;
  //   notifyListeners();

  //   try {
  //     _habits = await dbHabitsCollection.getAllHabits();
  //   } catch (e) {
  //     print('Error while fetching all habits in the habits provider: $e');
  //     _habits = [];
  //   }

  //   _isLoadingHabits = false;
  //   notifyListeners();
  // }

  Future<void> fetchUniqueHabitsFromUserUid(String userUid) async {
    _isLoadingHabits = true;
    notifyListeners();

    try {
      _habits = await dbUserHabits.getAllUniqueHabitsFromUserUid(userUid);
      print(_habits);
    } catch (e) {
      print(
          "Error while fetching unique habits in the habits provider from user uid: $e");
      _habits = [];
    }

    _isLoadingHabits = false;
    notifyListeners();
  }

  // Future<void> fetchHabit(String habitId) async {}
}

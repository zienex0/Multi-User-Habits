import 'package:flutter/material.dart';
import 'package:multiuser_habits/models/user_habit_model.dart';
import 'package:multiuser_habits/services/db_user_habits_service.dart';
import 'package:multiuser_habits/models/user_model.dart';

class UserHabitsProvider extends ChangeNotifier {
  // THIS IS ONLY FOR ONE CERTAIN HABIT, DONT USE IT FOR ALL USER HABITS
  final DbUserHabits dbUserHabits = DbUserHabits();

  final String habitId;

  UserHabitsProvider(this.habitId);

  List<UserHabit> _habitCompletions = [];
  List<CustomUser> _habitUsers = [];
  bool _isLoadingHabitCompletions = false;
  bool _isLoadingHabitUsers = false;

  List<UserHabit> get habitCompletions => _habitCompletions;
  List<CustomUser> get habitUsers => _habitUsers;
  bool get isLoadingHabitCompletions => _isLoadingHabitCompletions;
  bool get isLoadingHabitUsers => _isLoadingHabitUsers;

  Future<void> fetchHabitCompletionsFromHabit() async {
    _isLoadingHabitCompletions = true;
    notifyListeners();
    try {
      _habitCompletions = await dbUserHabits.getAllRawHabitCompletions(habitId);
    } catch (e) {
      print("Error while fetching habit completions: $e");
      _habitCompletions = [];
    }
    _isLoadingHabitCompletions = false;
    notifyListeners();
  }

  Future<void> fetchUniqueHabitUsers() async {
    _isLoadingHabitUsers = true;
    notifyListeners();
    try {
      _habitUsers = await dbUserHabits.getAllUniqueUsersFromHabit(habitId);
    } catch (e) {
      print("Error while fetching unique habit users from habit: $e");
      _habitUsers = [];
    }
    _isLoadingHabitUsers = false;
    notifyListeners();
  }
}

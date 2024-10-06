import 'package:flutter/material.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:multiuser_habits/models/habit_model.dart';
// import 'package:multiuser_habits/models/user_model.dart';

class HabitsProvider extends ChangeNotifier {
  final DbHabits dbHabitsCollection = DbHabits();

  List<Habit> _habits = [];

  List<Habit> get habits => _habits;
  // Habit? selectedHabit;
  // List<User> _habitUsers = [];

  bool _isLoadingFetchingAllHabits = false;
  bool get isLoadingFetchingAllHabits => _isLoadingFetchingAllHabits;

  Future<void> fetchAllHabits() async {
    _isLoadingFetchingAllHabits = true;
    notifyListeners();

    try {
      _habits = await dbHabitsCollection.getAllHabits();
    } catch (e) {
      print('Error while fetching all habits in DbHabitsProvider: $e');
      _habits = [];
    }

    _isLoadingFetchingAllHabits = false;
    notifyListeners();
  }

  // Future<void> fetchHabit(String habitId) async {}
}

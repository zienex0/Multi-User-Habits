import 'package:flutter/material.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class HabitsProvider extends ChangeNotifier {
  final DbHabits dbHabitsCollection = DbHabits();

  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  bool _isLoadingHabits = false;
  bool get isLoadingHabits => _isLoadingHabits;

  Future<void> fetchHabitsConnectedToUser({required String userUid}) async {
    _isLoadingHabits = true;
    notifyListeners();

    try {
      _habits = await dbHabitsCollection.getUserConnectedHabits(userUid);
    } catch (e) {
      print(
          "Error while fetching unique habits in the habits provider from user uid: $e");
      _habits = [];
    }

    _isLoadingHabits = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class HabitDetailsPage extends StatelessWidget {
  const HabitDetailsPage({required this.habit, super.key});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Text('hello'))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({required this.habit, super.key});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          habit.name,
          style: const TextStyle(fontSize: 32),
        ),
        subtitle: Text(
          'Goal: ${habit.goal} ${habit.measurement} ${habit.frequency}',
          style: const TextStyle(fontSize: 20),
        ),
        children:
            // SAMPLE USER HABIT COMPLETIONS
            const [
          ListTile(
            title: Text('User1: 60 minutes'),
            leading: CircleAvatar(
              child: Text('HI'),
            ),
          ),
          ListTile(
            title: Text('User2: 13 minutes'),
            leading: CircleAvatar(
              child: Text('HI'),
            ),
          ),
        ],
      ),
    );
  }
}

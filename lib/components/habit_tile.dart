import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/complete_habit_button.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({required this.habit, super.key});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Card(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)),
          height: 100,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // habit information on the left
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name.isNotEmpty ? habit.name : 'No habit name',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Goal: ${habit.goal} ${habit.measurement}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
                // complete habit button on the right
                const CompleteHabitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

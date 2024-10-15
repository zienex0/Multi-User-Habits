import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/complete_habit_button.dart';
import 'package:multiuser_habits/components/habit_check_sum_rectangle.dart';
import 'package:multiuser_habits/components/habit_users_avatars.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({required this.habit, this.preview = false, super.key});

  final Habit habit;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(26, 26, 26, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // HABIT SCORE SUM
              HabitCheckSumRectangle(
                habitId: habit.id,
                habitMeasurement: habit.measurement,
                preview: preview,
              ),

              const SizedBox(
                width: 20,
              ),

              // HABIT NAME & USERS CONNECTED
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      habit.title.isNotEmpty ? habit.title : 'No habit name',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    HabitUsersAvatars(
                      habitId: habit.id,
                      preview: preview,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              // COMPLETE HABIT BUTTON ON THE RIGHT
              const CompleteHabitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

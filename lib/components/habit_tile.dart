import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/complete_habit_button.dart';
import 'package:multiuser_habits/components/habit_check_sum_rectangle.dart';
import 'package:multiuser_habits/components/habit_users_avatars.dart';
import 'package:multiuser_habits/components/preview_users_avatars.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({required this.habit, this.preview = false, super.key});

  final Habit habit;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // MAIN CARD
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // HABIT NAME & GOAL ON THE LEFT & USERS CONNECTED
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.title.isNotEmpty
                                    ? habit.title
                                    : 'No habit name',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Goal: ${habit.dailyGoal} ${habit.measurement}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w200),
                              ),
                              preview
                                  ? const PreviewUsersAvatars()
                                  : HabitUsersAvatars(habitId: habit.id)
                            ],
                          ),
                        ),
                        // complete habit button on the right
                        const CompleteHabitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            HabitCheckSumRectangle(habitId: habit.id),
          ],
        ),
      ),
    );
  }
}

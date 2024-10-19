import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/complete_habit_button.dart';
import 'package:multiuser_habits/components/habit_check_sum_rectangle.dart';
import 'package:multiuser_habits/components/habit_users_avatars.dart';
import 'package:multiuser_habits/constants.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/pages/habit_details_page.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({required this.habit, this.preview = false, super.key});

  final Habit habit;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: preview
          ? () {}
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetailsPage(habit: habit),
                ),
              );
            },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kDarkPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // HABIT SCORE SUM
                SizedBox(
                  width: 120,
                  child: HabitCheckSumRectangle(
                    habitId: habit.id,
                    habitMeasurement: habit.measurement,
                    preview: preview,
                    colorId: habit.colorId,
                  ),
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
                            fontSize: 26, fontWeight: FontWeight.bold),
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
                CompleteHabitButton(
                  habit: habit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

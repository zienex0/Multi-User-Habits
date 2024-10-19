import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/habit_check_sum_rectangle.dart';
import 'package:multiuser_habits/components/habit_users_avatars.dart';
import 'package:multiuser_habits/constants.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class HabitDetailsPage extends StatelessWidget {
  const HabitDetailsPage({required this.habit, super.key});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // * HABIT TITLE AND COMPLETION BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    habit.title,
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // * MY HABIT SUMMARY (MY SCORE AND CURRENT DAILY STREAK)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                ),
                child: CurrentUserHabitSummary(habit: habit),
              ),

              const SizedBox(
                height: 20,
              ),

              // * USERS CONTRIBUTING AND COMPLETION SUM
              UsersContributingAndAllScore(habit: habit),

              const SizedBox(
                height: 50,
              ),
              // * LIST OF LATEST COMPLETIONS
              Container(
                decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18,
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'users_username',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      " at 12:21 today",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${Random().nextInt(9) + 1} minutes',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: kHabitTileColorMap[habit.colorId]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UsersContributingAndAllScore extends StatelessWidget {
  const UsersContributingAndAllScore({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "X contributing",
                    // TODO MAKE THE X THE ACTUAL USER COUNT
                    maxLines: 2,
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: HabitUsersAvatars(
                      habitId: habit.id,
                      preview: false,
                      includeMyAvatar: true,
                      maxUsersToShow: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: HabitCheckSumRectangle(
                    habitId: habit.id,
                    habitMeasurement: habit.measurement,
                    colorId: habit.colorId,
                    preview: false)
                .copyWithBackgroundColor(Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class CurrentUserHabitSummary extends StatelessWidget {
  const CurrentUserHabitSummary({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
            Text(
              FirebaseAuth.instance.currentUser!.displayName != null
                  ? FirebaseAuth.instance.currentUser!.displayName!
                  : "Anynomous",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                    child: Text(
                      "streak \nplaceholder",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // * MY HABIT SCORE SUM
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: kHabitTileColorMap[habit.colorId]!)),
                    child: HabitCheckSumRectangle(
                            habitId: habit.id,
                            habitMeasurement: habit.measurement,
                            colorId: habit.colorId,
                            preview: false)
                        .copyWithBackgroundColor(Colors.transparent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

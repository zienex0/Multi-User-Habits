import 'package:flutter/material.dart';
import 'package:multiuser_habits/services/db_habit_checks_service.dart';

class HabitCheckSumRectangle extends StatelessWidget {
  HabitCheckSumRectangle({required this.habitId, super.key});

  final DbHabitChecks dbHabitChecks = DbHabitChecks();
  final String habitId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dbHabitChecks.getHabitChecksCompletionSum(habitId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(
                'Something went wrong while future buildling the habit checks completion sum');
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return Container(
            height: 100,
            width: 100,
            color: Colors.red,
            child: Center(
              child: Text("${snapshot.data}"),
            ),
          );
        });
  }
}

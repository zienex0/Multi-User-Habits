import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/complete_habit_dialog.dart';
import 'package:multiuser_habits/models/habit_check_model.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class CompleteHabitButton extends StatefulWidget {
  const CompleteHabitButton({required this.habit, super.key});

  final Habit habit;

  @override
  State<CompleteHabitButton> createState() => _CompleteHabitButtonState();
}

class _CompleteHabitButtonState extends State<CompleteHabitButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(46, 46, 46, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
          color: Colors.transparent,
          onPressed: () async {
            HabitCheck? completedQuantity = await showCompleteHabitDialog(
              context: context,
              habitId: widget.habit.id,
              habitMeasurement: widget.habit.measurement,
            );
            print(completedQuantity);
          },
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/models/user_habit_model.dart';
import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/db_user_habits_service.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({required this.habit, super.key});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final DbUserHabits dbUserHabits = DbUserHabits();
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
        children: [
          FutureBuilder<List<UserHabit>>(
            future: dbUserHabits.getAllRawHabitCompletions(habit.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error loading users');
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No users connected to this habit');
              }

              List<UserHabit> habitCompletionHistory = snapshot.data!;
              return Column(
                children: habitCompletionHistory.map((completion) {
                  // RIGHT NOW FUNCTIONS WILL NOT WORK BECAUSE THEY ARE ASYNCHRONOUS
                  completion.fetchAndAssignUser(completion.userId);
                  completion.fetchAndAssignHabit(completion.habitId);
                  print(completion.user);
                  if (completion.user == null) {
                    return const ListTile(
                      title: Text("Unknown"),
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    );
                  }

                  return ListTile(
                    title: Text(completion.user!.displayName),
                    leading: CircleAvatar(
                      child: Text(completion.user!.displayName[0]),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

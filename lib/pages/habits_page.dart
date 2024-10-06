import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/habit_tile.dart';
import 'package:multiuser_habits/pages/add_habit_page.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:multiuser_habits/models/habit_model.dart';

class HabitsPage extends StatelessWidget {
  final DbHabits habitsCollection = DbHabits();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHabitPage(),
            ),
          );
        },
      ),
      body: FutureBuilder<List<Habit>>(
        future: habitsCollection.getAllHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("You don't have any habits. Try adding one");
          }

          List<Habit> habits = snapshot.data!;

          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return HabitTile(
                habit: habit,
              );
            },
          );
        },
      ),
    );
  }
}

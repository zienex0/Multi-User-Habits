import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/habit_tile.dart';
import 'package:multiuser_habits/pages/add_habit_page.dart';
import 'package:multiuser_habits/services/habits_provider.dart';
import 'package:provider/provider.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});
  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HabitsProvider>().fetchAllHabits());
  }

  @override
  Widget build(BuildContext context) {
    final habitsProvider = context.watch<HabitsProvider>();
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
      body: habitsProvider.isLoadingFetchingAllHabits
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : habitsProvider.habits.isEmpty
              ? const Center(
                  child: Text("You don't have any habits. Try adding one :)"),
                )
              : ListView.builder(
                  itemCount: habitsProvider.habits.length,
                  itemBuilder: (context, index) {
                    final habit = habitsProvider.habits[index];
                    return HabitTile(habit: habit);
                  },
                ),
    );
  }
}

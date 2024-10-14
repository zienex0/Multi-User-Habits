import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/habit_tile.dart';
import 'package:multiuser_habits/pages/add_habit_page.dart';
import 'package:multiuser_habits/pages/authentication_page.dart';
import 'package:multiuser_habits/services/habits_provider.dart';
import 'package:provider/provider.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});
  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<HabitsProvider>()
        .fetchHabitsConnectedToUser(userUid: _auth.currentUser!.uid));
  }

  @override
  Widget build(BuildContext context) {
    final habitsProvider = context.watch<HabitsProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await _auth.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const AuthenticationPage()),
                );
              }
            },
            icon: const Icon(Icons.logout)),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitPage(),
            ),
          );
        },
      ),
      body: habitsProvider.isLoadingHabits
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

import 'package:flutter/material.dart';
import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/db_user_habits_service.dart';

class HabitUsersAvatars extends StatefulWidget {
  const HabitUsersAvatars({required this.habitId, super.key});

  final String habitId;

  @override
  State<HabitUsersAvatars> createState() => _HabitUsersAvatarsState();
}

class _HabitUsersAvatarsState extends State<HabitUsersAvatars> {
  final DbUserHabits dbUserHabits = DbUserHabits();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dbUserHabits.getAllUniqueUsersFromHabit(widget.habitId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            print("Error while getting habit unique users for avatars");
          }

          List<CustomUser> uniqueHabitUsers = snapshot.data ?? [];
          return SizedBox(
            height: 40,
            child: Stack(
              children: [
                for (int i = 0; i < uniqueHabitUsers.length; i++)
                  Positioned(
                    left: i * 20.0,
                    child: const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),
                  )
              ],
            ),
          );
        });
  }
}

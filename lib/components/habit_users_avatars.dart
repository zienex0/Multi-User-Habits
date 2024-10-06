import 'package:flutter/material.dart';
// import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/user_habits_provider.dart';
import 'package:provider/provider.dart';

class HabitUsersAvatars extends StatelessWidget {
  const HabitUsersAvatars({required this.habitId, super.key});

  final String habitId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = UserHabitsProvider(habitId);
        Future.microtask(() => provider.fetchUniqueHabitUsers());
        return provider;
      },
      child: Consumer<UserHabitsProvider>(
        builder: (context, userHabitsProvider, child) {
          if (userHabitsProvider.isLoadingHabitUsers) {
            return const CircularProgressIndicator();
          }

          return SizedBox(
            height: 40,
            child: Stack(
              children: [
                for (int i = 0; i < userHabitsProvider.habitUsers.length; i++)
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
        },
      ),
    );
  }
}

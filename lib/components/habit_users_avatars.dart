import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/db_users_service.dart';

class HabitUsersAvatars extends StatelessWidget {
  HabitUsersAvatars(
      {required this.habitId,
      required this.preview,
      this.includeMyAvatar = false,
      this.maxUsersToShow = 3,
      super.key});

  final String habitId;
  final bool preview;
  final bool includeMyAvatar;
  final int maxUsersToShow;

  final DbUsers dbUsersCollection = DbUsers();

  @override
  Widget build(BuildContext context) {
    if (preview) {
      List<CustomUser> customUserPreviewList = List.generate(
        8,
        (index) => CustomUser(id: '', email: '', displayName: '', photoUrl: ''),
      );
      return _buildHabitUsersAvatars(customUserPreviewList, maxUsersToShow);
    }

    return FutureBuilder(
        future: dbUsersCollection.getUsersConnectedToHabit(habitId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 20, child: LinearProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error while getting habit unique users for avatars");
          }

          List<CustomUser> uniqueHabitUsers = snapshot.data ?? [];
          if (!includeMyAvatar) {
            for (CustomUser customUser in uniqueHabitUsers) {
              if (customUser.id == FirebaseAuth.instance.currentUser!.uid) {
                uniqueHabitUsers.remove(customUser);
                break;
              }
            }
          }
          return _buildHabitUsersAvatars(uniqueHabitUsers, maxUsersToShow);
        });
  }
}

_buildHabitUsersAvatars(List<CustomUser> usersList, int maxUsersToShow) {
  int extraUsers = usersList.length - maxUsersToShow;

  return Wrap(
    runSpacing: 6,
    spacing: 6,
    children: [
      for (int i = 0; i < usersList.length && i < maxUsersToShow; i++)
        if (i < maxUsersToShow)
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
      if (extraUsers > 0)
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 18,
          child: Text(
            "+$maxUsersToShow",
            style: const TextStyle(color: Colors.white),
          ),
        ),
    ],
  );
}

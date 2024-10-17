import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/db_users_service.dart';

class HabitUsersAvatars extends StatelessWidget {
  HabitUsersAvatars({required this.habitId, required this.preview, super.key});

  final String habitId;
  final bool preview;

  final DbUsers dbUsersCollection = DbUsers();

  @override
  Widget build(BuildContext context) {
    if (preview) {
      List<CustomUser> customUserPreviewList = [
        CustomUser(id: '', email: '', displayName: '', photoUrl: ''),
        CustomUser(id: '', email: '', displayName: '', photoUrl: ''),
        CustomUser(id: '', email: '', displayName: '', photoUrl: ''),
        CustomUser(id: '', email: '', displayName: '', photoUrl: ''),
        CustomUser(id: '', email: '', displayName: '', photoUrl: ''),
        CustomUser(id: '', email: '', displayName: '', photoUrl: ''),
        CustomUser(id: '', email: '', displayName: '', photoUrl: ''),
        CustomUser(id: '', email: '', displayName: '', photoUrl: ''),
      ];
      return _buildHabitUsersAvatars(customUserPreviewList);
    }

    return FutureBuilder(
        future: dbUsersCollection.getUsersConnectedToHabit(habitId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            print("Error while getting habit unique users for avatars");
          }

          List<CustomUser> uniqueHabitUsers = snapshot.data ?? [];
          for (CustomUser customUser in uniqueHabitUsers) {
            if (customUser.id == FirebaseAuth.instance.currentUser!.uid) {
              uniqueHabitUsers.remove(customUser);
              break;
            }
          }
          return _buildHabitUsersAvatars(uniqueHabitUsers);
        });
  }
}

_buildHabitUsersAvatars(List<CustomUser> usersList) {
  return SizedBox(
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (int i = 0; i < usersList.length && i < 3; i++)
          if (i < 3)
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
        if (usersList.length > 4)
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 18,
            child: Text(
              "+${usersList.length - 3}",
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    ),
  );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';

class DbUsers {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final DbHabits dbHabitsCollection = DbHabits();

  Future<CustomUser?> getUser(String uid) async {
    DocumentSnapshot userDoc = await userCollection.doc(uid).get();
    if (userDoc.exists) {
      return CustomUser.fromFirestore(userDoc);
    } else {
      return null;
    }
  }

  Future<List<CustomUser>> getUsersConnectedToHabit(String habitId) async {
    Habit? habit = await dbHabitsCollection.getHabit(habitId);
    if (habit == null) {
      print("Error while getting users connected to habit with id: $habitId");
      return [];
    }

    List<CustomUser> users = [];
    List<String> userUids = habit.userUids;
    for (var uid in userUids) {
      CustomUser? user = await getUser(uid);
      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }

  Future<CustomUser?> addCustomUser(
      {required String uid,
      required String displayName,
      required String email,
      required String photoUrl}) async {
    if (await getUser(uid) != null) {
      print(
          "Error while adding a new custom user. User with uid $uid already exists");
      return null;
    }

    try {
      await userCollection.doc(uid).set(
          {'displayName': displayName, 'email': email, 'photoUrl': photoUrl});

      CustomUser customUser = CustomUser(
          id: uid, email: email, displayName: displayName, photoUrl: photoUrl);
      print("Created a new user with doc id: ${customUser.id}");
      return customUser;
    } catch (error) {
      print("Failed to add a new custom user: $error");
      return null;
    }
  }
}

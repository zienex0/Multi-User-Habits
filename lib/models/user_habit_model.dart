import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:multiuser_habits/services/db_users_service.dart';

class UserHabit {
  final String id;
  final Timestamp completionDate;
  final double quantity;
  final String userNote;
  final String habitId;
  final String userUid;
  bool isInitial;
  late CustomUser? user;
  late Habit? habit;

  UserHabit({
    required this.id,
    required this.completionDate,
    required this.quantity,
    required this.userNote,
    required this.habitId,
    required this.userUid,
    required this.isInitial,
    this.user,
    this.habit,
  });

  factory UserHabit.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      throw Exception("UserHabit document doesnt exist or null");
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    double quantity = (data['quantity'] is int)
        ? (data['quantity'] as int).toDouble()
        : data['quantity'] as double;

    print(data);

    return UserHabit(
        id: doc.id,
        completionDate: data['completionDate'],
        quantity: quantity,
        userNote: data['userNote'] ?? '',
        habitId: data['habitId'],
        userUid: data['userUid'],
        isInitial: data['isInitial']);
  }

  Future<void> fetchAndAssignUserAndHabit() async {
    try {
      await _fetchAndAssignUser(userUid);
      await _fetchAndAssignHabit(habitId);
    } catch (e) {
      throw Exception("Error fetching user or habit from UserHabit model: $e");
    }
  }

  Future<void> _fetchAndAssignUser(String userHabitUserUid) async {
    DbUsers dbUsers = DbUsers();
    user = await dbUsers.getUserDataByUserUid(userHabitUserUid);
    if (user == null) {
      throw Exception(
          "Error while fetching and assigning user. User with id $userUid not found.");
    }
  }

  Future<void> _fetchAndAssignHabit(String userHabitHabitId) async {
    DbHabits dbHabits = DbHabits();
    habit = await dbHabits.getHabitData(userHabitHabitId);
    if (habit == null) {
      throw Exception(
          "Error while fetching and assigning habit. Habit with id $habitId not found.");
    }
  }

  // Map<String, dynamic> toMap() {}
}

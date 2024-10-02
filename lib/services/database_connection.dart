import 'package:cloud_firestore/cloud_firestore.dart';

class DbHabits {
  CollectionReference habitCollection =
      FirebaseFirestore.instance.collection('habits');

  Future<List<Map<String, dynamic>>> getAllHabits() async {
    QuerySnapshot snapshot = await habitCollection.get();
    List<Map<String, dynamic>> habits =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return habits;
  }

  Future<Map<String, dynamic>?> getHabitData(String habitId) async {
    DocumentSnapshot habitDoc = await habitCollection.doc(habitId).get();
    if (habitDoc.exists) {
      return habitDoc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}

class DbUsers {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot<Object?>> getUser(String userId) async {
    final userDoc = await usersCollection.doc(userId).get();
    return userDoc;
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final user = await getUser(userId);
    if (user.exists) {
      return user.data() as Map<String, dynamic>?;
    } else {
      return null;
    }
  }
}

class DbUserHabits {}

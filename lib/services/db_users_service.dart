import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/user_model.dart';

class DbUsers {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<User?> getUserData(String userId) async {
    DocumentSnapshot userDoc = await userCollection.doc(userId).get();
    if (userDoc.exists) {
      return User.fromFirestore(userDoc);
    } else {
      return null;
    }
  }
}

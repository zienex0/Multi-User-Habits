import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/user_model.dart';

class DbUsers {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<CustomUser?> getUserData(String userId) async {
    DocumentSnapshot userDoc = await userCollection.doc(userId).get();
    if (userDoc.exists) {
      return CustomUser.fromFirestore(userDoc);
    } else {
      return null;
    }
  }
}

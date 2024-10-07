import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiuser_habits/models/user_model.dart';

class DbUsers {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<CustomUser?> getUserDataByDocId(String id) async {
    DocumentSnapshot userDoc = await userCollection.doc(id).get();
    if (userDoc.exists) {
      return CustomUser.fromFirestore(userDoc);
    } else {
      return null;
    }
  }

  Future<CustomUser?> getUserDataByUserUid(String uid) async {
    QuerySnapshot userDoc =
        await userCollection.where('uid', isEqualTo: uid).get();

    if (userDoc.docs.isEmpty) {
      print("User with uid $uid was not found in user collection");
      return null;
    } else if (userDoc.docs.length == 1) {
      return CustomUser.fromFirestore(userDoc.docs[0]);
    }
    print(
        "Warning, found more than one user with the same uid $uid in users collection");
    return null;
  }

  Future<CustomUser?> addCustomUser(CustomUser customUser) async {
    try {
      DocumentReference docRef = await userCollection.add(customUser.toMap());

      customUser.id = docRef.id;

      await docRef.update({'id': customUser.id});

      print("Created a new user with doc id: ${customUser.id}");
      return customUser;
    } catch (error) {
      print("Failed to add a new custom user: $error");
      return null;
    }
  }
}

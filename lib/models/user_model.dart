import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String? id;
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;

  CustomUser(
      {this.id,
      required this.uid,
      required this.email,
      required this.displayName,
      required this.photoUrl});

  factory CustomUser.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      throw Exception('User document doesnt exist or is null');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CustomUser(
        id: doc.id,
        uid: doc['uid'],
        email: data['email'] ?? '',
        displayName: data['displayName'] ?? 'Anonymous',
        photoUrl: data['photoUrl']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}

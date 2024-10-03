import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String displayName;

  User({required this.id, required this.email, required this.displayName});

  factory User.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      throw Exception('User document doesnt exist or is null');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return User(
        id: doc.id,
        email: data['email'] ?? '',
        displayName: data['displayName'] ?? 'Anonymous');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
    };
  }
}

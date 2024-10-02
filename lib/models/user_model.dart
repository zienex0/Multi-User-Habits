import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String displayName;

  User({required this.id, required this.email, required this.displayName});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data.isEmpty) {
      throw Exception('Document data is null');
    }

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

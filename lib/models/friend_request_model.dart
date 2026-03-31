import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/models/user_model.dart';

class FriendRequestModel {
  final String id;
  final String from;
  final String to;
  final UserModel user;
  final String status;
  final DateTime createdAt;

  FriendRequestModel({
    required this.id,
    required this.from,
    required this.to,
    required this.user,
    required this.status,
    required this.createdAt,
  });

  factory FriendRequestModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return FriendRequestModel(
      id: doc.id,
      from: data['from'],
      to: data['to'],
      user: UserModel.fromJson(data['user']),
      status: data['status'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }
}
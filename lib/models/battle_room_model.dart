import 'mini_profile_model.dart';

class BattleRoomModel {
  final String roomId;
  final String status;
  final MiniProfileModel host;
  final MiniProfileModel friend;
  final List<int> questions;

  final Map<String, int> hostProgress;
  final Map<String, int> friendProgress;

  BattleRoomModel({
    required this.roomId,
    required this.status,
    required this.host,
    required this.friend,
    required this.questions,
    required this.hostProgress,
    required this.friendProgress,
  });

  factory BattleRoomModel.fromMap(Map<String, dynamic> map) {
    return BattleRoomModel(
      roomId: map['room_id'] ?? '',
      status: map['status'] ?? '',
      host: MiniProfileModel.fromMap(map['host']),
      friend: MiniProfileModel.fromMap(map['friend']),
      questions: List<int>.from(map['questions'] ?? []),

      hostProgress: Map<String, int>.from(map['host_progress'] ?? {}),

      friendProgress: Map<String, int>.from(map['friend_progress'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'room_id': roomId,
      'status': status,
      'host': host.toMap(),
      'friend': friend.toMap(),
      'questions': questions,
      'host_progress': hostProgress,
      'friend_progress': friendProgress,
    };
  }
}

import 'package:flaguiz/models/country_leaderboard_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/service/firestore_service.dart';

class LeaderboardRepository {
  LeaderboardRepository();
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<UserModel>> getLocalLeaderBoard(String countryId) async {
    return _firestoreService.getLocalLeaderBoard(countryId);
  }

  Future<List<UserModel>> getGlobalLeaderBoard() async {
    return _firestoreService.getGlobalLeaderBoard();
  }

  Future<List<CountryLeaderboardModel>> getCountryLeaderboard() async {
    return _firestoreService.getCountryLeaderboard();
  }
}

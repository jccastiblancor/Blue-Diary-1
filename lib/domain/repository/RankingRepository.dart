
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';

abstract class RankingRepository {
  Future<RankingUserInfo> getRankingUserInfo(String uid);
  Future<bool> setMyRankingUserInfo(RankingUserInfo info);
  Stream<RankingUserInfosEvent> observeRankingUserInfos();
  void initRankingUserInfosCount();
  void increaseRankingUserInfosCount();
  Future<bool> deleteRankingUserInfo(String uid);
  void addThumbsUp(String uid);
  void updateCompletionRatios(List<RankingUserInfo> infos);
}
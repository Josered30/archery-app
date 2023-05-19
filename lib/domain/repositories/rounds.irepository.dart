import 'package:archery/domain/models/round.model.dart';
import 'package:archery/domain/models/score.model.dart';
import 'package:archery/domain/models/take.model.dart';

abstract class RoundIRepository {
  Future<void> saveTake(
      Take take, List<Round> rounds, List<List<Score>> roundsScores);
  Future<Take> getLastTake();
  Future<Take> getTakeById(int id);
  Future<List<Take>> listTakes(int count, int offset);
}

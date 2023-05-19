import 'package:archery/domain/value-objects/round_score.dart';

class RoundState {
  final int id;
  final List<RoundScore> roundScores;

  const RoundState({this.id = 0, this.roundScores = const []});
}

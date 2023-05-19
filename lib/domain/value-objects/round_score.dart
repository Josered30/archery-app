import 'package:archery/domain/value-objects/score_value.dart';

class RoundScore {
  ScoreValue score;
  double dx;
  double dy;
  RoundScore({String scoreValue = 'M', this.dx = 0, this.dy = 0})
      : score = ScoreValue.fromValue(scoreValue);
}

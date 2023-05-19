import 'package:archery/domain/models/score.model.dart';
import 'package:archery/domain/models/take.model.dart';
import 'package:isar/isar.dart';

part 'round.model.g.dart';

@Collection()
class Round {
  Id id = Isar.autoIncrement;

  IsarLinks<Score> scores = IsarLinks<Score>();

  @Backlink(to: 'rounds')
  IsarLink<Take> take = IsarLink<Take>();
}

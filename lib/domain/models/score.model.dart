import 'package:archery/domain/models/round.model.dart';
import 'package:isar/isar.dart';

part 'score.model.g.dart';

@Collection()
class Score {
  Id id = Isar.autoIncrement;

  late String value;
  late double dx;
  late double dy;

  @Backlink(to: 'scores')
  IsarLink<Round> round = IsarLink<Round>();
}

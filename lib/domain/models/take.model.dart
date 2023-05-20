import 'package:archery/domain/models/round.model.dart';
import 'package:archery/domain/value-objects/bow_type.dart';
import 'package:isar/isar.dart';
part 'take.model.g.dart';

@Collection()
class Take {
  Id id = Isar.autoIncrement;

  late String title;
  late DateTime createdAt;
  late int roundsCount;

  @enumerated
  late BowType bowType;

  IsarLinks<Round> rounds = IsarLinks<Round>();
}

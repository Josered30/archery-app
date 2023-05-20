import 'package:archery/domain/value-objects/bow_type.dart';

class TakeState {
  final int id;
  final String title;
  final int createdAtTimeStamp;
  final int roundsCount;
  final BowType bowType;

  const TakeState(
      {this.id = 0,
      this.title = '',
      this.createdAtTimeStamp = 0,
      this.roundsCount = 0,
      this.bowType = BowType.none});
}

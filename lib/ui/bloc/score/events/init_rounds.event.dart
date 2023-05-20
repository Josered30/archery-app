part of 'package:archery/ui/bloc/score/score.bloc.dart';

class InitRoundsEvent extends ScoreEvent {
  final int rowsCount;
  final int columnsCount;
  final int roundsCount;
  final int shotsPerRound;
  final String title;
  final InputType inputType;
  final BowType bowType;

  const InitRoundsEvent({
    required this.roundsCount,
    required this.shotsPerRound,
    required this.title,
    required this.inputType,
    required this.bowType,
    this.columnsCount = 0,
    this.rowsCount = 0,
  });

  @override
  List<Object?> get props => [roundsCount, rowsCount, shotsPerRound, inputType, bowType];
}

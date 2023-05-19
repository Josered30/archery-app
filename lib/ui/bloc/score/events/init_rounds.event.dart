part of 'package:archery/ui/bloc/score/score.bloc.dart';

class InitRoundsEvent extends ScoreEvent {
  final int rowsCount;
  final int columnsCount;
  final int roundsCount;
  final int shotsPerRound;
  final String title;
  final InputType inputType;

  const InitRoundsEvent({
    required this.roundsCount,
    required this.shotsPerRound,
    required this.title,
    required this.inputType,
    this.columnsCount = 0,
    this.rowsCount = 0,
  });

  @override
  List<Object?> get props => [roundsCount, rowsCount, shotsPerRound, inputType];
}

part of 'package:archery/ui/bloc/score/score.bloc.dart';

class UpdateTableRoundsEvent extends ScoreEvent {
  final int roundIndex;
  final int scoreIndex;
  final String score;

  const UpdateTableRoundsEvent(
      {required this.roundIndex,
      required this.scoreIndex,
      required this.score});

  @override
  List<Object?> get props => [roundIndex, scoreIndex];
}

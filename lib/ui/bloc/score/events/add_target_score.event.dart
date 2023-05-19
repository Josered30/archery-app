part of 'package:archery/ui/bloc/score/score.bloc.dart';

class AddTargetScoreEvent extends ScoreEvent {
  final String score;
  final double dx;
  final double dy;
  final double width;
  final double height;

  const AddTargetScoreEvent(
      {required this.score,
      required this.dx,
      required this.dy,
      required this.width,
      required this.height});

  @override
  List<Object?> get props => [score, dx, dy];
}

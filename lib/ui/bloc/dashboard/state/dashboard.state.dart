part of 'package:archery/ui/bloc/dashboard/dashboard.bloc.dart';

class DashboardState extends Equatable {
  final List<RoundState> lastTakeRounds;
  final TakeState lastTake;

  const DashboardState(
      {this.lastTake = const TakeState(), this.lastTakeRounds = const []});

  DashboardState copyWith(
      {TakeState? lastTakeState, List<RoundState>? lastTakeRoundStates}) {
    return DashboardState(
        lastTake: lastTakeState ?? lastTake,
        lastTakeRounds: lastTakeRoundStates ?? lastTakeRounds);
  }

  int get totalScore {
    return lastTakeRounds.fold(
        0,
        (previousValue, round) => round.roundScores.fold(
            0,
            (previousValue, roundScore) =>
                previousValue + roundScore.score.number));
  }

  @override
  List<Object?> get props => [lastTake, lastTakeRounds];
}

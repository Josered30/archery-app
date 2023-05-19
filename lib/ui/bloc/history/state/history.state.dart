part of 'package:archery/ui/bloc/history/history.bloc.dart';

class HistoryState extends Equatable {
  final List<TakeState> takes;
  final List<RoundState> takeRounds;

  final int selectedTakeId;
  final int page;

  const HistoryState(
      {this.takes = const [],
      this.takeRounds = const [],
      this.page = 0,
      this.selectedTakeId = 0});

  HistoryState copyWith(
      {List<TakeState>? takes,
      List<RoundState>? rounds,
      int? selectedTakeId,
      int? page}) {
    return HistoryState(
        takes: takes ?? this.takes,
        takeRounds: rounds ?? takeRounds,
        selectedTakeId: selectedTakeId ?? this.selectedTakeId,
        page: page ?? this.page);
  }

  TakeState getTakeStateById(int takeId) {
    return takes.firstWhere((take) => take.id == takeId);
  }

  int get totalScore {
    return takeRounds.fold(
        0,
        (previousValue, round) => round.roundScores.fold(
            0,
            (previousValue, roundScore) =>
                previousValue + roundScore.score.number));
  }

  @override
  List<Object?> get props => [takes, takeRounds, page, selectedTakeId];
}

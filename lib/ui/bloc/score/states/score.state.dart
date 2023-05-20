part of 'package:archery/ui/bloc/score/score.bloc.dart';

class ScoreState extends Equatable {
  final int columnsCount;
  final int rowsCount;
  final int roundsCount;
  final int shotsPerRound;
  final int currentRound;

  final List<List<RoundScore>> tableRounds;
  final List<List<RoundScore>> targetRounds;

  final bool enableInitForm;

  final String title;

  final InputType inputType;
  final BowType bowType;

  const ScoreState(
      {this.columnsCount = 0,
      this.rowsCount = 0,
      this.roundsCount = 0,
      this.shotsPerRound = 0,
      this.currentRound = 0,
      this.enableInitForm = true,
      this.tableRounds = const [],
      this.targetRounds = const [],
      this.title = '',
      this.inputType = InputType.none,
      this.bowType = BowType.none});

  ScoreState copyWith(
      {int? columnsCount,
      int? rowsCount,
      int? roundsCount,
      int? shotsPerRound,
      int? currentRound,
      bool? enableInitForm,
      List<List<RoundScore>>? tableRounds,
      List<List<RoundScore>>? targetRounds,
      String? title,
      InputType? inputType,
      BowType? bowType}) {
    return ScoreState(
        columnsCount: columnsCount ?? this.columnsCount,
        rowsCount: rowsCount ?? this.rowsCount,
        roundsCount: roundsCount ?? this.roundsCount,
        shotsPerRound: shotsPerRound ?? this.shotsPerRound,
        currentRound: currentRound ?? this.currentRound,
        enableInitForm: enableInitForm ?? this.enableInitForm,
        tableRounds: tableRounds ?? this.tableRounds,
        targetRounds: targetRounds ?? this.targetRounds,
        title: title ?? this.title,
        inputType: inputType ?? this.inputType,
        bowType: bowType ?? this.bowType);
  }

  @override
  List<Object?> get props => [
        columnsCount,
        rowsCount,
        tableRounds,
        targetRounds,
        currentRound,
        inputType,
        shotsPerRound,
        enableInitForm,
        title
      ];
}

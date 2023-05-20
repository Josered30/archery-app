import 'package:archery/domain/models/round.model.dart';
import 'package:archery/domain/models/score.model.dart';
import 'package:archery/domain/models/take.model.dart';
import 'package:archery/domain/value-objects/round_score.dart';
import 'package:archery/domain/value-objects/score_value.dart';
import 'package:archery/infrastructure/repositories/rounds.repository.dart';
import 'package:archery/domain/value-objects/bow_type.dart';
import 'package:archery/ui/modules/score/types/input_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/score.event.dart';
part 'events/init_rounds.event.dart';
part 'events/save_rounds.event.dart';
part 'events/update_table_rounds.event.dart';
part 'events/add_target_score.event.dart';
part 'events/next_round.event.dart';
part 'events/last_round.event.dart';
part 'events/reset_target_score.event.dart';
part 'states/score.state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  final RoundsRepository _roundsRepository;

  ScoreBloc({required RoundsRepository roundsRepository})
      : _roundsRepository = roundsRepository,
        super(const ScoreState()) {
    on<InitRoundsEvent>(_onInitRounds);
    on<UpdateTableRoundsEvent>(_onUpdateTableRounds);
    on<SaveRoundsEvent>(_onSaveRounds);
    on<AddTargetScoreEvent>(_onAddTargetScore);
    on<NextRoundEvent>(_onNextRoundEvent);
    on<LastRoundEvent>(_onLastRoundEvent);
    on<ResetTargetScoreEvent>(_onResetRoundState);
  }

  void _onResetRoundState(ResetTargetScoreEvent resetTargetScoreEvent,
      Emitter<ScoreState> emitter) {
    emitter(state.copyWith(
        targetRounds: List.generate(state.roundsCount, (_) => [])));
  }

  void _onInitRounds(
      InitRoundsEvent setRoundsEvent, Emitter<ScoreState> emitter) {
    ScoreState newState;

    if (setRoundsEvent.inputType == InputType.table) {
      newState = state.copyWith(
          rowsCount: setRoundsEvent.rowsCount,
          columnsCount: setRoundsEvent.columnsCount,
          roundsCount: setRoundsEvent.roundsCount,
          shotsPerRound: setRoundsEvent.shotsPerRound,
          title: setRoundsEvent.title,
          inputType: setRoundsEvent.inputType,
          bowType: setRoundsEvent.bowType,
          tableRounds: List.generate(
              setRoundsEvent.roundsCount,
              (_) => List.generate(
                  setRoundsEvent.shotsPerRound, (_) => RoundScore())),
          enableInitForm: false);
    } else {
      newState = state.copyWith(
          roundsCount: setRoundsEvent.roundsCount,
          shotsPerRound: setRoundsEvent.shotsPerRound,
          inputType: setRoundsEvent.inputType,
          bowType: setRoundsEvent.bowType,
          title: setRoundsEvent.title,
          targetRounds: List.generate(setRoundsEvent.roundsCount, (_) => []),
          enableInitForm: false);
    }
    
    emitter(newState);
  }

  void _onUpdateTableRounds(
      UpdateTableRoundsEvent updateRoundsEvent, Emitter<ScoreState> emitter) {
    List<List<RoundScore>> newRounds = List.from(state.tableRounds);
    newRounds[updateRoundsEvent.roundIndex][updateRoundsEvent.scoreIndex]
        .score = ScoreValue.fromValue(updateRoundsEvent.score);

    emitter(state.copyWith(tableRounds: newRounds));
  }

  void _onAddTargetScore(
      AddTargetScoreEvent addTargetScoreEvent, Emitter<ScoreState> emitter) {
    if (state.targetRounds[state.currentRound].length == state.shotsPerRound) {
      return;
    }

    List<List<RoundScore>> newRounds = List.from(state.targetRounds);

    double normalizedDx = addTargetScoreEvent.dx / addTargetScoreEvent.width;
    double normalizedDy = addTargetScoreEvent.dy / addTargetScoreEvent.height;

    RoundScore newRoundScoreState = RoundScore(
        scoreValue: addTargetScoreEvent.score,
        dx: normalizedDx,
        dy: normalizedDy);

    List<RoundScore> round = List.from(newRounds[state.currentRound]);
    round.add(newRoundScoreState);
    newRounds[state.currentRound] = round;

    emitter(state.copyWith(targetRounds: newRounds));
  }

  void _onNextRoundEvent(
      NextRoundEvent nextRoundEvent, Emitter<ScoreState> emitter) async {
    emitter(state.copyWith(
        currentRound: state.currentRound + 1 < state.roundsCount
            ? state.currentRound + 1
            : state.currentRound));
  }

  void _onLastRoundEvent(
      LastRoundEvent lastRoundEvent, Emitter<ScoreState> emitter) async {
    emitter(state.copyWith(
        currentRound: state.currentRound > 0
            ? state.currentRound - 1
            : state.currentRound));
  }

  Future<void> _onSaveRounds(
      SaveRoundsEvent saveRoundsEvent, Emitter<ScoreState> emitter) async {
    Take take = Take();
    take.title = state.title;
    take.createdAt = DateTime.now();
    take.roundsCount = state.roundsCount;
    take.bowType = state.bowType;

    List<List<RoundScore>> roundsScores = state.inputType == InputType.table
        ? state.tableRounds
        : state.targetRounds;

    List<Round> rounds = roundsScores.map((roundScores) {
      Round round = Round();
      return round;
    }).toList();

    List<List<Score>> scores = roundsScores.map((roundScores) {
      return roundScores.map((roundScore) {
        Score score = Score();
        score.value = roundScore.score.value;
        score.dx = roundScore.dx;
        score.dy = roundScore.dy;
        return score;
      }).toList();
    }).toList();

    await _roundsRepository.saveTake(take, rounds, scores);
  }
}

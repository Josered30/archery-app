import 'package:archery/domain/models/take.model.dart';
import 'package:archery/domain/value-objects/round.state.dart';
import 'package:archery/domain/value-objects/round_score.dart';
import 'package:archery/domain/value-objects/take.state.dart';
import 'package:archery/infrastructure/repositories/rounds.repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/history.event.dart';
part 'events/list-rounds.event.dart';
part 'events/list-takes.event.dart';
part 'events/delete-take.event.dart';
part 'state/history.state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final RoundsRepository _roundRepository;

  HistoryBloc({required RoundsRepository roundsRepository})
      : _roundRepository = roundsRepository,
        super(const HistoryState()) {
    on<ListTakesEvent>(_onListTakes);
    on<ListRoundEvent>(_onListRounds);
    on<DeleteTakeEvent>(_onDeleteTake);
  }

  Future<void> _onDeleteTake(
      DeleteTakeEvent deleteTakeEvent, Emitter<HistoryState> emitter) async {
    await _roundRepository.deleteTake(deleteTakeEvent.id);

    int takeIndex =
        state.takes.indexWhere((take) => take.id == deleteTakeEvent.id);

    List<TakeState> newTakes = List.from(state.takes);
    newTakes.removeAt(takeIndex);

    emitter(state.copyWith(takes: newTakes));
  }

  Future<void> _onListTakes(
      ListTakesEvent listTakesEvent, Emitter<HistoryState> emitter) async {
    int count = 10;
    int offset = count * state.page;

    List<Take> takes = await _roundRepository.listTakes(count, offset);

    emitter(state.copyWith(
        takes: takes
            .map((take) => TakeState(
                id: take.id,
                title: take.title,
                createdAtTimeStamp: take.createdAt.millisecondsSinceEpoch,
                roundsCount: take.roundsCount,
                bowType: take.bowType))
            .toList()));
  }

  Future<void> _onListRounds(
      ListRoundEvent listRoundEvent, Emitter<HistoryState> emitter) async {
    Take take = await _roundRepository.getTakeById(listRoundEvent.takeId);

    emitter(state.copyWith(
        takes: [
          TakeState(
              id: take.id,
              title: take.title,
              createdAtTimeStamp: take.createdAt.millisecondsSinceEpoch,
              bowType: take.bowType)
        ],
        rounds: take.rounds
            .map((round) => RoundState(
                  id: round.id,
                  roundScores: round.scores
                      .map((score) => RoundScore(
                          scoreValue: score.value, dx: score.dx, dy: score.dy))
                      .toList(),
                ))
            .toList(),
        selectedTakeId: listRoundEvent.takeId));
  }
}

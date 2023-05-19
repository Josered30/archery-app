import 'package:archery/domain/models/take.model.dart';
import 'package:archery/domain/value-objects/round.state.dart';
import 'package:archery/domain/value-objects/round_score.dart';
import 'package:archery/domain/value-objects/take.state.dart';
import 'package:archery/infrastructure/repositories/rounds.repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/dashboard.event.dart';
part 'events/update_last_take.event.dart';
part 'state/dashboard.state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final RoundsRepository _roundsRepository;

  DashboardBloc({required RoundsRepository roundsRepository})
      : _roundsRepository = roundsRepository,
        super(const DashboardState()) {
    on<UpdateLastTakeEvent>(_onUpdateLastTakeEvent);
  }

  Future<void> _onUpdateLastTakeEvent(UpdateLastTakeEvent updateLastTakeEvent,
      Emitter<DashboardState> emitter) async {
    try {
      Take take = await _roundsRepository.getLastTake();
      
      emitter(state.copyWith(
          lastTakeState: TakeState(
              title: take.title,
              id: take.id,
              createdAtTimeStamp: take.createdAt.millisecondsSinceEpoch,
              roundsCount: take.roundsCount),
          lastTakeRoundStates: take.rounds
              .map((round) => RoundState(
                    id: round.id,
                    roundScores: round.scores
                        .map((score) => RoundScore(scoreValue: score.value))
                        .toList(),
                  ))
              .toList()));
    } catch (error) {
      print(error.toString());
    }
  }
}

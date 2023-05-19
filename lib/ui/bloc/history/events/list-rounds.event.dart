part of 'package:archery/ui/bloc/history/history.bloc.dart';

class ListRoundEvent extends HistoryEvent {
  final int takeId;

  const ListRoundEvent({required this.takeId});

  @override
  List<Object?> get props => [takeId];
}

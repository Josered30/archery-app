part of 'package:archery/ui/bloc/history/history.bloc.dart';

class DeleteTakeEvent extends HistoryEvent {
  final int id;

  const DeleteTakeEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

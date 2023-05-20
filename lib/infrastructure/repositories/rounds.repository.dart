import 'dart:io';

import 'package:archery/domain/error/database.error.dart';
import 'package:archery/domain/models/round.model.dart';
import 'package:archery/domain/models/score.model.dart';
import 'package:archery/domain/models/take.model.dart';
import 'package:archery/domain/repositories/rounds.irepository.dart';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class RoundsRepository implements RoundIRepository {
  late Isar isar;

  RoundsRepository();

  Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [RoundSchema, TakeSchema, ScoreSchema],
      directory: dir.path,
    );
  }

  Future<void> close() async {
    await isar.close();
  }

  @override
  Future<void> saveTake(
      Take take, List<Round> rounds, List<List<Score>> roundsScores) async {
    print("${take.bowType}");

    await isar.writeTxn(() async {
      List<List<Score>> newRoundsScores = List.empty(growable: true);

      for (var roundScores in roundsScores) {
        List<int> roundScoresId = await isar.scores.putAll(roundScores);
        List<Score> newRoundScores =
            (await isar.scores.getAll(roundScoresId)).nonNulls.toList();
        newRoundsScores.add(newRoundScores);
      }

      List<int> roundsId = await isar.rounds.putAll(rounds);
      List<Round> newRounds =
          (await isar.rounds.getAll(roundsId)).nonNulls.toList();

      for (int i = 0; i < newRounds.length; ++i) {
        Round newRound = newRounds[i];
        newRound.scores.addAll(newRoundsScores[i].nonNulls);
        newRound.scores.save();
      }

      int takeId = await isar.takes.put(take);
      Take? newTake = await isar.takes.get(takeId);
      if (newTake == null) {
        throw DatabaseError("Take not created");
      }

      newTake.rounds.addAll(newRounds.nonNulls);
      newTake.rounds.save();
    });
  }

  @override
  Future<Take> getLastTake() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    List<Take> takes = await isar.takes
        .filter()
        .createdAtGreaterThan(startOfDay, include: true)
        .sortByCreatedAt()
        .findAll();

    if (takes.isEmpty) {
      throw DatabaseError("Takes not found");
    }

    return takes.last;
  }

  @override
  Future<Take> getTakeById(int id) async {
    Take? take = await isar.takes.get(id);

    if (take == null) {
      throw DatabaseError("Take not found");
    }
    return take;
  }

  @override
  Future<List<Take>> listTakes(int count, int offset) async {
    List<Take> takes =
        await isar.takes.where().offset(offset).limit(count).findAll();
    return takes;
  }
}

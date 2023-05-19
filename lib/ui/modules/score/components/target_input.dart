import 'package:archery/domain/value-objects/round_score.dart';
import 'package:archery/domain/value-objects/target.dart';
import 'package:archery/ui/bloc/score/score.bloc.dart';
import 'package:archery/ui/modules/shared/target.painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TargetInput extends StatelessWidget {
  final int layers = 6;

  const TargetInput({Key? key}) : super(key: key);

  void addTargetScore(BuildContext context, Offset targetPosition,
      Target target, double width) {
    Offset center = Offset(target.width / 2, target.width / 2);

    int score = layers - 1;
    for (int i = 0; i < target.targetLayers.length; ++i) {
      double distance = (center - targetPosition).distance;
      if (distance < target.targetLayers[i].radius) {
        score += 1;
      }
    }

    ScoreBloc scoreBloc = context.read<ScoreBloc>();

    scoreBloc.add(AddTargetScoreEvent(
        score: score.toString(),
        dx: targetPosition.dx,
        dy: targetPosition.dy,
        width: width,
        height: width));
  }

  void nextRound(BuildContext context) {
    ScoreBloc scoreBloc = context.read<ScoreBloc>();
    scoreBloc.add(NextRoundEvent());
  }

  void lastRound(BuildContext context) {
    ScoreBloc scoreBloc = context.read<ScoreBloc>();
    scoreBloc.add(LastRoundEvent());
  }

  void resetRound(BuildContext context) {
    ScoreBloc scoreBloc = context.read<ScoreBloc>();
    scoreBloc.add(ResetTargetScoreEvent());
  }

  void saveRounds(BuildContext context) {
    ScoreBloc scoreBloc = context.read<ScoreBloc>();

    List<List<RoundScore>> roundsScores = scoreBloc.state.targetRounds;
    bool valid = roundsScores.every(
        (roundScores) => roundScores.length == scoreBloc.state.shotsPerRound);

    if (!valid) {
      return;
    }

    scoreBloc.add(SaveRoundsEvent());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoreBloc, ScoreState>(builder: (blocContext, state) {
      List<RoundScore> targetRound = state.targetRounds[state.currentRound];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            // Inner yellow container
            builder: (_, constraints) {
              Target target = Target.build(
                  layers,
                  constraints.maxWidth,
                  List.from(
                      [Colors.cyan[700], Colors.red[700], Colors.yellow[700]]));

              return AspectRatio(
                aspectRatio: 1 / 1,
                child: GestureDetector(
                  onTapDown: (TapDownDetails tapDownDetails) {
                    addTargetScore(context, tapDownDetails.localPosition,
                        target, constraints.maxWidth);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[500]),
                    child: CustomPaint(
                        painter: TargetPainter(
                            roundScores: targetRound, target: target)),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => lastRound(blocContext),
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.grey[200],
                    )),
                Text(
                  "Round: ${state.currentRound + 1}",
                  style: const TextStyle(color: Colors.amber, fontSize: 18),
                ),
                IconButton(
                    onPressed: () => nextRound(blocContext),
                    icon: Icon(Icons.chevron_right, color: Colors.grey[200])),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child:
                Text("Shots left: ${state.shotsPerRound - targetRound.length}"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      saveRounds(blocContext);
                    },
                    child: const Text("Save")),
                ElevatedButton(
                    onPressed: () {
                      resetRound(blocContext);
                    },
                    child: const Text("Reset"))
              ],
            ),
          )
        ],
      );
    });
  }
}

import 'package:archery/ui/bloc/score/score.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoundInput extends StatelessWidget {
  const RoundInput({Key? key}) : super(key: key);

  void updateRounds(
      int roundIndex, int scoreIndex, String value, BuildContext context) {
    if (value.isEmpty) {
      return;
    }

    ScoreBloc scoreBloc = context.read<ScoreBloc>();
    scoreBloc.add(UpdateTableRoundsEvent(
        roundIndex: roundIndex, scoreIndex: scoreIndex, score: value));
  }

  BorderRadius getBorderRadius(int columnsCount, int rowsCount, int index) {
    int colIndex = (index % columnsCount).floor() + 1;
    int rowIndex = (index / columnsCount).floor() + 1;

    Radius topLeft =
        colIndex == 1 && rowIndex == 1 ? const Radius.circular(5) : Radius.zero;

    Radius topRight = colIndex == columnsCount && rowIndex == 1
        ? const Radius.circular(5)
        : Radius.zero;

    Radius bottomLeft = colIndex == 1 && rowIndex == rowsCount
        ? const Radius.circular(5)
        : Radius.zero;

    Radius bottomRight = colIndex == columnsCount && rowIndex == rowsCount
        ? const Radius.circular(5)
        : Radius.zero;

    return BorderRadius.only(
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
        topLeft: topLeft);
  }

  void saveRounds(BuildContext context) {
    ScoreBloc scoreBloc = context.read<ScoreBloc>();
    scoreBloc.add(SaveRoundsEvent());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoreBloc, ScoreState>(
      builder: (blocContext, state) => Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: state.roundsCount,
              itemBuilder: (_, cIndex) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Round ${cIndex + 1}"),
                      const SizedBox(height: 20),
                      GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 50,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                            crossAxisCount: state.columnsCount,
                          ),
                          itemCount: state.shotsPerRound,
                          physics:
                              const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                          shrinkWrap: true,
                          itemBuilder: (_, gIndex) {
                            BorderRadius borderRadius = getBorderRadius(
                                state.columnsCount, state.rowsCount, gIndex);

                            return TextField(
                                onChanged: (value) => updateRounds(
                                    cIndex, gIndex, value, context),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: borderRadius,
                                  ),
                                  isDense: true,
                                ));
                          }),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
                onPressed: () {
                  saveRounds(blocContext);
                },
                child: const Text("Save")),
          )
        ],
      ),
    );
  }
}

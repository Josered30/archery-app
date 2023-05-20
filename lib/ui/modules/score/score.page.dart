import 'package:archery/ui/bloc/score/score.bloc.dart';
import 'package:archery/infrastructure/repositories/rounds.repository.dart';
import 'package:archery/ui/modules/score/components/round_input.dart';
import 'package:archery/ui/modules/score/components/target_input.dart';
import 'package:archery/domain/value-objects/bow_type.dart';
import 'package:archery/ui/modules/score/types/input_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TakeInput extends StatefulWidget {
  final bool enabled;

  const TakeInput({Key? key, this.enabled = true}) : super(key: key);

  @override
  _TakeInputState createState() => _TakeInputState();
}

class _TakeInputState extends State<TakeInput> {
  final titleController = TextEditingController();
  final roundsController = TextEditingController();
  final shotsPerRoundController = TextEditingController();

  BowType bowType = BowType.none;

  @override
  void dispose() {
    titleController.dispose();
    roundsController.dispose();
    shotsPerRoundController.dispose();
    super.dispose();
  }

  void initRounds(InputType inputType, BuildContext context) {
    if (shotsPerRoundController.text.isEmpty ||
        roundsController.text.isEmpty ||
        titleController.text.isEmpty) {
      return;
    }

    int shotsPerRound = int.parse(shotsPerRoundController.text);
    int roundsCount = int.parse(roundsController.text);

    if (shotsPerRound == 0 || roundsCount == 0) {
      return;
    }

    ScoreBloc scoreBloc = context.read<ScoreBloc>();

    int columnsCount = shotsPerRound > 3 ? 3 : shotsPerRound;
    int rowsCount = (shotsPerRound / columnsCount).ceil();

    scoreBloc.add(InitRoundsEvent(
        columnsCount: columnsCount,
        roundsCount: roundsCount,
        rowsCount: rowsCount,
        shotsPerRound: shotsPerRound,
        title: titleController.text,
        inputType: inputType,
        bowType: bowType));
  }

  Widget _textField(TextEditingController controller, bool enableInit,
          String title, TextInputType textInputType) =>
      TextField(
        controller: controller,
        enabled: enableInit,
        style: const TextStyle(fontSize: 12),
        keyboardType: textInputType,
        decoration: InputDecoration(
            floatingLabelStyle:
                TextStyle(color: enableInit ? null : Colors.grey[200]),
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelText: title),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _textField(
              titleController, widget.enabled, "Title", TextInputType.text),
          const SizedBox(height: 20),
          _textField(
              roundsController, widget.enabled, "Rounds", TextInputType.number),
          const SizedBox(height: 20),
          _textField(shotsPerRoundController, widget.enabled, "Shots per round",
              TextInputType.number),
          const SizedBox(height: 20),
          DropdownButtonFormField(
              isExpanded: true,
              value: bowType,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
              items: BowType.values
                  .map((bowType) => DropdownMenuItem(
                        value: bowType,
                        child: Text(
                          bowType.name,
                          style: TextStyle(color: Colors.grey[200]),
                        ),
                      ))
                  .toList(),
              onChanged: (BowType? bowType) {
                if (bowType == null) {
                  return;
                }
                setState(() {
                  this.bowType = bowType;
                });
              }),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () => initRounds(InputType.table, context),
                  child: const Text("Table")),
              ElevatedButton(
                  onPressed: () => initRounds(InputType.target, context),
                  child: const Text("Target")),
            ],
          ),
          // const SizedBox(height: 50),
          // Container(
          //   decoration: const BoxDecoration(
          //     color: Colors.transparent,
          //     shape: BoxShape.circle,
          //     //more than 50% of width makes circle
          //   ),
          //   child: ClipOval(
          //       child: SizedBox.fromSize(
          //           size: const Size.fromRadius(100),
          //           child: Image.asset(
          //             'assets/bow.gif',
          //             fit: BoxFit.cover,
          //           ))),
          // ),
        ],
      ),
    );
  }
}

class ScorePage extends StatelessWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (blocContext) =>
          ScoreBloc(roundsRepository: blocContext.read<RoundsRepository>()),
      child: const ScoreView(),
    );
  }
}

class ScoreView extends StatelessWidget {
  const ScoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoreBloc, ScoreState>(builder: (blocContext, state) {
      Widget input = state.inputType == InputType.table
          ? const RoundInput()
          : const TargetInput();

      return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: state.enableInitForm
              ? TakeInput(
                  enabled: state.enableInitForm,
                )
              : input);
    });
  }
}

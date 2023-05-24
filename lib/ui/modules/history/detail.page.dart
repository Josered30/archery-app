import 'package:archery/domain/value-objects/take.state.dart';
import 'package:archery/domain/value-objects/target.dart';
import 'package:archery/ui/bloc/history/history.bloc.dart';
import 'package:archery/infrastructure/repositories/rounds.repository.dart';
import 'package:archery/ui/modules/shared/target.painter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final int takeId;

  const DetailPage({Key? key, required this.takeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (blocContext) =>
          HistoryBloc(roundsRepository: blocContext.read<RoundsRepository>()),
      child: DetailView(
        takeId: takeId,
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  final int takeId;
  final int layers = 6;

  final CarouselController carouselController = CarouselController();

  DetailView({Key? key, this.takeId = 0}) : super(key: key);

  void listRounds(BuildContext context) {
    HistoryBloc historyBloc = context.read<HistoryBloc>();
    historyBloc.add(ListRoundEvent(takeId: takeId));
  }

  BorderRadius getBorderRadius(int columnsCount, int rowsCount, int index) {
    int colIndex = (index % columnsCount).floor() + 1;
    int rowIndex = (index / columnsCount).floor() + 1;

    Radius topLeft =
        colIndex == 1 && rowIndex == 1 ? const Radius.circular(5) : Radius.zero;

    Radius topRight = (colIndex == columnsCount) && rowIndex == 1
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

  @override
  Widget build(BuildContext context) {
    listRounds(context);

    return BlocBuilder<HistoryBloc, HistoryState>(
        builder: (blocContext, state) {
      if (state.takeRounds.isEmpty) {
        return Container();
      }

      TakeState takeState = state.getTakeStateById(state.selectedTakeId);
      DateFormat formatter = DateFormat("dd-MM-yyyy");
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(takeState.createdAtTimeStamp);

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (_, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider(
                    carouselController: carouselController,
                    options: CarouselOptions(
                        viewportFraction: 1,
                        height: constraints.maxWidth,
                        aspectRatio: 1 / 1,
                        enableInfiniteScroll: false,
                        clipBehavior: Clip.hardEdge),
                    items: state.takeRounds.map((roundState) {
                      Target target = Target.build(
                          layers,
                          constraints.maxWidth,
                          List.from([
                            Colors.cyan[700],
                            Colors.red[700],
                            Colors.yellow[700]
                          ]));

                      return Container(
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[500]),
                        child: CustomPaint(
                            painter: TargetPainter(
                                roundScores: roundState.roundScores,
                                target: target)),
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            carouselController.previousPage();
                          },
                          icon: const Icon(Icons.chevron_left_rounded)),
                      IconButton(
                          onPressed: () {
                            carouselController.nextPage();
                          },
                          icon: const Icon(Icons.chevron_right_rounded)),
                    ],
                  )
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: ListView(children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(formatter.format(dateTime))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.list),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${state.takeRounds.length.toString()} round(s)")
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.adjust),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${state.totalScore.toString()} points")
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.type_specimen),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("Bow: ${takeState.bowType.name}")
                ],
              ),
            ]),
          ),
        )
      ]);
    });
  }
}

import 'package:archery/ui/bloc/history/history.bloc.dart';
import 'package:archery/infrastructure/repositories/rounds.repository.dart';

import 'package:archery/ui/modules/history/detail.page.dart';
import 'package:archery/ui/modules/layouts/layout.dart';
import 'package:archery/ui/modules/shared/take_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (blocContext) =>
          HistoryBloc(roundsRepository: blocContext.read<RoundsRepository>()),
      child: const HistoryView(),
    );
  }
}

class HistoryView extends StatelessWidget {
  const HistoryView({Key? key}) : super(key: key);

  void listTakes(BuildContext context) {
    HistoryBloc historyBloc = context.read<HistoryBloc>();
    historyBloc.add(const ListTakesEvent());
  }

  void navigateToDetail(BuildContext context, int takeId, String title) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (routeContext) => RepositoryProvider(
              create: (createContext) => context.read<RoundsRepository>(),
              child: LayoutPage(
                showBottomBar: false,
                title: title,
                child: DetailPage(
                  key: UniqueKey(),
                  takeId: takeId,
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    listTakes(context);

    return BlocBuilder<HistoryBloc, HistoryState>(
        builder: (blocContext, state) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                  itemCount: state.takes.length,
                  itemBuilder: (builderContext, index) => TakeCard(
                        title: state.takes[index].title,
                        subtitle: "${state.takes[index].roundsCount} round(s)",
                        onTap: () {
                          navigateToDetail(builderContext,
                              state.takes[index].id, state.takes[index].title);
                        },
                      )),
            ));
  }
}

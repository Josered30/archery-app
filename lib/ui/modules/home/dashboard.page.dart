import 'package:archery/ui/bloc/dashboard/dashboard.bloc.dart';
import 'package:archery/infrastructure/repositories/rounds.repository.dart';
import 'package:archery/ui/modules/history/detail.page.dart';
import 'package:archery/ui/modules/history/history.page.dart';
import 'package:archery/ui/modules/layouts/layout.dart';
import 'package:archery/ui/modules/score/score.page.dart';
import 'package:archery/ui/modules/shared/take_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (blocContext) =>
          DashboardBloc(roundsRepository: blocContext.read<RoundsRepository>()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({
    Key? key,
  }) : super(key: key);

  void navigateToScore(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (routeContext) => RepositoryProvider(
                  create: (createContext) {
                    return context.read<RoundsRepository>();
                  },
                  child: LayoutPage(
                    showBottomBar: false,
                    title: "Score",
                    child: ScorePage(
                      key: UniqueKey(),
                    ),
                  ),
                )))
        .then((value) => updateLastTake(context));
  }

  void navigateToHistory(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (routeContext) => RepositoryProvider(
              create: (createContext) {
                return context.read<RoundsRepository>();
              },
              child: LayoutPage(
                showBottomBar: false,
                title: "History",
                child: HistoryPage(
                  key: UniqueKey(),
                ),
              ),
            )));
  }

  void navigateToDetail(BuildContext context, int takeId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (routeContext) => RepositoryProvider(
              create: (createContext) => context.read<RoundsRepository>(),
              child: LayoutPage(
                showBottomBar: false,
                title: "Detail",
                child: DetailPage(
                  key: UniqueKey(),
                  takeId: takeId,
                ),
              ),
            )));
  }

  Future<void> updateLastTake(BuildContext context) async {
    DashboardBloc dashboardBloc = context.read<DashboardBloc>();
    await Future.delayed(const Duration(seconds: 2));
    dashboardBloc.add(UpdateLastTakeEvent());
  }

  @override
  Widget build(BuildContext context) {
    updateLastTake(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (blocContext, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TakeCard(
                  title: state.lastTake.title.isEmpty
                      ? 'No records'
                      : state.lastTake.title,
                  subtitle: "Total: ${state.totalScore} points",
                  onTap: () {
                    navigateToDetail(blocContext, state.lastTake.id);
                  },
                )),
              ],
            ),
            const SizedBox(height: 25),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
                Card(
                  color: Colors.grey[800],
                  child: InkWell(
                    onTap: () => navigateToScore(blocContext),
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/target.png',
                            width: 100,
                          ),
                          const Text("Score")
                        ]),
                  ),
                ),
                Card(
                  color: Colors.grey[800],
                  child: InkWell(
                    onTap: () => navigateToHistory(blocContext),
                    borderRadius: BorderRadius.circular(10),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 100,
                            color: Colors.amber,
                          ),
                          Text("History")
                        ]),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

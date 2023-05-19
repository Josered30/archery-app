import 'package:archery/infrastructure/repositories/rounds.repository.dart';
import 'package:archery/ui/modules/home/dashboard.page.dart';
import 'package:archery/ui/modules/layouts/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber, background: Colors.grey[900]),
        textTheme: const TextTheme(
                bodyLarge: TextStyle(),
                bodyMedium: TextStyle(),
                titleLarge: TextStyle())
            .apply(bodyColor: Colors.grey[200], displayColor: Colors.grey[200]),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[800],
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.grey[200]),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.grey[200]),
        iconTheme: IconThemeData(color: Colors.grey[200]),
        useMaterial3: true,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<RoundsRepository>(create: (context) {
            RoundsRepository scoreRepository = RoundsRepository();
            scoreRepository.init();
            return scoreRepository;
          })
        ],
        child: const LayoutPage(
          title: "Dashboard",
          child: DashboardPage(),
        ),
      ),
    );
  }
}

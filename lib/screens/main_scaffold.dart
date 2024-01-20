import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spoti_player_1_2/Futures/futures.dart';
import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/screens/favors_screen.dart';
import 'package:spoti_player_1_2/screens/home_screen.dart';
import 'package:spoti_player_1_2/screens/setting_screen.dart';
import 'package:spoti_player_1_2/screens/splash_screen.dart';
import 'package:spoti_player_1_2/widgets/main_app_bar.dart';
import 'package:spoti_player_1_2/widgets/bottom_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final List<Widget> bodies = const [
    HomeScreen(),
    FavorsScreen(),
    SettingsScreen(),
    SettingsScreen(),
  ];
  final _futures = Futures();
  final _provider = MainProvider();
  @override
  void initState() {
    super.initState();
    // final provider = Provider.of<MainProvider>(context, listen: false);
    getIt.registerSingleton<MainProvider>(_provider, instanceName: 'provider');
    future = _futures.initAll();
    getIt.registerSingleton<Futures>(_futures, instanceName: 'futures');
  }

  Future? future;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future!,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return SplashScreen();
        }
        return Scaffold(
          backgroundColor: scaffoldBackGround,
          extendBody: true,
          appBar: const MainAppBar(),
          body: ValueListenableBuilder<int>(
              valueListenable: _provider.bodyIndex,
              builder: (context, index, child) {
                return bodies[index];
              }),
          bottomNavigationBar: const NavBar(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/widgets/build/songs_builder.dart';
import 'package:spoti_player_1_2/widgets/heads/home_head.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final provider = getIt<MainProvider>(instanceName: providerName);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider.maxJump(controller);
  }

  final controller = ScrollController();
  final _builders = SongBuilders();
  @override
  Widget build(BuildContext context) {
    return ListView.custom(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      childrenDelegate: SliverChildListDelegate([
        HomeHead(),
        ..._builders.songsBuilder(
          666,
        )
      ]),
    );
  }
}

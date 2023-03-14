import 'package:flutter/material.dart';
import 'package:spoti_player_1_2/configs/space.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/widgets/build/songs_builder.dart';
import 'package:spoti_player_1_2/widgets/heads/favor_head.dart';

import '../constants/pathes.dart';

class FavorsScreen extends StatelessWidget {
  const FavorsScreen({super.key});

  static final _provider = getIt<MainProvider>(instanceName: providerName);
  static final _builders = SongBuilders();
  @override
  Widget build(BuildContext context) {
    return ListView.custom(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      childrenDelegate: SliverChildListDelegate(
        [FavorHead(), Space.verti(30), ..._builders.songsBuilder(555)],
      ),
    );
  }
}

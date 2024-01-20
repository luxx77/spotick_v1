import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/configs/space.dart';
import 'package:spoti_player_1_2/constants/colors.dart';
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
    return ValueListenableBuilder(
        valueListenable: _provider.favorChanges,
        builder: (context, value, child) {
          final songs = _provider.playLists[555];
          if (songs?.isEmpty ?? false) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text(
                  'Add ur favorites with heart button ♥️ ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedColor,
                    fontFamily: 'spoti',
                    fontSize: 30.sp,
                  ),
                ),
              ),
            );
          }
          return ListView.custom(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            childrenDelegate: SliverChildListDelegate(
              [
                const FavorHead(),
                Space.verti(30),
                ..._builders.songsBuilder(555),
              ],
            ),
          );
        });
  }
}

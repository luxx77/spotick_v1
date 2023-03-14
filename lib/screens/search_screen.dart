import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/configs/space.dart';
import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/widgets/build/songs_builder.dart';
import 'package:spoti_player_1_2/widgets/search_field.dart';
import 'package:spoti_player_1_2/widgets/search_head.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _provider = getIt<MainProvider>(instanceName: providerName);

  

  final _handManager = getIt<HandlerManager>(instanceName: 'handllerManner');
  final _builders = SongBuilders();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackGround,
      appBar: AppBar(
          title: const SearchField(),
          backgroundColor: scaffoldBackGround,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Space.padLeft(
                  5,
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.sp,
                  )))),
      body: ValueListenableBuilder(
          valueListenable: _provider.searchQuery,
          builder: (context, query, child) {
            // _handManager.reSetQueue(matchSongs, 900); 
            return ListView.custom(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              childrenDelegate: SliverChildListDelegate(
                [
                  const SearchHead(),
                 ..._builders.searchSongBuilder()
                ],
              ),
            );
          }),
    );
  }
}

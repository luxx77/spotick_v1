import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/configs/space.dart';
import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/widgets/current_play_list_carousel.dart';
import 'package:spoti_player_1_2/widgets/listenAbles/listen_able_play.dart';
import 'package:spoti_player_1_2/widgets/listenAbles/listen_able_slider.dart';
import 'package:spoti_player_1_2/widgets/listenAbles/looping_mood_button.dart';
import 'package:spoti_player_1_2/widgets/rich_title_text.dart';
import 'package:spoti_player_1_2/widgets/song_image_widget.dart';
import 'package:spoti_player_1_2/widgets/song_options_widget.dart';

class CurrentSongScreen extends StatelessWidget {
  CurrentSongScreen({
    super.key,
  });
  final play = ValueNotifier(false);
  final durValue = ValueNotifier(0.0);
  bool showLyrics = false;
  final provider = getIt<MainProvider>(instanceName: providerName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBackGround,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Space.padLeft(
              5,
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.sp,
              ),
            ),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          toolbarHeight: 58.h,
          title: const Text(
            'Now playing',
            style: TextStyle(
              fontFamily: 'spoti',
            ),
          ),
          actions: [
            SongOptionsWidget(index: 2),
            Space.hori(5),
          ],
        ),
        body: Space.padSymmetrix(
          0,
          0,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Space.verti(10),
              const SizedBox(width: 99999, child: SliderCarousel()),
              Space.verti(17),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: provider.currentDur,
                          builder: (context, duration, child) {
                            return RichTitleText(
                                title: provider.currentSong.value.title,
                                subTitle: provider.currentSong.value.artist ??
                                    '<unknown>',
                                size: 20,
                                id: 666999990908786765);
                          }),
                    ),
                    Space.hori(6),
                    ImageIcon(
                      const AssetImage(
                        'assets/icons/favor.png',
                      ),
                      size: 25.sp,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              Space.verti(35),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: const ListenableSlider(false),
              ),
              Space.verti(45),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoopingModButton(),
                  nextPrevIcon(false),
                  Space.hori(30),
                  const ListenablePlayPause(),
                  Space.hori(30),
                  nextPrevIcon(true),
                  Icon(
                    Icons.ios_share,
                    color: Colors.white,
                  ),
                ],
              ),
              Space.verti(46.h),
              GestureDetector(
                onTap: () {
                  log('message');
                },
                onHorizontalDragEnd: (details) {
                  log('Down Drag');
                },
                onVerticalDragUpdate: (details) {
                  final offset = details.delta.dy;
                  // log('${offset.toString()} yy');

                  if (offset <= 0) {
                    showLyrics = true;
                  }
                  if (offset > 0) {
                    showLyrics = false;
                  }
                },
                onVerticalDragEnd: (details) {
                  if (showLyrics) {
                    log('UpUp');
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(top: 0.h, left: 88.w),
                    height: 60.h,
                    width: 160.w,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.keyboard_arrow_up_rounded,
                            color: Colors.white, size: 26.sp),
                        Text(
                          'Lyrics',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'spoti',
                              fontSize: 17.sp),
                        ),
                        Space.verti(4),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}

Widget nextPrevIcon(bool next) {
  final handler = getIt<HandlerManager>(instanceName: 'handllerManner');
  final provider = getIt<MainProvider>(instanceName: providerName);
  return Padding(
    padding: EdgeInsets.only(
      left: next ? 0.w : 29.w,
      right: next ? 29.w : 0.w,
    ),
    child: GestureDetector(
      onTap: () async {
        try {
          if (next) {
            await provider.carouselController
                .nextPage(duration: const Duration(milliseconds: 200));
            await handler.next();
            return;
          }
          await provider.carouselController
              .previousPage(duration: const Duration(milliseconds: 200));
          await handler.prev();
        } catch (e) {
          log('next prev Error $e');
        }
      },
      child: RotatedBox(
        quarterTurns: next ? 2 : 0,
        child: SizedBox(
          height: 30.h,
          width: 30.w,
          child: ImageIcon(
              const AssetImage(
                'assets/icons/spoti_next.png',
              ),
              color: Colors.white,
              size: 26.sp),
        ),
      ),
    ),
  );
}

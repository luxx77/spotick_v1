import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/widgets/song_image_widget.dart';

class SliderCarousel extends StatefulWidget {
  const SliderCarousel({super.key});

  @override
  State<SliderCarousel> createState() => _SliderCarouselState();
}

class _SliderCarouselState extends State<SliderCarousel> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider.inCurrentSongScreen = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    provider.inCurrentSongScreen = false;
  }

  final provider = getIt<MainProvider>(instanceName: providerName);
  final handMannager = getIt<HandlerManager>(instanceName: 'handllerManner');
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: provider.carouselController,
      options: CarouselOptions(
        height: 370.h,
        initialPage: provider.currentIndex,
        enableInfiniteScroll: true,
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        onPageChanged: (index, reason) async {
          try {
            log('${reason.name} reason name');
            if (reason.name == 'manual') {
              await handMannager.playAtIndex(index);
              return;
            }
          } catch (e) {
            log('Carousell Erro change $e');
          }
        },
      ),
      itemCount: provider.currentPlayList.length,
      itemBuilder: (context, index, realIndex) {
        return SongImageWidget(
          id: provider.currentPlayList[index].id,
          height: 370.h,
          width: 335.w,
        );
      },
    );
  }
}

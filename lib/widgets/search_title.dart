import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class SearchTTitle extends StatelessWidget {
  const SearchTTitle({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.id,
  }) : super(key: key);
  final List<String>? title;
  final int id;
  final String? subTitle;

  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _provider.currentSong,
        builder: (context, song, child) {
          log('RichBuild');
          final isSelected = _provider.currentSong.value.id == id;
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'spoti',
                        fontSize: 15.sp,
                        color: isSelected ? selectedColor : Colors.white,
                      ),
                      children: [
                        TextSpan(text: title![0]),
                        TextSpan(
                            text: title![1],
                            style: TextStyle(color: selectedColor)),
                        TextSpan(
                          text: title![2],
                        ),
                      ]),
                ),
                Text(
                  '${subTitle != null && subTitle != '<unknown>' ? subTitle : 'SubNull'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'spoti',
                    fontSize: 13.sp,
                    color: isSelected
                        ? selectedColor
                        : Color.fromARGB(255, 190, 183, 183),
                  ),
                )
              ]);
        });
  }
}

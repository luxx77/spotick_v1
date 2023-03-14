import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class RichTitleText extends StatelessWidget {
  const RichTitleText({
    Key? key,
    required this.size,
    required this.title,
    required this.subTitle,
    required this.id,
  }) : super(key: key);
  final double size;
  final String title;
  final String subTitle;
  final int id;

  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    final isSelected = _provider.currentSong.value.id == id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'spoti',
            fontSize: size.sp,
            color: isSelected ? selectedColor : Colors.white,
          ),
        ),
        Text(
          subTitle != '<unknown>' ? subTitle : 'SubNull',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'spoti',
            fontSize: size - 2.sp,
            color:
                isSelected ? selectedColor : Color.fromARGB(255, 190, 183, 183),
          ),
        )
      ],
    );
  }
}

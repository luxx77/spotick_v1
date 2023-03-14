import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class SongImageWidget extends StatelessWidget {
  const SongImageWidget({super.key, this.height, this.id, this.width});
  final double? height;
  final double? width;
  final int? id;
  static final _defPath = getIt<String>(instanceName: 'defImagePath');
  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 0,
      width: width ?? 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          height == null
              ? 30.r
              : height == 45.sp
                  ? 8.5.r
                  : height! < 60.h
                      ? 10.r
                      : 30.r,
        ),
        child: Image.file(
          File(_provider.songArtworks[id]!),
          errorBuilder: (context, error, stackTrace) => Image.file(
            fit: BoxFit.cover,
            File(_defPath),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

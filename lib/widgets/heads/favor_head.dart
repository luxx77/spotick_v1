import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/constants/image_pathes.dart';

import '../../configs/space.dart';
import '../../constants/colors.dart';

class FavorHead extends StatelessWidget {
  const FavorHead({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h),
      child: Row(children: [
        ImageIcon(
          AssetImage(navBarIconPathes[1]),
          color: selectedColor,
          size: 60.sp,
        ),
        Space.hori(13),
        Expanded(
          child: Text(
            'Listen lovely your favorite songs ❤️',
            style: TextStyle(
              fontFamily: 'spoti',
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}

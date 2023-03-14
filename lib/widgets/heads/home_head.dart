import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/configs/space.dart';
import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/constants/text_styles.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

import '../build/top_product_builder.dart';

class HomeHead extends StatelessWidget {
  const HomeHead({super.key});
  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 15.h,
          color: scaffoldBackGround,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 28.w,
          ),
          child: Text('# Top played 10', style: mainTextStyle),
        ),
        TopBuilder(
          songs: List.generate(10, (index) => _provider.allSongs![index]),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28.w,
            // top: 0.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('All songs', style: mainTextStyle),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.sort_by_alpha_rounded,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                    Space.hori(5),
                    Icon(
                      Icons.sort,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
        Space.verti(15),
      ],
    );
  }
}

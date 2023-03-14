import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:spoti_player_1_2/widgets/top_product_widget.dart';

class TopBuilder extends StatelessWidget {
  const TopBuilder({super.key, required this.songs});
  final List<SongModel> songs;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      height: 215.4.h,
      child: ListView.builder(
        itemCount: 10,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return TopProductWidget(
            index: index,
            song: songs[index],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SongOptionsWidget extends StatelessWidget {
  const SongOptionsWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 35.w,
        height: 36.h,
        alignment: Alignment.center,
        child: ImageIcon(
          const AssetImage(
            'assets/icons/dots.png',
          ),
          color: Colors.white,
          size: 21.sp,
        ),
      ),
    );
  }
}

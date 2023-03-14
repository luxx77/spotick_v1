import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/configs/space.dart';
import 'package:spoti_player_1_2/constants/image_pathes.dart';
import 'package:spoti_player_1_2/screens/search_screen.dart';
import 'package:spoti_player_1_2/widgets/search_field.dart';

AppBar mainAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Color.fromARGB(255, 17, 16, 16),
    centerTitle: true,
    toolbarHeight: 48.h,
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
        child: Container(
          width: 40.w,
          // height: 20.h,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 5.w),
          
          child: const ImageIcon(
            AssetImage(
              searchPath,
            ),
          ),
        ),
      ),
      Space.hori(7),
    ],
    title: const Text(
      'Spoti Player',
      style: TextStyle(
        fontFamily: 'spoti',
      ),
    ),
  );
}

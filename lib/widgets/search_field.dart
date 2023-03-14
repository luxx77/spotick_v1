import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _provider = getIt<MainProvider>(instanceName: providerName);
  final searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.text = _provider.searchQuery.value;
    _provider.searchFocus.requestFocus();
    searchController.addListener(() {
      _provider.searchQuery.value = searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    log('Field Build');
    return SizedBox(
      height: 44.h,
      width: 300.w,
      child: TextField(
        scrollPadding: EdgeInsets.zero,
        maxLines: 1,
        controller: searchController,
        focusNode: _provider.searchFocus,
        autocorrect: false,
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        style: TextStyle(
          fontFamily: 'spoti',
          color: Colors.white,
          fontSize: 18.sp,
        ),
        cursorColor: selectedColor,
        decoration: InputDecoration(
          hintText: ' Search?🤨',
          hintStyle: TextStyle(
            fontFamily: 'spoti',
            color: Colors.white,
            fontSize: 19.sp,
          ),
          contentPadding: EdgeInsets.only(bottom: 6.5.h, left: 8.w),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: selectedColor,
              width: 1.5.sp,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: selectedColor,
              width: 1.5.sp,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: selectedColor,
              width: 1.5.sp,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Space {
  Space();

  static Widget custom(double width, double height) {
    return SizedBox(
      height: height.h,
      width: width.h,
    );
  }

  static Widget hori(double width) {
    return SizedBox(
      width: width.w,
    );
  }

  static Widget verti(double height) {
    return SizedBox(
      height: height.h,
    );
  }

  static Widget symmetric(double size) {
    return SizedBox(
      width: size.w,
      height: size.h,
    );
  }

  static Widget padTop(double size, Widget child) {
    return Padding(
      padding: EdgeInsets.only(top: size.h),
      child: child,
    );
  }

  static Widget padBottom(double size, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.h),
      child: child,
    );
  }

  static Widget padLeft(double size, Widget child) {
    return Padding(
      padding: EdgeInsets.only(left: size.w),
      child: child,
    );
  }

  static Widget padRight(double size, Widget child) {
    return Padding(
        padding: EdgeInsets.only(
          right: size.h,
        ),
        child: child);
  }

  static Widget padSymmetrix(double width, double height, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height.h, horizontal: width.w),
      child: child,
    );
  }

  static Widget padAll(double size, Widget child) {
    return Padding(
      padding: EdgeInsets.all(size.sp),
      child: child,
    );
  }
}

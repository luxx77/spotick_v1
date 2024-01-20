import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/Futures/futures.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class FavorsButton extends StatefulWidget {
  const FavorsButton({super.key});

  @override
  State<FavorsButton> createState() => _FavorsButtonState();
}

class _FavorsButtonState extends State<FavorsButton> {
  final _futures = getIt<Futures>(instanceName: 'futures');
  final _provider = getIt<MainProvider>(instanceName: 'provider');
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _provider.currentSong,
        builder: (context, value, child) {
          return ValueListenableBuilder(
            valueListenable: _provider.favorChanges,
            builder: (context, value, child) {
              final exist = _futures.existInFavor();
              return GestureDetector(
                onTap: () async {
                  _futures.addOrRemoveFavors();
                  setState(() {});
                },
                child: ImageIcon(
                  AssetImage(
                    exist
                        ? 'assets/icons/favorFilled.png'
                        : 'assets/icons/favor.png',
                  ),
                  size: 25.sp,
                  color: Colors.white,
                ),
              );
            },
          );
        });
  }
}

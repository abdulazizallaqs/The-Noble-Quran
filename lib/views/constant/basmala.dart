import 'package:flutter/material.dart';
import 'package:hafzon/core/color_manager.dart';

class ReturnBasmalah extends StatelessWidget {
  const ReturnBasmalah({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Image.asset('assets/basmalah.png',
            height: 100, color: ColorManager.basmalh),
      ]),
    );
  }
}

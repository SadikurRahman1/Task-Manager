import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/assets_path.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    // return Stack(
    //   children: [
    //     SvgPicture.asset(
    //       AssetsPath.backgroundSvg,
    //       fit: BoxFit.cover,
    //       height: mediaQuery.height,
    //       width: mediaQuery.width,
    //     ),
    //     SafeArea(child: child),
    //   ],
    // );
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
            children: [
              SvgPicture.asset(
                AssetsPath.backgroundSvg,
                fit: BoxFit.cover,
                height: mediaQuery.height,
                width: mediaQuery.width,
              ),
              SafeArea(child: child),
            ],
          ),
      ),
    );
  }
}
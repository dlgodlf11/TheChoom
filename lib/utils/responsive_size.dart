import 'package:flutter/material.dart';

class Screen {
  Size screenSize;
  double textscalefactor;
  double textscale;
  Screen._internal();
  Screen(this.screenSize, this.textscalefactor) {
    textscale = 1 / textscalefactor;
  }
  double wp(percentage) {
    return percentage / 100 * screenSize.width;
  }

  double hp(percentage) {
    return percentage / 100 * screenSize.height;
  }

  double getWidthPx(int pixels) {
    return (pixels / 3.61) / 100 * screenSize.width;
  }

  double getHeightPx(int pixels) {
    return (pixels / 3.61) / 100 * screenSize.height;
  }
}

import 'package:flutter/material.dart';

class BrightnessObserver {
  final Function(Brightness brightness) onBrightnessChanged;

  BrightnessObserver({required this.onBrightnessChanged});

  void handleSystemBrightnessChange() {
    final Brightness currentSystemBrightness = MediaQuery.platformBrightnessOf(WidgetsBinding.instance.buildOwner as BuildContext);
    onBrightnessChanged(currentSystemBrightness);
  }
}
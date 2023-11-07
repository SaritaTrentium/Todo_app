import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = 3; // Unique ID for the adapter

  @override
  ThemeMode read(BinaryReader reader) {
    final themeModeString = reader.readString();
    return themeModeString == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.writeString(obj.toString());
  }
}
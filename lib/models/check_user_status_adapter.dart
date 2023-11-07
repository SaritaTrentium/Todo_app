import 'package:hive_flutter/hive_flutter.dart';

class CheckUserStatusAdapter extends TypeAdapter<bool> {
  @override
  final int typeId = 2; // Unique ID for the adapter

  @override
  bool read(BinaryReader reader) {
    return reader.readBool();
  }

  @override
  void write(BinaryWriter writer, bool obj) {
    writer.writeBool(obj);
  }
}
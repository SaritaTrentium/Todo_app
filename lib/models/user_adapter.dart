import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/user_model.dart';

class UserAdapter extends TypeAdapter<Users> {
  @override
  final int typeId = 1; // Use the same typeId as in @HiveType

  @override
  Users read(BinaryReader reader) {
    return Users(
      userId: reader.readString(),
      email: reader.readString(),
      password: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Users obj) {
    writer.writeString(obj.userId);
    writer.writeString(obj.email);
    writer.writeString(obj.password);
  }
}


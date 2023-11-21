import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 0; // Unique identifier for the type

  @override
  Todo read(BinaryReader reader) {
    // Implement how to read the Todo object from binary
    // Adjust this based on the actual structure of your Todo class
    return Todo(
      id: reader.readInt(), // Assuming there is a method like readString for String properties
      title: reader.readString(),
      desc: reader.readString(),
      deadline: reader.read(), // Adjust this based on the actual type of your deadline property
      isCompleted: reader.readBool(), // Handle nullability
      userId: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    // Implement how to write the Todo object to binary
    // Adjust this based on the actual structure of your Todo class
   // writer.writeString(obj.id); // Replace with the actual property used to identify Todo
    writer.writeString(obj.title);
    writer.writeString(obj.desc);
    writer.write(obj.deadline); // Adjust this based on the actual type of your deadline property
    writer.writeBool(obj.isCompleted ?? false); // Handle nullability
    writer.writeString(obj.userId);
  }
}

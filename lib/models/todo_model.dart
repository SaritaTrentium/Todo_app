import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject{
  @HiveField(0)
  final String title;
  
  @HiveField(1)
  final String desc;

  @HiveField(2)
  DateTime? deadline;
  
  @HiveField(3)
  bool? isCompleted;

  @HiveField(4)
  final String userId;

  Todo({required this.title, required this.desc,required this.deadline , this.isCompleted = false, required this.userId});
}
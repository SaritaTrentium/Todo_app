import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class Todo extends HiveObject{
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String desc;

  @HiveField(3)
  DateTime? deadline;
  
  @HiveField(4)
  bool? isCompleted;

  @HiveField(5)
  final String userId;

  Todo({required this.id, required this.title, required this.desc,required this.deadline , this.isCompleted = false, required this.userId});
}
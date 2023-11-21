import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Users extends HiveObject{

  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  Users({required this.userId, required this.email, required this.password});
}
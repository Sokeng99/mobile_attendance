import 'package:isar/isar.dart';

part 'user_collection.g.dart';

@Collection()
class UserCollection {
  Id id = Isar.autoIncrement;

  String? userId;
  String? name;
  DateTime? registeredAt;

}

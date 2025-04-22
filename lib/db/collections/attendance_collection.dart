import 'package:isar/isar.dart';

part 'attendance_collection.g.dart';

@Collection()
class AttendanceCollection {
  Id id = Isar.autoIncrement;
  int? userId;
  String? userName;
  DateTime?checkInTime;
  String? status;
}

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mobile_attendance/db/collections/attendance_collection.dart';
import 'package:mobile_attendance/db/collections/user_collection.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../models/attendance.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService _instance = DatabaseService._();
  static DatabaseService get instance => _instance;
  factory DatabaseService() => _instance;
  late Future<Isar> db;

  Future<DatabaseService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = openIsar(directory: dir.path);
    return this;
  }

  Future<Isar> openIsar({required String directory}) async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [UserCollectionSchema, AttendanceCollectionSchema],
        inspector: true,
        directory: directory,
      );
    }

    return Future.value(Isar.getInstance());
  }

  // User Methods
  Future<UserModel?> getUserById(int userId) async {
    try {
      final isar = await db;
      final user = await isar.userCollections.get(userId);
      return UserModel(
        userId: user?.id,
        name: user?.name,
        registeredAt: user?.registeredAt,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final isar = await db;
      final users = await isar.userCollections.where().findAll();
      return users.map((e) => UserModel(
        userId: e.id,
        name: e.name,
        registeredAt: e.registeredAt,
      )).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveUser(UserModel user) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.userCollections.put(user.toUserCollection);
    });
  }

  // Attendance Methods
  Future<void> recordAttendance(AttendanceModel attendance) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.attendanceCollections.put(attendance.toAttendanceCollection);
    });
  }

  Future<bool> hasUserCheckedInToday(int userId) async {
    final isar = await db;
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    final nextDay = date.add(const Duration(days: 1));
    
    final attendance = await isar.attendanceCollections
        .filter()
        .userIdEqualTo(userId)
        .and()
        .checkInTimeBetween(date, nextDay)
        .findFirst();
    
    return attendance != null;
  }

  Future<List<AttendanceModel>> getAttendanceRecords() async {
    final isar = await db;
    final attendances = await isar.attendanceCollections
        .where()
        .sortByCheckInTimeDesc()
        .findAll();
    return attendances.map((e) => AttendanceModel(
      userId: e.userId,
      userName: e.userName,
      checkInTime: e.checkInTime,
    )).toList();
  }

  Future<List<AttendanceModel>> getAttendanceByDate(DateTime date) async {
    final isar = await db;
    final nextDay = DateTime(date.year, date.month, date.day + 1);
    
    final attendances = await isar.attendanceCollections
        .filter()
        .checkInTimeBetween(
          DateTime(date.year, date.month, date.day),
          nextDay,
        )
        .findAll();
    return attendances.map((e) => AttendanceModel(
      userId: e.userId,
      userName: e.userName,
      checkInTime: e.checkInTime,
    )).toList();
  }
}
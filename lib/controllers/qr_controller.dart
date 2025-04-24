import 'dart:convert';
import 'package:get/get.dart';
import '../models/attendance.dart';
import '../db/database_service.dart';

class QrController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final scanSuccess = false.obs;
  final scannedUserId = ''.obs;
  final scannedUserName = ''.obs;

  // Generate QR data from user info
  String generateQrData(String userId, String name) {
    final data = {
      'userId': userId,
      'name': name,
      'timestamp': DateTime.now().toIso8601String(),
    };

    return jsonEncode(data);
  }

  // Parse QR data and record attendance
  Future<bool> processScannedQrCode(String qrData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      scanSuccess.value = false;

      // Parse the QR data
      final Map<String, dynamic> data = jsonDecode(qrData);
      final userId = data['userId'];
      final name = data['name'];

      if (userId == null || name == null) {
        errorMessage.value = 'Invalid QR code data';
        return false;
      }

      // Convert userId to integer since AttendanceModel expects an int
      int? userIdInt;
      try {
        userIdInt = int.parse(userId.toString());
      } catch (e) {
        errorMessage.value = 'Invalid user ID format';
        return false;
      }

      scannedUserId.value = userId.toString();
      scannedUserName.value = name;

      // Check if user has already checked in today
      final hasCheckedIn = await _db.hasUserCheckedInToday(userIdInt);
      if (hasCheckedIn) {
        errorMessage.value = 'User has already checked in today';
        return false;
      }

      // Record attendance
      final attendance = AttendanceModel(
          userId: userIdInt,
          userName: name,
          checkInTime: DateTime.now(),
          status: 'present');

      await _db.recordAttendance(attendance);
      scanSuccess.value = true;
      return true;
    } catch (e) {
      errorMessage.value = 'Error processing QR code: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<AttendanceModel>> getAttendanceRecords() async {
    return await _db.getAttendanceRecords();
  }

  void clearScanData() {
    scanSuccess.value = false;
    scannedUserId.value = '';
    scannedUserName.value = '';
    errorMessage.value = '';
  }
}

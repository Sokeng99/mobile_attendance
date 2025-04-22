import 'package:get/get.dart';
import '../views/home_view.dart';
import '../views/register_view.dart';
import '../views/qr_code_view.dart';
import '../views/qr_scanner_view.dart';
import '../views/attendance_list_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String register = '/register';
  static const String qrCode = '/qr-code';
  static const String qrScanner = '/qr-scanner';
  static const String attendanceList = '/attendance-list';
  
  static List<GetPage> getPages = [
    GetPage(
      name: home,
      page: () => const HomeView(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: qrCode,
      page: () => const QrCodeView(),
    ),
    GetPage(
      name: qrScanner,
      page: () => const QrScannerView(),
    ),
    GetPage(
      name: attendanceList,
      page: () => const AttendanceListView(),
    ),
  ];
} 
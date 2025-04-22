import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/qr_controller.dart';
import '../db/database_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize database service
    Get.putAsync<DatabaseService>(() async {
      final dbService = DatabaseService();
      return await dbService.init();
    }, permanent: true);
    
    // Register controllers
    Get.lazyPut<UserController>(() => UserController(), fenix: true);
    Get.lazyPut<QrController>(() => QrController(), fenix: true);
  }
} 
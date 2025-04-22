import 'package:get/get.dart';
import '../models/user.dart';
import '../db/database_service.dart';

class UserController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  
  final userId = ''.obs;
  final name = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  void setUserId(String value) => userId.value = value;
  void setName(String value) => name.value = value;
  
  Future<bool> registerUser() async {
    if (!validateInputs()) return false;
    
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userIdint = int.tryParse(userId.value);
      if (userIdint == null) {
        errorMessage.value = 'Invalid User ID';
        return false;
      }
      
      // Check if user with this ID already exists
      // final existingUser = await _db.getUserById(userIdint);
      // if (existingUser != null) {
      //   errorMessage.value = 'User ID already exists';
      //   return false;
      // }
      
      // Create and save new user
      final user = UserModel(
        // userId: userIdint,
        name: name.value,
      );
      
      await _db.saveUser(user);
      return true;
    } catch (e) {
      errorMessage.value = 'Error registering user: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  bool validateInputs() {
    if (userId.value.isEmpty) {
      errorMessage.value = 'User ID cannot be empty';
      return false;
    }
    
    if (name.value.isEmpty) {
      errorMessage.value = 'Name cannot be empty';
      return false;
    }
    
    return true;
  }
  
  Future<List<UserModel>> getAllUsers() async {
    return await _db.getAllUsers();
  }
  
  void clearForm() {
    userId.value = '';
    name.value = '';
    errorMessage.value = '';
  }
} 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../routes/app_routes.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();
    controller.clearForm();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register User'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form fields
              TextField(
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  hintText: 'Enter your ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                onChanged: controller.setUserId,
                enabled: !controller.isLoading.value,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: controller.setName,
                enabled: !controller.isLoading.value,
              ),
              
              // Error message
              if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              
              const Spacer(),
              
              // Register button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (await controller.registerUser()) {
                            // Navigate to QR code view
                            Get.toNamed(
                              AppRoutes.qrCode,
                              arguments: {
                                'userId': controller.userId.value,
                                'name': controller.name.value,
                              },
                            );
                          }
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Register & Generate QR',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
} 
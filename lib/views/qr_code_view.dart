import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/qr_controller.dart';
import '../routes/app_routes.dart';

class QrCodeView extends StatelessWidget {
  const QrCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QrController controller = Get.find<QrController>();
    
    // Get user data from arguments
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String userId = args['userId'] ?? '';
    final String name = args['name'] ?? '';
    
    if (userId.isEmpty || name.isEmpty) {
      // If no data, redirect back to register page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(AppRoutes.register);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    // Generate QR code data
    final String qrData = controller.generateQrData(userId, name);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your QR Code has been generated',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Center(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 250,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'User ID: $userId',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Name: $name',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.home),
                    label: const Text('Home'),
                    onPressed: () => Get.offAllNamed(AppRoutes.home),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan QR'),
                    onPressed: () => Get.offNamed(AppRoutes.qrScanner),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 
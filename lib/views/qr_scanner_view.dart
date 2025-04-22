import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/qr_controller.dart';
import '../routes/app_routes.dart';

class QrScannerView extends StatefulWidget {
  const QrScannerView({Key? key}) : super(key: key);

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool cameraPermissionGranted = false;
  bool processingCode = false;
  final QrController qrController = Get.find<QrController>();
  
  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    qrController.clearScanData();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      cameraPermissionGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 2,
            child: Obx(() {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (qrController.isLoading.value)
                      const CircularProgressIndicator()
                    else if (qrController.scanSuccess.value)
                      _buildSuccessMessage()
                    else if (qrController.errorMessage.value.isNotEmpty)
                      _buildErrorMessage()
                    else
                      const Text(
                        'Scan a QR code to record attendance',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.flash_on),
                          onPressed: () async {
                            await controller?.toggleFlash();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.flip_camera_ios),
                          onPressed: () async {
                            await controller?.flipCamera();
                          },
                        ),
                        ElevatedButton(
                          onPressed: () => Get.offAllNamed(AppRoutes.home),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    if (!cameraPermissionGranted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Camera permission is required to scan QR codes',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestCameraPermission,
              child: const Text('Request Permission'),
            ),
          ],
        ),
      );
    }
    
    // For best appearance, match this width with the size of the camera preview
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).primaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => setState(() {
        cameraPermissionGranted = p;
      }),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (processingCode || qrController.isLoading.value) return;
      setState(() {
        processingCode = true;
      });
      
      result = scanData;
      
      if (result?.code != null) {
        // Pause camera while processing
        controller.pauseCamera();
        
        // Process the QR code data
        await qrController.processScannedQrCode(result!.code!);
        
        // Resume camera if there was an error (to try again)
        if (!qrController.scanSuccess.value) {
          controller.resumeCamera();
        }
      }
      
      setState(() {
        processingCode = false;
      });
    });
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,
        ),
        const SizedBox(height: 8),
        Text(
          'Successfully recorded attendance for ${qrController.scannedUserName.value}',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Column(
      children: [
        const Icon(
          Icons.error,
          color: Colors.red,
          size: 36,
        ),
        const SizedBox(height: 8),
        Text(
          qrController.errorMessage.value,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
} 
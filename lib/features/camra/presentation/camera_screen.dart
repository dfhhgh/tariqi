import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/features/camra/presentation/camera_confirm.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;

  double minZoom = 1.0;
  double maxZoom = 1.0;
  double currentZoom = 1.0;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isEmpty) return;

      controller = CameraController(
        cameras![0],
        ResolutionPreset.high,
      );

      await controller!.initialize();

      minZoom = await controller!.getMinZoomLevel();
      maxZoom = await controller!.getMaxZoomLevel();

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> takePhoto() async {
    if (controller == null || !controller!.value.isInitialized) return;

    try {
      final photo = await controller!.takePicture();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PhotoConfirmScreen(imagePath: photo.path),
        ),
      );
    } catch (e) {
      debugPrint('Error taking photo: $e');
    }
  }

  Future<void> pickFromGallery() async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null || !mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PhotoConfirmScreen(imagePath: picked.path),
        ),
      );
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> setZoom(double value) async {
    if (controller == null || !controller!.value.isInitialized) return;
    await controller!.setZoomLevel(value);
    if (!mounted) return;
    setState(() => currentZoom = value);
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: Slider(
              value: currentZoom,
              min: minZoom,
              max: maxZoom,
              activeColor: Colors.white,
              inactiveColor: Colors.white38,
              onChanged: (value) => setZoom(value),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo, size: 35),
                  color: Colors.white,
                  onPressed: pickFromGallery,
                ),
                GestureDetector(
                  onTap: takePhoto,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.white24,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
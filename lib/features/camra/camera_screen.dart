// TODO Implement this library.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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

  XFile? image;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future initCamera() async {
    cameras = await availableCameras();

    controller = CameraController(
      cameras![0],
      ResolutionPreset.high,
    );

    await controller!.initialize();

    minZoom = await controller!.getMinZoomLevel();
    maxZoom = await controller!.getMaxZoomLevel();

    setState(() {});
  }

  // 📷 التقاط صورة
  Future takePhoto() async {
    if (!controller!.value.isInitialized) return;

    final photo = await controller!.takePicture();

    setState(() {
      image = photo;
    });
  }

  // 🖼️ اختيار صورة من المعرض
  Future pickFromGallery() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {
      setState(() {
        image = picked;
      });
    }
  }

  // 🔍 التحكم في الزوم
  Future setZoom(double value) async {
    await controller!.setZoomLevel(value);

    setState(() {
      currentZoom = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),

          // Slider للزوم
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: Slider(
              value: currentZoom,
              min: minZoom,
              max: maxZoom,
              onChanged: (value) {
                setZoom(value);
              },
            ),
          ),

          // الأزرار
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // المعرض
                IconButton(
                  icon: const Icon(Icons.photo, size: 35),
                  color: Colors.white,
                  onPressed: pickFromGallery,
                ),

                // التصوير
                FloatingActionButton(
                  onPressed: takePhoto,
                  child: const Icon(Icons.camera),
                ),

                // عرض الصورة
                image != null
                    ? Image.file(
                        File(image!.path),
                        width: 50,
                        height: 50,
                      )
                    : const SizedBox(width: 50)
              ],
            ),
          )
        ],
      ),
    );
  }
}

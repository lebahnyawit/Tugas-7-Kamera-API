import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../previewscreen/preview_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  int selectedCameraIdx = 0;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    availableCameras()
        .then((availableCameras) {
          cameras = availableCameras;
          if (cameras!.isNotEmpty) {
            setState(() {
              selectedCameraIdx = 0;
            });
            _initCameraController(cameras![selectedCameraIdx]);
          }
        })
        .catchError((err) {
          print('Error: $err.code\nError Message: $err.message');
        });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx < cameras!.length - 1
        ? selectedCameraIdx + 1
        : 0;
    CameraDescription selectedCamera = cameras![selectedCameraIdx];
    _initCameraController(selectedCamera);
  }

  void _onCapturePressed(context) async {
    try {
      final image = await controller!.takePicture();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Click To Share'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(child: Container(child: CameraPreview(controller!))),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: _onSwitchCamera,
                  icon: Icon(
                    _getCameraLensIcon(
                      cameras![selectedCameraIdx].lensDirection,
                    ),
                  ),
                  label: const Text("Switch"),
                ),
                FloatingActionButton(
                  onPressed: () => _onCapturePressed(context),
                  backgroundColor: Colors.blueGrey,
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

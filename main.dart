import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  availableCameras().then((cameras) {
    runApp(MyApp(cameras: cameras));
  });
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(cameras: cameras),
    );
  }
}

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller; // nullable, tidak perlu 'late'
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  void _startCamera() {
    _controller = CameraController(widget.cameras.first, ResolutionPreset.high);
    _controller!.initialize().then((_) {
      if (mounted) setState(() => _isReady = true);
    });
  }

  void _capture() {
    _controller!.takePicture().then((XFile image) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PreviewPage(imagePath: image.path)),
      );
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
        backgroundColor: Colors.blueGrey,
      ),
      body: CameraPreview(_controller!),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _capture,
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.camera_alt, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PreviewPage extends StatelessWidget {
  final String imagePath;
  const PreviewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(child: Image.file(File(imagePath), fit: BoxFit.contain)),
    );
  }
}

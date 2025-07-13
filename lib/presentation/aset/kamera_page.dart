import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class KameraPage extends StatefulWidget {
  final Function(File) onPictureTaken;

  const KameraPage({super.key, required this.onPictureTaken});

  @override
  State<KameraPage> createState() => _KameraPageState();
}

class _KameraPageState extends State<KameraPage> {
  late CameraController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();

    if (!mounted) return;
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ambilFoto() async {
    final directory = await getTemporaryDirectory();
    final xFile = await _controller.takePicture();
    final foto = File(xFile.path);

    widget.onPictureTaken(foto);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ambil Foto"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isInitialized
          ? Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  bottom: 30,
                  left: MediaQuery.of(context).size.width / 2 - 30,
                  child: FloatingActionButton(
                    onPressed: _ambilFoto,
                    child: Icon(Icons.camera),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

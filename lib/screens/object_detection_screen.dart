import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  CameraController? _cameraController;
  List<dynamic>? _detections;
  bool _isBusy = false;
  bool _isModelLoaded = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (!mounted) return;

    _cameraController!.startImageStream((image) {
      if (_isBusy) return;
      _isBusy = true;
      _detectObjects(image);
    });

    setState(() {});
  }

  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/models/detect.tflite",
        labels: "assets/models/labelmap.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      developer.log('Erreur lors du chargement du modèle', error: e);
    }
  }

  Future<void> _detectObjects(CameraImage image) async {
    if (!_isModelLoaded) return;

    try {
      final detections = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        model: "SSDMobileNet",
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResultsPerClass: 1,
        threshold: 0.4,
      );

      setState(() {
        _detections = detections;
      });
    } catch (e) {
      developer.log('Erreur lors de la détection', error: e);
    } finally {
      _isBusy = false;
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _isBusy = true;
    });

    try {
      final detections = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "SSDMobileNet",
        threshold: 0.4,
        imageMean: 127.5,
        imageStd: 127.5,
        numResultsPerClass: 1,
      );

      setState(() {
        _detections = detections;
      });
    } catch (e) {
      developer.log('Erreur lors de la détection sur image', error: e);
    } finally {
      _isBusy = false;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détection d\'objets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          if (_detections != null)
            CustomPaint(
              painter: BoundingBoxPainter(
                detections: _detections!,
                imageSize: Size(
                  _cameraController!.value.previewSize!.height,
                  _cameraController!.value.previewSize!.width,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<dynamic> detections;
  final Size imageSize;

  BoundingBoxPainter({
    required this.detections,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var detection in detections) {
      final rect = detection['rect'];
      final confidence = detection['confidence'];
      final label = detection['detectedClass'];

      final left = rect['x'] * size.width;
      final top = rect['y'] * size.height;
      final right = (rect['x'] + rect['w']) * size.width;
      final bottom = (rect['y'] + rect['h']) * size.height;

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );

      textPainter.text = TextSpan(
        text: '$label ${(confidence * 100).toStringAsFixed(1)}%',
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(left, top - textPainter.height));
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) => true;
}

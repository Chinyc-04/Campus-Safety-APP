import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'visitor_form_page.dart';
import 'student_form_page.dart';
import 'admin_form_page.dart';

// ...Paste your GateOCRPage and _GateOCRPageState code here...
class GateOCRPage extends StatefulWidget {
  final CameraDescription camera;
  const GateOCRPage({super.key, required this.camera});
  @override
  State<GateOCRPage> createState() => _GateOCRPageState();
}

class _GateOCRPageState extends State<GateOCRPage> {
  late CameraController _controller;
  late Future<void> _initFuture;
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  bool _isProcessing = false;
  String _lastResult = '';
  DateTime _lastRun = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _initFuture = _controller.initialize().then((_) {
      _controller.startImageStream(_processFrame);
    });
  }

  Future<void> _processFrame(CameraImage img) async {
    if (_isProcessing ||
        DateTime.now().difference(_lastRun).inMilliseconds < 200) {
      return;
    }
    _isProcessing = true;
    _lastRun = DateTime.now();

    try {
      final inputImage = _toInputImage(
        img,
        _controller.description.sensorOrientation,
      );
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final allText = recognizedText.text.replaceAll('\n', ' ').trim();
      final plate = _maybePlate(allText);
      final studentId = _maybeStudentId(allText);

      if (plate != null || studentId != null) {
        setState(() {
          _lastResult =
              'Plate: ${plate ?? "-"} | StudentID: ${studentId ?? "-"}';
        });
      }
    } catch (_) {
      // handle/log
    } finally {
      _isProcessing = false;
    }
  }

  InputImage _toInputImage(CameraImage img, int rotation) {
    // For Android (YUV), combine planes; for iOS (BGRA), use first plane
    final bytes = Platform.isAndroid
        ? Uint8List.fromList(
            img.planes.fold<List<int>>([], (prev, p) => prev..addAll(p.bytes)),
          )
        : Uint8List.fromList(img.planes.first.bytes);
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(img.width.toDouble(), img.height.toDouble()),
        rotation: _rotationToImageRotation(rotation),
        format:
            InputImageFormatValue.fromRawValue(img.format.raw) ??
            InputImageFormat.nv21,
        bytesPerRow: img.planes.first.bytesPerRow,
      ),
    );
  }

  InputImageRotation _rotationToImageRotation(int r) {
    switch (r) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  final _plateRegex = RegExp(r'^[A-Z]{1,3}\s?\d{1,4}[A-Z]?$');
  String? _maybePlate(String text) {
    for (final token in text.split(RegExp(r'\s+'))) {
      final t = token.replaceAll(RegExp(r'[^A-Z0-9]'), '');
      if (t.length >= 4 && t.length <= 8 && _plateRegex.hasMatch(t)) return t;
    }
    return null;
  }

  final _studentRegex = RegExp(
    r'(MMU|UTM|UKM|UM)[-_ ]?\d{6,10}',
    caseSensitive: false,
  );
  String? _maybeStudentId(String text) {
    final match = _studentRegex.firstMatch(text);
    return match?.group(0);
  }

  @override
  void dispose() {
    // Stop image stream before disposing
    if (_controller.value.isStreamingImages) {
      _controller.stopImageStream();
    }
    _controller.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gate OCR (PoC)'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Visitor'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VisitorFormPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Student'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentFormPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminFormPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _initFuture,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              CameraPreview(_controller),
              Positioned(
                left: 16,
                right: 16,
                bottom: 32,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _lastResult.isEmpty ? 'Scanning…' : _lastResult,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 260,
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

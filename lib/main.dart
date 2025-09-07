import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// OCR
import 'screens/gate_ocr_page.dart';

// SOS
import 'pages/setup_page.dart';
import 'pages/demo_page.dart';
import 'services/sos_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<CameraDescription> cameras = [];
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Camera error: $e');
  }

  runApp(CodenectionApp(cameras: cameras));
}

class CodenectionApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const CodenectionApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codenection 2025',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: MainScreen(cameras: cameras),
    );
  }
}

class MainScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MainScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final SOSService _sosService = SOSService();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _setupKeyboardListener();

    // Initialize pages
    _pages = [
      HomeScreen(cameras: widget.cameras), // OCR section
      SetupPage(), // SOS setup
      DemoPage(), // SOS demo
    ];
  }

  void _setupKeyboardListener() {
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Example: Trigger SOS on Escape key (simulate hardware button)
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _sosService.triggerSOS(context);
      }
    }
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'OCR'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'SOS Setup',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'SOS Demo'),
        ],
      ),
    );
  }
}

/// OCR Home screen
class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('OCR Feature Loaded'),
            Text('${cameras.length} cameras found'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cameras.isNotEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GateOCRPage(camera: cameras.first),
                        ),
                      );
                    }
                  : null,
              child: const Text('Open Gate OCR'),
            ),
          ],
        ),
      ),
    );
  }
}

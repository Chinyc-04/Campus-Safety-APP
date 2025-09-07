import 'package:flutter/material.dart';
import '../services/location_service.dart';

class SafeWalkScreen extends StatefulWidget {
  const SafeWalkScreen({super.key});

  @override
  State<SafeWalkScreen> createState() => _SafeWalkScreenState();
}

class _SafeWalkScreenState extends State<SafeWalkScreen> {
  bool _isWalking = false;
  String _status = 'Not started';

  Future<void> _startSafeWalk() async {
    setState(() {
      _status = 'Starting...';
    });
    try {
      final position = await LocationService().getCurrentLocation();
      await FirestoreService().addSession({
        'userId': 'student123', // Replace with actual user ID
        'startTime': DateTime.now(),
        'location': {'lat': position.latitude, 'lng': position.longitude},
      });
      setState(() {
        _isWalking = true;
        _status = 'Safe Walk started!';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _stopSafeWalk() async {
    setState(() {
      _isWalking = false;
      _status = 'Safe Walk stopped.';
    });
    // Optionally update Firestore to mark session as ended
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safe Walk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            _isWalking
                ? ElevatedButton(
                    onPressed: _stopSafeWalk,
                    child: const Text('Stop Safe Walk'),
                  )
                : ElevatedButton(
                    onPressed: _startSafeWalk,
                    child: const Text('Start Safe Walk'),
                  ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../services/sos_service.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final SOSService _sosService = SOSService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Demo'),
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.warning, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Emergency Trigger',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Press ESC key or button below to trigger SOS',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () => _sosService.triggerSOS(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 24),
              ),
              child: Text(
                'EMERGENCY SOS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            
            SizedBox(height: 32),
            
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. Press ESC key (simulates hardware button)'),
                    Text('2. App gets your location silently'),
                    Text('3. Converts location to Plus Code'),
                    Text('4. Sends SMS to emergency contacts'),
                    Text('5. No sound or screen flash for safety'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

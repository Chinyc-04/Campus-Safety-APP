import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSService {
  Future<void> triggerSOS(BuildContext context) async {
    try {
      // Get user settings
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('user_name') ?? 'Unknown User';
      final contact1 = prefs.getString('contact_1') ?? '';
      final contact2 = prefs.getString('contact_2') ?? '';

      if (contact1.isEmpty && contact2.isEmpty) {
        _showError(context, 'No emergency contacts set up!');
        return;
      }

      // Get location
      final position = await _getCurrentLocation();
      if (position == null) {
        _showError(context, 'Could not get location');
        return;
      }

      // Create simple location format (instead of Plus Code for simplicity)
      final locationString = _formatLocation(position.latitude, position.longitude);
      
      // Get battery (simulated for web)
      final batteryLevel = 75; // Simulated

      // Create SOS message
      final message = 'SOS from $userName. Location: $locationString. Battery: $batteryLevel%. '
                     'Open this link: https://maps.google.com/?q=${position.latitude},${position.longitude}';

      // Simulate SMS sending (in real app, this would use SMS API)
      _simulateSMSSend(context, message, contact1, contact2);

    } catch (e) {
      _showError(context, 'SOS failed: $e');
    }
  }

  String _formatLocation(double lat, double lng) {
    // Simple coordinate formatting
    final latStr = lat.toStringAsFixed(6);
    final lngStr = lng.toStringAsFixed(6);
    return '$latStr, $lngStr';
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      // For web demo, we'll use a simulated location
      // In a real mobile app, this would get actual GPS
      return _getSimulatedLocation();
      
      /* Uncomment this for real location (might not work in web browser):
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      */
    } catch (e) {
      print('Location error: $e');
      return _getSimulatedLocation();
    }
  }

  Position _getSimulatedLocation() {
    // Simulate a location (San Francisco coordinates for demo)
    return Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  void _simulateSMSSend(BuildContext context, String message, String contact1, String contact2) {
    // In a real app, this would send actual SMS
    // For demo, we'll show a dialog
    
    final contacts = [contact1, contact2].where((c) => c.isNotEmpty).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('SOS Sent!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📱 Message sent to: ${contacts.join(', ')}'),
              SizedBox(height: 16),
              Text('📨 Message Content:', 
                style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  message,
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '💡 Recipients can click the Google Maps link to see exact location',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

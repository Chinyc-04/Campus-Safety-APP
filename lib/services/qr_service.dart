class QRService {
  // Generate QR code data (for guard verification)
  String generateGuardQR(String guardId, DateTime timestamp) {
    return '$guardId|${timestamp.toIso8601String()}';
  }

  // Validate scanned QR code
  bool validateGuardQR(String scannedData, String expectedGuardId) {
    return scannedData.startsWith(expectedGuardId);
  }
}

// Generate QR
String qrData = QRService().generateGuardQR('guard123', DateTime.now());

// Define scannedData (example of what you might scan)
String scannedData = 'guard123|2024-12-15T10:30:00.000Z'; // Replace with actual scanned data

// Validate scanned QR
bool isValid = QRService().validateGuardQR(scannedData, 'guard123');
import 'dart:math';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/mock/mock_delays.dart';

/// Fake Scanner Repository
abstract class ScannerRepository {
  Future<Map<String, dynamic>> estimateWastePrice(String category, String imagePath);
  Future<Map<String, dynamic>> uploadWastePhoto(String imagePath, String category);
}

class FakeScannerRepository implements ScannerRepository {
  final _random = Random();

  @override
  Future<Map<String, dynamic>> estimateWastePrice(String category, String imagePath) async {
    await Future.delayed(MockDelays.imageProcessDelay);
    
    final basePrice = MockData.estimatedPrices[category] ?? 5.0;
    final variance = basePrice * (0.8 + _random.nextDouble() * 0.4);
    
    return {
      'estimatedPrice': variance,
      'category': category,
      'confidence': 0.85 + _random.nextDouble() * 0.15,
      'unit': 'per unit',
    };
  }

  @override
  Future<Map<String, dynamic>> uploadWastePhoto(String imagePath, String category) async {
    await Future.delayed(MockDelays.uploadDelay);
    
    if (MockDelays.shouldFail()) {
      throw Exception('Failed to upload photo. Please try again.');
    }

    return {
      'uploadId': 'upload_${DateTime.now().millisecondsSinceEpoch}',
      'imageUrl': imagePath,
      'category': category,
      'uploadedAt': DateTime.now().toIso8601String(),
      'status': 'confirmed',
    };
  }
}

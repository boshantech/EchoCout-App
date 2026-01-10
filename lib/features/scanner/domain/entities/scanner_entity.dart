import 'package:equatable/equatable.dart';

class ScanResult extends Equatable {
  final String wasteType;
  final double estimatedPrice;
  final String unit;
  final String confidence;

  const ScanResult({
    required this.wasteType,
    required this.estimatedPrice,
    required this.unit,
    required this.confidence,
  });

  @override
  List<Object?> get props => [wasteType, estimatedPrice, unit, confidence];
}

class UploadResult extends Equatable {
  final String uploadId;
  final bool success;
  final String message;

  const UploadResult({
    required this.uploadId,
    required this.success,
    required this.message,
  });

  @override
  List<Object?> get props => [uploadId, success, message];
}

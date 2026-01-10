import 'package:equatable/equatable.dart';

class EchoSummaryModel extends Equatable {
  final int totalWasteSold;
  final double totalMoneyEarned;
  final int pendingPickups;
  final DateTime? nextPickupDate;

  const EchoSummaryModel({
    required this.totalWasteSold,
    required this.totalMoneyEarned,
    required this.pendingPickups,
    this.nextPickupDate,
  });

  factory EchoSummaryModel.fromJson(Map<String, dynamic> json) {
    return EchoSummaryModel(
      totalWasteSold: json['totalWasteSold'] as int? ?? 0,
      totalMoneyEarned: (json['totalMoneyEarned'] as num? ?? 0).toDouble(),
      pendingPickups: json['pendingPickups'] as int? ?? 0,
      nextPickupDate: json['nextPickupDate'] != null
          ? DateTime.parse(json['nextPickupDate'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    totalWasteSold,
    totalMoneyEarned,
    pendingPickups,
    nextPickupDate,
  ];
}

class PickupModel extends Equatable {
  final String id;
  final String status;
  final DateTime scheduledDate;
  final String? collectorName;
  final String? collectorPhone;
  final double estimatedAmount;
  final List<String> wasteTypes;

  const PickupModel({
    required this.id,
    required this.status,
    required this.scheduledDate,
    this.collectorName,
    this.collectorPhone,
    required this.estimatedAmount,
    required this.wasteTypes,
  });

  factory PickupModel.fromJson(Map<String, dynamic> json) {
    return PickupModel(
      id: json['id'] as String,
      status: json['status'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      collectorName: json['collectorName'] as String?,
      collectorPhone: json['collectorPhone'] as String?,
      estimatedAmount: (json['estimatedAmount'] as num? ?? 0).toDouble(),
      wasteTypes: List<String>.from(json['wasteTypes'] as List<dynamic>? ?? []),
    );
  }

  @override
  List<Object?> get props => [
    id,
    status,
    scheduledDate,
    collectorName,
    collectorPhone,
    estimatedAmount,
    wasteTypes,
  ];
}

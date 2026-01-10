import 'package:equatable/equatable.dart';

class EchoSummary extends Equatable {
  final int totalWasteSold;
  final double totalMoneyEarned;
  final int pendingPickups;
  final DateTime? nextPickupDate;

  const EchoSummary({
    required this.totalWasteSold,
    required this.totalMoneyEarned,
    required this.pendingPickups,
    this.nextPickupDate,
  });

  @override
  List<Object?> get props => [
    totalWasteSold,
    totalMoneyEarned,
    pendingPickups,
    nextPickupDate,
  ];
}

class Pickup extends Equatable {
  final String id;
  final String status;
  final DateTime scheduledDate;
  final String? collectorName;
  final String? collectorPhone;
  final double estimatedAmount;
  final List<String> wasteTypes;

  const Pickup({
    required this.id,
    required this.status,
    required this.scheduledDate,
    this.collectorName,
    this.collectorPhone,
    required this.estimatedAmount,
    required this.wasteTypes,
  });

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

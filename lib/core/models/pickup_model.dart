/// Represents a waste pickup record with OTP verification
class PickupModel {
  final String id;
  final String wasteSummary; // e.g., "Plastic, E-Waste, Metal"
  final double estimatedAmount; // in rupees
  final String pickupDate; // formatted date string
  final String pickupTime; // formatted time string
  final PickupStatus status; // upcoming, completed, cancelled
  final String? pickupOtp; // 4-6 digit OTP
  final DateTime? otpGeneratedAt;
  final bool otpVerified;
  final double totalKg; // total kg submitted
  final String category; // primary category
  final String type; // waste type

  PickupModel({
    required this.id,
    required this.wasteSummary,
    required this.estimatedAmount,
    required this.pickupDate,
    required this.pickupTime,
    required this.status,
    this.pickupOtp,
    this.otpGeneratedAt,
    this.otpVerified = false,
    required this.totalKg,
    required this.category,
    required this.type,
  });

  /// Create a copy of this pickup with modified fields
  PickupModel copyWith({
    String? id,
    String? wasteSummary,
    double? estimatedAmount,
    String? pickupDate,
    String? pickupTime,
    PickupStatus? status,
    String? pickupOtp,
    DateTime? otpGeneratedAt,
    bool? otpVerified,
    double? totalKg,
    String? category,
    String? type,
  }) {
    return PickupModel(
      id: id ?? this.id,
      wasteSummary: wasteSummary ?? this.wasteSummary,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTime: pickupTime ?? this.pickupTime,
      status: status ?? this.status,
      pickupOtp: pickupOtp ?? this.pickupOtp,
      otpGeneratedAt: otpGeneratedAt ?? this.otpGeneratedAt,
      otpVerified: otpVerified ?? this.otpVerified,
      totalKg: totalKg ?? this.totalKg,
      category: category ?? this.category,
      type: type ?? this.type,
    );
  }

  @override
  String toString() => 'PickupModel(id: $id, otp: $pickupOtp, status: $status)';
}

/// Enum for pickup status
enum PickupStatus {
  upcoming,
  completed,
  cancelled,
}

extension PickupStatusExtension on PickupStatus {
  String get label {
    switch (this) {
      case PickupStatus.upcoming:
        return 'Upcoming';
      case PickupStatus.completed:
        return 'Completed';
      case PickupStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get displayText {
    switch (this) {
      case PickupStatus.upcoming:
        return 'Upcoming';
      case PickupStatus.completed:
        return 'Completed';
      case PickupStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isUpcoming => this == PickupStatus.upcoming;
  bool get isCompleted => this == PickupStatus.completed;
  bool get isCancelled => this == PickupStatus.cancelled;
}

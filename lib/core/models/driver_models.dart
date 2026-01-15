/// Driver profile data
class DriverProfile {
  final String id;
  final String name;
  final String phoneNumber;
  final String profileImage;
  final double pointsEarned;
  final double natureSavedPercentage;
  final String area; // Service area
  final double totalEarned; // Total amount earned
  final double amountWithdrawn; // Total amount withdrawn

  DriverProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.profileImage,
    required this.pointsEarned,
    required this.natureSavedPercentage,
    required this.area,
    required this.totalEarned,
    required this.amountWithdrawn,
  });

  DriverProfile copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? profileImage,
    double? pointsEarned,
    double? natureSavedPercentage,
    String? area,
    double? totalEarned,
    double? amountWithdrawn,
  }) {
    return DriverProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      natureSavedPercentage: natureSavedPercentage ?? this.natureSavedPercentage,
      area: area ?? this.area,
      totalEarned: totalEarned ?? this.totalEarned,
      amountWithdrawn: amountWithdrawn ?? this.amountWithdrawn,
    );
  }
}

/// Pickup request for driver (sale request from user)
class PickupRequest {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String userProfileImage;
  final String wasteType; // e.g., "Plastic, E-Waste"
  final double quantity; // in kg
  final double distanceKm;
  final double estimatedAmount;
  final String pickupOtp;
  final String pickupLocation; // Address
  final double latitude;
  final double longitude;
  final PickupRequestStatus status;
  final String? transferredByDriverName; // Name of driver who transferred this request

  PickupRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userProfileImage,
    required this.wasteType,
    required this.quantity,
    required this.distanceKm,
    required this.estimatedAmount,
    required this.pickupOtp,
    required this.pickupLocation,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.transferredByDriverName,
  });

  PickupRequest copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    String? userProfileImage,
    String? wasteType,
    double? quantity,
    double? distanceKm,
    double? estimatedAmount,
    String? pickupOtp,
    String? pickupLocation,
    double? latitude,
    double? longitude,
    PickupRequestStatus? status,
    String? transferredByDriverName,
  }) {
    return PickupRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      wasteType: wasteType ?? this.wasteType,
      quantity: quantity ?? this.quantity,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
      pickupOtp: pickupOtp ?? this.pickupOtp,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      transferredByDriverName: transferredByDriverName ?? this.transferredByDriverName,
    );
  }
}

/// Status enum for pickup requests
enum PickupRequestStatus {
  available,
  accepted,
  otpVerified,
  collected,
  completed,
  declined,
  transferred,
  hidden,
}

extension PickupRequestStatusExt on PickupRequestStatus {
  String get displayText {
    switch (this) {
      case PickupRequestStatus.available:
        return 'Available';
      case PickupRequestStatus.accepted:
        return 'Accepted';
      case PickupRequestStatus.otpVerified:
        return 'OTP Verified';
      case PickupRequestStatus.collected:
        return 'Collected';
      case PickupRequestStatus.completed:
        return 'Completed';
      case PickupRequestStatus.declined:
        return 'Declined';
      case PickupRequestStatus.transferred:
        return 'Transferred';
      case PickupRequestStatus.hidden:
        return 'Hidden';
    }
  }

  bool get isAvailable => this == PickupRequestStatus.available;
  bool get isAccepted => this == PickupRequestStatus.accepted;
  bool get isOtpVerified => this == PickupRequestStatus.otpVerified;
  bool get isCollected => this == PickupRequestStatus.collected;
  bool get isCompleted => this == PickupRequestStatus.completed;
}

/// Other driver for transfer
class OtherDriver {
  final String id;
  final String name;
  final String phoneNumber;
  final double rating;
  final int completedRequests;

  OtherDriver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.rating,
    required this.completedRequests,
  });
}

import '../models/driver_models.dart';

class DriverMockData {
  // Static allowed driver number
  static const String allowedDriverPhone = '8123456790';

  // Mock driver profile
  static final DriverProfile staticDriver = DriverProfile(
    id: 'd1',
    name: 'Rajesh Kumar',
    phoneNumber: allowedDriverPhone,
    profileImage: 'https://i.pravatar.cc/150?img=12',
    pointsEarned: 2450.0,
    natureSavedPercentage: 42.5,
    area: 'Bangalore - Whitefield',
    totalEarned: 15750.0,
    amountWithdrawn: 12500.0,
  );

  // Mock pickup requests (available for driver)
  static final List<PickupRequest> pickupRequests = [
    PickupRequest(
      id: 'req1',
      userId: 'u1',
      userName: 'Priya Singh',
      userPhone: '+91-9988776655',
      userProfileImage: 'https://i.pravatar.cc/150?img=20',
      wasteType: 'Plastic, E-Waste',
      quantity: 12.5,
      distanceKm: 2.3,
      estimatedAmount: 485.0,
      pickupOtp: '1234',
      pickupLocation: 'Whitefield Main Rd, Bangalore',
      latitude: 12.9698,
      longitude: 77.7499,
      status: PickupRequestStatus.available,
    ),
    PickupRequest(
      id: 'req2',
      userId: 'u2',
      userName: 'Amit Patel',
      userPhone: '+91-9876543210',
      userProfileImage: 'https://i.pravatar.cc/150?img=21',
      wasteType: 'Metal, Aluminum',
      quantity: 8.0,
      distanceKm: 1.8,
      estimatedAmount: 320.0,
      pickupOtp: '9156',
      pickupLocation: 'Koramangala, Bangalore',
      latitude: 12.9352,
      longitude: 77.6245,
      status: PickupRequestStatus.available,
    ),
    PickupRequest(
      id: 'req3',
      userId: 'u3',
      userName: 'Neha Gupta',
      userPhone: '+91-9765432100',
      userProfileImage: 'https://i.pravatar.cc/150?img=22',
      wasteType: 'Cardboard, Paper',
      quantity: 15.0,
      distanceKm: 3.5,
      estimatedAmount: 580.0,
      pickupOtp: '7342',
      pickupLocation: 'Indiranagar, Bangalore',
      latitude: 12.9716,
      longitude: 77.6412,
      status: PickupRequestStatus.available,
    ),
    PickupRequest(
      id: 'req4',
      userId: 'u4',
      userName: 'Vikram Reddy',
      userPhone: '+91-9654321000',
      userProfileImage: 'https://i.pravatar.cc/150?img=23',
      wasteType: 'Glass, Plastic',
      quantity: 6.5,
      distanceKm: 0.9,
      estimatedAmount: 245.0,
      pickupOtp: '5678',
      pickupLocation: 'Marathahalli, Bangalore',
      latitude: 12.9698,
      longitude: 77.7065,
      status: PickupRequestStatus.available,
    ),
    PickupRequest(
      id: 'req5',
      userId: 'u5',
      userName: 'Sneha Dey',
      userPhone: '+91-8765432100',
      userProfileImage: 'https://i.pravatar.cc/150?img=24',
      wasteType: 'E-Waste, Metal',
      quantity: 9.2,
      distanceKm: 2.1,
      estimatedAmount: 415.0,
      pickupOtp: '2103',
      pickupLocation: 'JP Nagar, Bangalore',
      latitude: 12.9352,
      longitude: 77.6005,
      status: PickupRequestStatus.available,
    ),
  ];

  // Mock other drivers for transfer
  static final List<OtherDriver> otherDrivers = [
    OtherDriver(
      id: 'd2',
      name: 'Suresh Singh',
      phoneNumber: '+91-9123456789',
      rating: 4.8,
      completedRequests: 245,
    ),
    OtherDriver(
      id: 'd3',
      name: 'Karan Malhotra',
      phoneNumber: '+91-9234567890',
      rating: 4.6,
      completedRequests: 189,
    ),
    OtherDriver(
      id: 'd4',
      name: 'Anil Kumar',
      phoneNumber: '+91-9345678901',
      rating: 4.7,
      completedRequests: 312,
    ),
  ];

  // Get total requests for area
  static int getTotalRequestsInArea() => pickupRequests.length;

  // Get available requests
  static List<PickupRequest> getAvailableRequests() {
    return pickupRequests.where((r) => r.status.isAvailable).toList();
  }
}

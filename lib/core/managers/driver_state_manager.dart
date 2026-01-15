import 'package:flutter/foundation.dart';
import '../models/driver_models.dart';
import '../mock/driver_mock_data.dart';

/// State for driver authentication
enum DriverAuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Request filter for home screen
enum RequestFilter {
  active,
  hidden,
  transferred,
  transferredToMe,
}

/// Driver state manager
class DriverStateManager extends ChangeNotifier {
  // Auth state
  DriverAuthState _authState = DriverAuthState.initial;
  String? _authError;
  DriverProfile? _currentDriver;

  // Request management
  final List<PickupRequest> _availableRequests = [];
  final List<PickupRequest> _acceptedRequests = [];
  final List<PickupRequest> _completedRequests = [];
  final List<PickupRequest> _hiddenRequests = [];
  final List<PickupRequest> _transferredRequests = [];
  final List<PickupRequest> _transferredToMeRequests = [];
  final List<PickupRequest> _acceptedTransfersRequests = [];
  final List<PickupRequest> _rejectedTransfersRequests = [];

  // Filter state
  RequestFilter _currentFilter = RequestFilter.active;
  String _searchQuery = '';
  String _filterLocation = '';
  String _filterName = '';
  double? _filterMinQuantity;
  double? _filterMaxQuantity;
  double? _filterMinDistance;
  double? _filterMaxDistance;

  // Current request being viewed
  PickupRequest? _currentRequest;
  bool _otpVerified = false;

  // Getters
  DriverAuthState get authState => _authState;
  String? get authError => _authError;
  DriverProfile? get currentDriver => _currentDriver;

  List<PickupRequest> get availableRequests => _availableRequests;
  List<PickupRequest> get acceptedRequests => _acceptedRequests;
  List<PickupRequest> get completedRequests => _completedRequests;
  List<PickupRequest> get hiddenRequests => _hiddenRequests;
  List<PickupRequest> get transferredRequests => _transferredRequests;
  List<PickupRequest> get transferredToMeRequests => _transferredToMeRequests;
  List<PickupRequest> get acceptedTransfersRequests => _acceptedTransfersRequests;
  List<PickupRequest> get rejectedTransfersRequests => _rejectedTransfersRequests;

  RequestFilter get currentFilter => _currentFilter;

  PickupRequest? get currentRequest => _currentRequest;
  bool get otpVerified => _otpVerified;

  bool get isAuthenticated => _authState == DriverAuthState.authenticated;

  int get totalRequestsInArea {
    return _availableRequests.length + _acceptedRequests.length;
  }

  /// Get filtered requests based on current filter
  List<PickupRequest> get filteredRequests {
    List<PickupRequest> requests;
    
    switch (_currentFilter) {
      case RequestFilter.active:
        requests = [..._availableRequests, ..._acceptedRequests];
      case RequestFilter.hidden:
        requests = _hiddenRequests;
      case RequestFilter.transferred:
        requests = _transferredRequests;
      case RequestFilter.transferredToMe:
        requests = _transferredToMeRequests;
    }
    
    // Apply search and filters
    return requests.where((request) {
      // Search by name and location
      final searchLower = _searchQuery.toLowerCase();
      final nameMatch = request.userName.toLowerCase().contains(searchLower) ||
          request.wasteType.toLowerCase().contains(searchLower);
      final locationMatch = request.pickupLocation.toLowerCase().contains(searchLower);
      final searchPasses = _searchQuery.isEmpty || nameMatch || locationMatch;
      
      // Filter by location
      final locationPasses = _filterLocation.isEmpty ||
          request.pickupLocation.toLowerCase().contains(_filterLocation.toLowerCase());
      
      // Filter by name/type
      final namePasses = _filterName.isEmpty ||
          request.userName.toLowerCase().contains(_filterName.toLowerCase()) ||
          request.wasteType.toLowerCase().contains(_filterName.toLowerCase());
      
      // Filter by quantity range
      final quantityPasses = (_filterMinQuantity == null || request.quantity >= _filterMinQuantity!) &&
          (_filterMaxQuantity == null || request.quantity <= _filterMaxQuantity!);
      
      // Filter by distance range
      final distancePasses = (_filterMinDistance == null || request.distanceKm >= _filterMinDistance!) &&
          (_filterMaxDistance == null || request.distanceKm <= _filterMaxDistance!);
      
      return searchPasses && locationPasses && namePasses && quantityPasses && distancePasses;
    }).toList();
  }

  /// Get count for each filter
  int get activeCount => _availableRequests.length + _acceptedRequests.length;
  int get hiddenCount => _hiddenRequests.length;
  int get transferredCount => _transferredRequests.length;
  int get transferredToMeCount => _transferredToMeRequests.length;
  int get acceptedTransfersCount => _acceptedTransfersRequests.length;
  int get rejectedTransfersCount => _rejectedTransfersRequests.length;

  // Initialize
  void initialize() {
    _availableRequests.addAll(DriverMockData.pickupRequests);
    
    // Add sample hidden request
    _hiddenRequests.add(
      PickupRequest(
        id: 'hidden1',
        userId: 'u6',
        userName: 'Ravi Kumar',
        userPhone: '+91-9555555555',
        userProfileImage: 'https://i.pravatar.cc/150?img=25',
        wasteType: 'Plastic',
        quantity: 4.0,
        distanceKm: 5.2,
        estimatedAmount: 180.0,
        pickupOtp: '1234',
        pickupLocation: 'Yelahanka, Bangalore',
        latitude: 13.0069,
        longitude: 77.5993,
        status: PickupRequestStatus.hidden,
      ),
    );

    // Add sample transferred request
    _transferredRequests.add(
      PickupRequest(
        id: 'transferred1',
        userId: 'u7',
        userName: 'Divya Sharma',
        userPhone: '+91-9666666666',
        userProfileImage: 'https://i.pravatar.cc/150?img=26',
        wasteType: 'E-Waste, Metal',
        quantity: 11.5,
        distanceKm: 1.5,
        estimatedAmount: 520.0,
        pickupOtp: '5678',
        pickupLocation: 'Bangalore North, Karnataka',
        latitude: 12.9900,
        longitude: 77.6100,
        status: PickupRequestStatus.transferred,
      ),
    );

    // Add sample transferred-to-me requests
    _transferredToMeRequests.addAll([
      PickupRequest(
        id: 'transferredToMe1',
        userId: 'u8',
        userName: 'Anaya Patel',
        userPhone: '+91-9777777777',
        userProfileImage: 'https://i.pravatar.cc/150?img=28',
        wasteType: 'Plastic Bottles',
        quantity: 6.5,
        distanceKm: 2.3,
        estimatedAmount: 240.0,
        pickupOtp: '9012',
        pickupLocation: 'Marathahalli, Bangalore',
        latitude: 12.9596,
        longitude: 77.7092,
        status: PickupRequestStatus.available,
        transferredByDriverName: 'Priya Singh',
      ),
      PickupRequest(
        id: 'transferredToMe2',
        userId: 'u9',
        userName: 'Arjun Reddy',
        userPhone: '+91-9888888888',
        userProfileImage: 'https://i.pravatar.cc/150?img=29',
        wasteType: 'Cardboard, Paper',
        quantity: 8.0,
        distanceKm: 3.8,
        estimatedAmount: 320.0,
        pickupOtp: '3456',
        pickupLocation: 'Whitefield, Bangalore',
        latitude: 12.9698,
        longitude: 77.7499,
        status: PickupRequestStatus.available,
        transferredByDriverName: 'Rajesh Kumar',
      ),
    ]);
    
    notifyListeners();
  }

  // Login with phone number
  Future<bool> loginWithPhone(String phoneNumber) async {
    _authState = DriverAuthState.loading;
    _authError = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if phone number is authorized
    if (phoneNumber == DriverMockData.allowedDriverPhone) {
      _authState = DriverAuthState.authenticated;
      _currentDriver = DriverMockData.staticDriver;
      notifyListeners();
      return true;
    } else {
      _authState = DriverAuthState.unauthenticated;
      _authError = 'Unauthorized Driver. Please contact support.';
      notifyListeners();
      return false;
    }
  }

  // Logout
  void logout() {
    _authState = DriverAuthState.initial;
    _authError = null;
    _currentDriver = null;
    _availableRequests.clear();
    _acceptedRequests.clear();
    _completedRequests.clear();
    _hiddenRequests.clear();
    _transferredRequests.clear();
    _transferredToMeRequests.clear();
    _acceptedTransfersRequests.clear();
    _rejectedTransfersRequests.clear();
    _currentRequest = null;
    _otpVerified = false;
    _currentFilter = RequestFilter.active;
    notifyListeners();
  }

  // Accept request
  void acceptRequest(PickupRequest request) {
    _availableRequests.removeWhere((r) => r.id == request.id);
    
    final acceptedRequest = request.copyWith(
      status: PickupRequestStatus.accepted,
    );
    _acceptedRequests.add(acceptedRequest);
    _currentRequest = acceptedRequest;
    _otpVerified = false;
    
    notifyListeners();
  }

  // Decline request
  void declineRequest(PickupRequest request) {
    _availableRequests.removeWhere((r) => r.id == request.id);
    notifyListeners();
  }

  // Hide request
  void hideRequest(PickupRequest request) {
    _availableRequests.removeWhere((r) => r.id == request.id);
    _acceptedRequests.removeWhere((r) => r.id == request.id);
    
    final hiddenRequest = request.copyWith(
      status: PickupRequestStatus.hidden,
    );
    _hiddenRequests.add(hiddenRequest);
    
    notifyListeners();
  }

  // Unhide request (restore to active)
  void unhideRequest(PickupRequest request) {
    _hiddenRequests.removeWhere((r) => r.id == request.id);
    
    final activeRequest = request.copyWith(
      status: PickupRequestStatus.available,
    );
    _availableRequests.add(activeRequest);
    
    notifyListeners();
  }

  // Transfer request to another driver
  void transferRequest(PickupRequest request, OtherDriver driver) {
    _availableRequests.removeWhere((r) => r.id == request.id);
    _acceptedRequests.removeWhere((r) => r.id == request.id);
    _hiddenRequests.removeWhere((r) => r.id == request.id);
    
    final transferredRequest = request.copyWith(
      status: PickupRequestStatus.transferred,
    );
    _transferredRequests.add(transferredRequest);
    
    notifyListeners();
  }

  // Verify OTP
  bool verifyOtp(String inputOtp) {
    if (_currentRequest != null && _currentRequest!.pickupOtp == inputOtp) {
      _otpVerified = true;
      
      // Update request status
      final updatedRequest = _currentRequest!.copyWith(
        status: PickupRequestStatus.otpVerified,
      );
      _currentRequest = updatedRequest;
      
      // Update in accepted list
      final index = _acceptedRequests.indexWhere((r) => r.id == _currentRequest!.id);
      if (index != -1) {
        _acceptedRequests[index] = updatedRequest;
      }
      
      notifyListeners();
      return true;
    }
    return false;
  }

  // Mark waste as collected (after photo upload)
  void markWasteCollected() {
    if (_currentRequest != null) {
      final collectedRequest = _currentRequest!.copyWith(
        status: PickupRequestStatus.collected,
      );
      _currentRequest = collectedRequest;
      
      // Update in accepted list
      final index = _acceptedRequests.indexWhere((r) => r.id == _currentRequest!.id);
      if (index != -1) {
        _acceptedRequests[index] = collectedRequest;
      }
      
      notifyListeners();
    }
  }

  // Complete pickup (final submission)
  void completePickup() {
    if (_currentRequest != null) {
      final completedRequest = _currentRequest!.copyWith(
        status: PickupRequestStatus.completed,
      );
      _acceptedRequests.removeWhere((r) => r.id == _currentRequest!.id);
      _completedRequests.add(completedRequest);
      _currentRequest = null;
      _otpVerified = false;
      
      notifyListeners();
    }
  }

  // Set current request (for viewing details)
  void setCurrentRequest(PickupRequest request) {
    _currentRequest = request;
    _otpVerified = false;
    notifyListeners();
  }

  // Clear current request
  void clearCurrentRequest() {
    _currentRequest = null;
    _otpVerified = false;
    notifyListeners();
  }

  // Clear OTP verification
  void clearOtpVerification() {
    _otpVerified = false;
    notifyListeners();
  }

  // Change filter (Active, Hidden, Transferred, Transferred To Me)
  void setFilter(RequestFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  // Accept a transferred request (move to active)
  void acceptTransferedRequest(PickupRequest request) {
    _transferredToMeRequests.removeWhere((r) => r.id == request.id);
    
    final acceptedRequest = request.copyWith(
      status: PickupRequestStatus.accepted,
    );
    _acceptedRequests.add(acceptedRequest);
    _acceptedTransfersRequests.add(acceptedRequest);
    
    notifyListeners();
  }

  // Reject a transferred request
  void rejectTransferedRequest(PickupRequest request) {
    _transferredToMeRequests.removeWhere((r) => r.id == request.id);
    
    final rejectedRequest = request.copyWith(
      status: PickupRequestStatus.declined,
    );
    _rejectedTransfersRequests.add(rejectedRequest);
    
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Apply advanced filters
  void applyFilters({
    required String location,
    required String name,
    required double? minQuantity,
    required double? maxQuantity,
    required double? minDistance,
    required double? maxDistance,
  }) {
    _filterLocation = location;
    _filterName = name;
    _filterMinQuantity = minQuantity;
    _filterMaxQuantity = maxQuantity;
    _filterMinDistance = minDistance;
    _filterMaxDistance = maxDistance;
    notifyListeners();
  }

  // Clear advanced filters
  void clearAdvancedFilters() {
    _filterLocation = '';
    _filterName = '';
    _filterMinQuantity = null;
    _filterMaxQuantity = null;
    _filterMinDistance = null;
    _filterMaxDistance = null;
    _searchQuery = '';
    notifyListeners();
  }
}

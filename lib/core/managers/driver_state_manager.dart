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

  PickupRequest? get currentRequest => _currentRequest;
  bool get otpVerified => _otpVerified;

  bool get isAuthenticated => _authState == DriverAuthState.authenticated;

  int get totalRequestsInArea {
    return _availableRequests.length + _acceptedRequests.length;
  }

  // Initialize
  void initialize() {
    _availableRequests.addAll(DriverMockData.pickupRequests);
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
    _currentRequest = null;
    _otpVerified = false;
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
    
    final hiddenRequest = request.copyWith(
      status: PickupRequestStatus.hidden,
    );
    _hiddenRequests.add(hiddenRequest);
    
    notifyListeners();
  }

  // Transfer request to another driver
  void transferRequest(PickupRequest request, OtherDriver driver) {
    _availableRequests.removeWhere((r) => r.id == request.id);
    _acceptedRequests.removeWhere((r) => r.id == request.id);
    
    // In real app, this would be stored or sent to backend
    // For now, just remove from available list
    
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
}

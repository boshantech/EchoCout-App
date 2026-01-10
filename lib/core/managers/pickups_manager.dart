import 'package:flutter/material.dart';
import '../models/pickup_model.dart';

/// Manages the state of pickups (upcoming, completed, cancelled)
class PickupsManager extends ChangeNotifier {
  final List<PickupModel> _pickups = [];

  List<PickupModel> get pickups => List.unmodifiable(_pickups);

  List<PickupModel> get upcomingPickups =>
      _pickups.where((p) => p.status.isUpcoming).toList();

  List<PickupModel> get completedPickups =>
      _pickups.where((p) => p.status.isCompleted).toList();

  List<PickupModel> get cancelledPickups =>
      _pickups.where((p) => p.status.isCancelled).toList();

  bool get hasUpcomingPickups => upcomingPickups.isNotEmpty;

  /// Add a new pickup to the list
  void addPickup(PickupModel pickup) {
    _pickups.add(pickup);
    notifyListeners();
  }

  /// Update an existing pickup
  void updatePickup(PickupModel updatedPickup) {
    final index = _pickups.indexWhere((p) => p.id == updatedPickup.id);
    if (index != -1) {
      _pickups[index] = updatedPickup;
      notifyListeners();
    }
  }

  /// Mark a pickup as completed
  void markAsCompleted(String pickupId) {
    final index = _pickups.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickups[index] = _pickups[index].copyWith(
        status: PickupStatus.completed,
      );
      notifyListeners();
    }
  }

  /// Mark a pickup as cancelled
  void markAsCancelled(String pickupId) {
    final index = _pickups.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickups[index] = _pickups[index].copyWith(
        status: PickupStatus.cancelled,
      );
      notifyListeners();
    }
  }

  /// Verify OTP for a pickup
  void verifyPickupOtp(String pickupId) {
    final index = _pickups.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickups[index] = _pickups[index].copyWith(
        otpVerified: true,
      );
      notifyListeners();
    }
  }

  /// Get a specific pickup by ID
  PickupModel? getPickupById(String id) {
    try {
      return _pickups.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear all pickups (for reset/logout)
  void clearAllPickups() {
    _pickups.clear();
    notifyListeners();
  }

  /// Initialize with mock pickups (for demo)
  void initializeMockPickups(List<PickupModel> mockPickups) {
    _pickups.clear();
    _pickups.addAll(mockPickups);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/models/driver_models.dart';
import '../../../../core/managers/driver_state_manager.dart';

/// Production-grade request detail screen for drivers
/// 
/// Flow:
/// 1. Request actions (Accept/Decline/Hide/Transfer)
/// 2. User details confirmation
/// 3. OTP verification
/// 4. Photo capture
/// 5. Mark waste collected
class DriverRequestDetailScreen extends StatefulWidget {
  final PickupRequest request;
  final DriverStateManager driverStateManager;

  const DriverRequestDetailScreen({
    Key? key,
    required this.request,
    required this.driverStateManager,
  }) : super(key: key);

  @override
  State<DriverRequestDetailScreen> createState() => _DriverRequestDetailScreenState();
}

class _DriverRequestDetailScreenState extends State<DriverRequestDetailScreen> {
  late PickupRequest _currentRequest;
  late TextEditingController _otpController;

  // UI States
  bool _otpVerified = false;
  bool _wastePhotoCaptured = false;
  bool _isLoadingOtp = false;
  String _otpError = '';
  File? _wastePhoto;

  @override
  void initState() {
    super.initState();
    _currentRequest = widget.request;
    _otpController = TextEditingController();
    widget.driverStateManager.setCurrentRequest(_currentRequest);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  /// Verify OTP entered by driver against pickup OTP
  Future<void> _verifyOtp() async {
    final enteredOtp = _otpController.text.trim();

    if (enteredOtp.isEmpty) {
      setState(() {
        _otpError = 'Please enter OTP';
      });
      return;
    }

    setState(() {
      _isLoadingOtp = true;
      _otpError = '';
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (enteredOtp == _currentRequest.pickupOtp) {
      setState(() {
        _otpVerified = true;
        _isLoadingOtp = false;
        _otpError = '';
      });

      widget.driverStateManager.verifyOtp(enteredOtp);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ OTP verified successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _isLoadingOtp = false;
        _otpError = 'Incorrect OTP. Please try again.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ OTP verification failed'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Capture waste photo from camera
  Future<void> _captureWastePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _wastePhoto = File(photo.path);
          _wastePhotoCaptured = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📸 Photo captured successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Mark waste as collected and remove from available requests
  Future<void> _markWasteCollected() async {
    if (!_otpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify OTP first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_wastePhotoCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture waste photo first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Waste: ${_currentRequest.wasteType}'),
            Text('Quantity: ${_currentRequest.quantity}kg'),
            Text('Amount: ₹${_currentRequest.estimatedAmount.toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitCollection();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forestGreen,
            ),
            child: const Text('Confirm Collection', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Submit waste collection to state manager
  Future<void> _submitCollection() async {
    // Mark waste collected in state
    widget.driverStateManager.markWasteCollected();
    widget.driverStateManager.completePickup();

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('✅ Waste Collected!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Waste collection completed successfully'),
            const SizedBox(height: 16),
            Text('Amount credited: ₹${_currentRequest.estimatedAmount.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            Text('Points earned: +${(_currentRequest.estimatedAmount / 10).toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.leafGreen,
            ),
            child: const Text('Back to Home', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Handle request actions (Accept/Decline/Hide/Transfer)
  void _handleRequestAction(String action) {
    switch (action) {
      case 'accept':
        widget.driverStateManager.acceptRequest(_currentRequest);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Request accepted!')),
        );
        break;

      case 'decline':
        widget.driverStateManager.declineRequest(_currentRequest);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request declined')),
        );
        break;

      case 'hide':
        widget.driverStateManager.hideRequest(_currentRequest);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request hidden temporarily')),
        );
        break;

      case 'transfer':
        _showTransferDialog();
        break;
    }
  }

  /// Show transfer to another driver dialog
  void _showTransferDialog() {
    final mockDrivers = [
      {'name': 'Suresh Singh', 'phone': '+91-9123456789', 'rating': 4.8},
      {'name': 'Karan Malhotra', 'phone': '+91-9234567890', 'rating': 4.6},
      {'name': 'Anil Kumar', 'phone': '+91-9345678901', 'rating': 4.7},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer Request'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mockDrivers.length,
            itemBuilder: (context, index) {
              final driver = mockDrivers[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(driver['name'] as String),
                subtitle: Text('Rating: ${driver['rating']} ⭐'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request transferred to ${driver['name']}'),
                    ),
                  );
                  Navigator.pop(context); // Go back to home
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.forestGreen,
        title: const Text('Request Details'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => _handleRequestAction('decline'),
                child: const Row(
                  children: [
                    Icon(Icons.close, size: 20),
                    SizedBox(width: 12),
                    Text('Decline'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => _handleRequestAction('hide'),
                child: const Row(
                  children: [
                    Icon(Icons.visibility_off, size: 20),
                    SizedBox(width: 12),
                    Text('Hide'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => _handleRequestAction('transfer'),
                child: const Row(
                  children: [
                    Icon(Icons.send, size: 20),
                    SizedBox(width: 12),
                    Text('Transfer'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ═══════════════════════════════════════════════════════════
            // USER DETAILS SECTION
            // ═══════════════════════════════════════════════════════════
            Container(
              color: AppColors.forestGreen.withOpacity(0.05),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.forestGreen,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            _currentRequest.userProfileImage,
                          ),
                          backgroundColor: AppColors.leafGreen.withOpacity(0.1),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentRequest.userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.leafGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 18,
                                color: AppColors.forestGreen,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _currentRequest.userPhone,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.leafGreen.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pickup Location',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textTertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _currentRequest.pickupLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Lat: ${_currentRequest.latitude.toStringAsFixed(4)}, Lng: ${_currentRequest.longitude.toStringAsFixed(4)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ═══════════════════════════════════════════════════════════
            // WASTE DETAILS SECTION
            // ═══════════════════════════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Waste Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.forestGreen,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          label: 'Category',
                          value: _currentRequest.wasteType.split(',').first,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          label: 'Quantity',
                          value: '${_currentRequest.quantity}kg',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          label: 'Distance',
                          value: '${_currentRequest.distanceKm.toStringAsFixed(1)}km',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          label: 'Estimated Amount',
                          value: '₹${_currentRequest.estimatedAmount.toStringAsFixed(0)}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ═══════════════════════════════════════════════════════════
            // OTP VERIFICATION SECTION
            // ═══════════════════════════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OTP Verification',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.forestGreen,
                        ),
                  ),
                  const SizedBox(height: 16),
                  if (_otpVerified)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 28),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'OTP Verified',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'Proceed with waste collection',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            letterSpacing: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLength: 4,
                          decoration: InputDecoration(
                            hintText: 'Enter OTP',
                            hintStyle: TextStyle(
                              color: AppColors.textTertiary,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _otpError.isNotEmpty
                                    ? Colors.red
                                    : AppColors.divider,
                              ),
                            ),
                            errorText: _otpError.isNotEmpty ? _otpError : null,
                            counterText: '',
                          ),
                          onChanged: (value) {
                            if (_otpError.isNotEmpty) {
                              setState(() => _otpError = '');
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoadingOtp ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.forestGreen,
                              disabledBackgroundColor:
                                  AppColors.forestGreen.withOpacity(0.5),
                            ),
                            child: _isLoadingOtp
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Verify OTP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ═══════════════════════════════════════════════════════════
            // WASTE COLLECTION SECTION (Only after OTP verified)
            // ═══════════════════════════════════════════════════════════
            if (_otpVerified)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Waste Collection',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.forestGreen,
                          ),
                    ),
                    const SizedBox(height: 16),
                    // Photo capture
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _wastePhotoCaptured
                              ? AppColors.leafGreen
                              : AppColors.divider,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _wastePhotoCaptured
                            ? AppColors.leafGreen.withOpacity(0.05)
                            : Colors.grey.withOpacity(0.05),
                      ),
                      child: _wastePhotoCaptured && _wastePhoto != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _wastePhoto!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : GestureDetector(
                              onTap: _captureWastePhoto,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 48,
                                    color: AppColors.forestGreen,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Capture Waste Photo',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.forestGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Take a photo of the collected waste',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    if (_wastePhotoCaptured)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 12),
                            const Text(
                              'Photo captured successfully',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Collect button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _wastePhotoCaptured
                            ? _markWasteCollected
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.leafGreen,
                          disabledBackgroundColor:
                              AppColors.leafGreen.withOpacity(0.5),
                        ),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          'Mark Waste Collected',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Accept button (if not already accepted)
            if (!_otpVerified)
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _handleRequestAction('accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestGreen,
                    ),
                    child: const Text(
                      'Accept Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Helper widget for displaying info cards
class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.leafGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.leafGreen.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

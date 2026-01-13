import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/eco_components.dart';
import '../../../../core/models/driver_models.dart';

class RequestDetailPage extends StatefulWidget {
  final PickupRequest request;
  final VoidCallback onWasteCollected;

  const RequestDetailPage({
    Key? key,
    required this.request,
    required this.onWasteCollected,
  }) : super(key: key);

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  // Step 0: User details confirmation
  // Step 1: OTP verification
  // Step 2: Waste collection
  int _currentStep = 0;

  // OTP
  late TextEditingController _otpController;
  String _otpError = '';
  bool _isVerifyingOTP = false;

  // Waste Collection
  late TextEditingController _wasteWeightController;
  String _selectedWasteType = 'Mixed';
  File? _wastePhotoFile;
  bool _isSubmittingWaste = false;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _wasteWeightController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _wasteWeightController.dispose();
    super.dispose();
  }

  Future<void> _pickWastePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _wastePhotoFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(otp)) {
      setState(() {
        _otpError = 'Please enter a valid 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isVerifyingOTP = true;
      _otpError = '';
    });

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // In production: validate OTP with backend
      setState(() {
        _isVerifyingOTP = false;
        _currentStep = 2; // Move to waste collection
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✓ OTP verified successfully!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _submitWaste() async {
    final weight = _wasteWeightController.text.trim();
    if (weight.isEmpty || double.tryParse(weight) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid waste weight (kg)')),
      );
      return;
    }

    if (_wastePhotoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please take a photo of the waste')),
      );
      return;
    }

    setState(() {
      _isSubmittingWaste = true;
    });

    // Simulate waste collection submission
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // In production: upload to backend
      setState(() {
        _isSubmittingWaste = false;
      });

      // Call callback to update user app and sync data
      widget.onWasteCollected();

      // Success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Waste Collected!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${weight}kg of waste collected\n🌱 User notified automatically',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to driver home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forestGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.forestGreen,
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Text(
          _currentStep == 0 ? 'User Details' : _currentStep == 1 ? 'Verify OTP' : 'Collect Waste',
          style: const TextStyle(color: AppColors.forestGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildStepIndicator(0, 'User Details'),
                      const Expanded(child: Divider(thickness: 2)),
                      _buildStepIndicator(1, 'OTP Verify'),
                      const Expanded(child: Divider(thickness: 2)),
                      _buildStepIndicator(2, 'Collect'),
                    ],
                  ),
                ],
              ),
            ),
            // Content based on current step
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _currentStep == 0
                  ? _buildUserDetailsStep()
                  : _currentStep == 1
                      ? _buildOTPStep()
                      : _buildWasteCollectionStep(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _currentStep == 0
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _currentStep = 1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Proceed to OTP Verification',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    bool isActive = _currentStep >= step;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.forestGreen : AppColors.divider,
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '${step + 1}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? AppColors.forestGreen : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildUserDetailsStep() {
    return Column(
      children: [
        const SizedBox(height: 24),
        // User profile card
        EcoCard(
          child: Column(
            children: [
              // User DP
              CircleAvatar(
                radius: 50,
                backgroundImage: widget.request.userProfileImage.isNotEmpty
                    ? NetworkImage(widget.request.userProfileImage)
                    : null,
                child: widget.request.userProfileImage.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 16),
              // User name
              Text(
                widget.request.userName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 8),
              // User phone
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.leafGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone, size: 16, color: AppColors.leafGreen),
                    const SizedBox(width: 6),
                    Text(
                      widget.request.userPhone,
                      style: const TextStyle(
                        color: AppColors.leafGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Direct call button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // In production: launch('tel:${widget.request.userPhone}')
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling ${widget.request.userPhone}...')),
                    );
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Call User Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Location info
              Row(
                children: [
                  Icon(Icons.location_on, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Distance',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          '${widget.request.distanceKm.toString()} km away',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.forestGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Waste request info
        EcoCard(
          backgroundColor: AppColors.accentYellow.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Waste Request Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.delete_outline, color: AppColors.accentYellow, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waste Type',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          widget.request.wasteType,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.star, color: AppColors.accentYellow, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Amount',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          '₹${widget.request.estimatedAmount.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentYellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOTPStep() {
    return Column(
      children: [
        const SizedBox(height: 32),
        // OTP description
        Text(
          'Enter the OTP sent to ${widget.request.userPhone}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        // OTP input field
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '000000',
            hintStyle: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 32,
              letterSpacing: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _otpError.isNotEmpty ? AppColors.warning : AppColors.divider,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.forestGreen,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onChanged: (_) {
            setState(() {
              _otpError = ''; // Clear error on input change
            });
          },
        ),
        const SizedBox(height: 12),
        // Error message
        if (_otpError.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _otpError,
              style: TextStyle(
                color: AppColors.warning,
                fontSize: 13,
              ),
            ),
          ),
        const SizedBox(height: 32),
        // Verify button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isVerifyingOTP ? null : _verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forestGreen,
              disabledBackgroundColor: AppColors.divider,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _isVerifyingOTP
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Verify OTP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        // Resend OTP
        Text(
          'Didn\'t receive? ',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textTertiary),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP resent successfully')),
            );
          },
          child: const Text(
            'Resend OTP',
            style: TextStyle(
              color: AppColors.forestGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWasteCollectionStep() {
    return Column(
      children: [
        const SizedBox(height: 24),
        // Waste photo section
        GestureDetector(
          onTap: _isSubmittingWaste ? null : _pickWastePhoto,
          child: Container(
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(
                color: _wastePhotoFile != null ? AppColors.success : AppColors.divider,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(16),
              color: _wastePhotoFile != null ? null : AppColors.leafGreen.withOpacity(0.05),
            ),
            child: _wastePhotoFile != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          _wastePhotoFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => _wastePhotoFile = null),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.warning,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 48,
                        color: AppColors.forestGreen,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Take a Photo of the Waste',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Click to capture waste image',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 24),
        // Waste type dropdown
        DropdownButtonFormField<String>(
          value: _selectedWasteType,
          decoration: InputDecoration(
            labelText: 'Waste Type',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.delete_outline),
          ),
          items: ['Mixed', 'Plastic', 'Metal', 'Paper', 'Glass', 'Organic']
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _selectedWasteType = value);
          },
        ),
        const SizedBox(height: 16),
        // Weight input
        TextField(
          controller: _wasteWeightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Total Weight (kg)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.scale),
            hintText: 'e.g., 12.5',
          ),
        ),
        const SizedBox(height: 32),
        // Submit button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmittingWaste ? null : _submitWaste,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              disabledBackgroundColor: AppColors.divider,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _isSubmittingWaste
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Complete Collection & Sync',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '💚 After submission, user will see "Sold" status and money will be auto-transferred',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textTertiary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

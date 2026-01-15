import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/routes/route_paths.dart';

class DriverOtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final int otpLength;

  const DriverOtpVerificationPage({
    Key? key,
    required this.phoneNumber,
    this.otpLength = 4,
  }) : super(key: key);

  @override
  State<DriverOtpVerificationPage> createState() =>
      _DriverOtpVerificationPageState();
}

class _DriverOtpVerificationPageState extends State<DriverOtpVerificationPage> {
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;
  
  bool _isLoading = false;
  bool _showError = false;
  String _errorMessage = '';
  
  int _resendTimer = 50;
  bool _timerActive = true;

  @override
  void initState() {
    super.initState();
    _initializeOtpFields();
    _startTimer();
  }

  void _initializeOtpFields() {
    _otpControllers = List.generate(widget.otpLength, (_) => TextEditingController());
    _otpFocusNodes = List.generate(widget.otpLength, (_) => FocusNode());
  }

  void _startTimer() {
    _timerActive = true;
    _resendTimer = 50;
    _updateTimer();
  }

  void _updateTimer() {
    if (_resendTimer > 0 && _timerActive && mounted) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _resendTimer--);
          _updateTimer();
        }
      });
    } else if (_resendTimer == 0 && mounted) {
      setState(() => _timerActive = false);
    }
  }

  void _handleOtpInput(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.otpLength - 1) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus();
      }
    }
    setState(() => _showError = false);
  }

  void _handleOtpBackspace(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      _otpControllers[index - 1].clear();
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  String _getOtpValue() {
    return _otpControllers.map((c) => c.text).join();
  }

  bool _isOtpComplete() {
    return _getOtpValue().length == widget.otpLength;
  }

  void _handleVerify() {
    if (!_isOtpComplete()) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please enter all 4 digits';
      });
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate OTP verification
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _isLoading = false);
        
        final enteredOtp = _getOtpValue();
        
        // Mock verification: accept OTP 1234
        if (enteredOtp == '1234') {
          // Success feedback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✓ Driver verified successfully!'),
              backgroundColor: AppColors.success,
              duration: const Duration(milliseconds: 1200),
            ),
          );
          
          // Navigate to driver home
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                RoutePaths.driverHome,
                (route) => false,
              );
            }
          });
        } else {
          // Invalid OTP
          setState(() {
            _showError = true;
            _errorMessage = 'Invalid OTP. Please try again.';
          });
          
          // Clear OTP fields
          for (var controller in _otpControllers) {
            controller.clear();
          }
          _otpFocusNodes[0].requestFocus();
        }
      }
    });
  }

  void _handleResend() {
    if (!_timerActive) {
      _startTimer();
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _otpFocusNodes[0].requestFocus();
      setState(() => _showError = false);
    }
  }

  String _formatTimer() {
    final minutes = _resendTimer ~/ 60;
    final seconds = _resendTimer % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.forestGreen,
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: AppColors.background,
        toolbarHeight: 48,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: isSmallScreen ? 12 : 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔐 HEADING
                    Text(
                      'Driver Verification',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.forestGreen,
                            fontSize: isSmallScreen ? 22 : 26,
                          ),
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),

                    // Subtitle with phone number
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'We\'ve sent a 4-digit OTP to\n',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                  fontSize: 13,
                                ),
                          ),
                          TextSpan(
                            text: widget.phoneNumber,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.forestGreen,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  fontSize: 13,
                                ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 20 : 28),

                    // 📱 OTP INPUT LABEL
                    Text(
                      'Enter OTP',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),

                    // 🔢 OTP INPUT BOXES
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.otpLength,
                          (index) => Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 6 : 8,
                            ),
                            child: _OtpInputField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              onChanged: (value) => _handleOtpInput(index, value),
                              onBackspace: () => _handleOtpBackspace(index),
                              isSmallScreen: isSmallScreen,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // ❌ ERROR MESSAGE - Professional
                    if (_showError)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // ⏱️ RESEND TIMER - Professional
                    Center(
                      child: GestureDetector(
                        onTap: _handleResend,
                        child: Text(
                          _timerActive
                              ? 'Resend in ${_formatTimer()}'
                              : 'Resend OTP',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _timerActive
                                    ? AppColors.textSecondary
                                    : AppColors.leafGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // ℹ️ INFO TEXT
                    Text(
                      'Didn\'t receive? Check spam folder or try again after some time.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 11,
                            height: 1.3,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ VERIFY BUTTON (Fixed at bottom)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.divider,
                    width: 0.5,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                isSmallScreen ? 8 : 10,
                20,
                isSmallScreen ? 10 : 12,
              ),
              child: SizedBox(
                width: double.infinity,
                height: isSmallScreen ? 48 : 52,
                child: ElevatedButton(
                  onPressed: _isLoading || !_isOtpComplete() ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestGreen,
                    disabledBackgroundColor: AppColors.textTertiary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          ),
                        )
                      : Text(
                          'Verify OTP',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onBackspace;
  final bool isSmallScreen;

  const _OtpInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
    this.isSmallScreen = false,
  }) : super(key: key);

  @override
  State<_OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<_OtpInputField> {
  late bool _hasFocus;

  @override
  void initState() {
    super.initState();
    _hasFocus = false;
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _hasFocus = widget.focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final boxSize = widget.isSmallScreen ? 52.0 : 60.0;
    final isFilled = widget.controller.text.isNotEmpty;

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isEmpty) {
            widget.onBackspace();
          } else {
            widget.onChanged(value);
          }
          setState(() {});
        },
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: isFilled
              ? AppColors.leafGreen.withOpacity(0.08)
              : AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.forestGreen.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _hasFocus
                  ? AppColors.forestGreen
                  : AppColors.forestGreen.withOpacity(0.15),
              width: _hasFocus ? 2 : 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.forestGreen,
              width: 2.5,
            ),
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: widget.isSmallScreen ? 22 : 26,
              letterSpacing: 2,
            ),
        cursorColor: AppColors.forestGreen,
      ),
    );
  }
}

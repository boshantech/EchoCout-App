import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/routes/route_paths.dart';
import '../bloc/driver_otp_bloc.dart';
import '../bloc/driver_otp_event.dart';
import '../bloc/driver_otp_state.dart';

class DriverOtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const DriverOtpVerificationPage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<DriverOtpVerificationPage> createState() =>
      _DriverOtpVerificationPageState();
}

class _DriverOtpVerificationPageState extends State<DriverOtpVerificationPage> {
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;

  @override
  void initState() {
    super.initState();
    _initializeOtpFields();
    // Initialize bloc with phone number
    context.read<DriverOtpBloc>().add(
          InitializeDriverOtp(phoneNumber: widget.phoneNumber),
        );
  }

  void _initializeOtpFields() {
    _otpControllers = List.generate(4, (_) => TextEditingController());
    _otpFocusNodes = List.generate(4, (_) => FocusNode());
  }

  void _handleOtpInput(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus();
      }
    }
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
    return _getOtpValue().length == 4;
  }

  void _handleVerify() {
    if (_isOtpComplete()) {
      context.read<DriverOtpBloc>().add(
            VerifyDriverOtp(otp: _getOtpValue()),
          );
    }
  }

  void _handleResend() {
    // Clear fields
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _otpFocusNodes[0].requestFocus();
    // Dispatch resend event
    context.read<DriverOtpBloc>().add(const ResendDriverOtp());
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
          onPressed: () {
            context.read<DriverOtpBloc>().add(const ResetDriverOtp());
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: AppColors.background,
        toolbarHeight: 48,
      ),
      body: BlocListener<DriverOtpBloc, DriverOtpState>(
        listener: (context, state) {
          if (state is DriverOtpVerified) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✓ Driver verified successfully!'),
                backgroundColor: AppColors.success,
                duration: const Duration(milliseconds: 1200),
              ),
            );

            // Navigate to driver home after delay
            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutePaths.driverHome,
                  (route) => false,
                );
              }
            });
          } else if (state is DriverOtpFailed) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: const Duration(milliseconds: 1500),
              ),
            );
          } else if (state is DriverOtpExpired) {
            // Show expiry message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.warning,
                duration: const Duration(milliseconds: 1500),
              ),
            );
          }
        },
        child: SafeArea(
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
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.forestGreen,
                                  fontSize: isSmallScreen ? 22 : 26,
                                ),
                      ),
                      SizedBox(height: isSmallScreen ? 6 : 8),

                      // Subtitle with masked phone
                      BlocBuilder<DriverOtpBloc, DriverOtpState>(
                        builder: (context, state) {
                          String displayPhone = 'your number';
                          if (state is DriverOtpReady ||
                              state is DriverOtpTimerUpdate) {
                            displayPhone =
                                state is DriverOtpReady ? state.phoneNumber : '+91 •••• •••• ••';
                          }

                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'We\'ve sent a 4-digit OTP to\n',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                        fontSize: 13,
                                      ),
                                ),
                                TextSpan(
                                  text: displayPhone,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.forestGreen,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 28),

                      // 📱 OTP INPUT LABEL
                      Text(
                        'Enter OTP',
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
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
                            4,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 6 : 8,
                              ),
                              child: _DriverOtpBox(
                                controller: _otpControllers[index],
                                focusNode: _otpFocusNodes[index],
                                onChanged: (value) =>
                                    _handleOtpInput(index, value),
                                onBackspace: () =>
                                    _handleOtpBackspace(index),
                                isSmallScreen: isSmallScreen,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 20),

                      // ⏱️ TIMER & RESEND
                      BlocBuilder<DriverOtpBloc, DriverOtpState>(
                        builder: (context, state) {
                          int timerSeconds = 50;
                          bool isExpired = false;

                          if (state is DriverOtpReady) {
                            timerSeconds = state.timerSeconds;
                          } else if (state is DriverOtpTimerUpdate) {
                            timerSeconds = state.remainingSeconds;
                          } else if (state is DriverOtpExpired) {
                            isExpired = true;
                          }

                          return Center(
                            child: GestureDetector(
                              onTap: (isExpired ||
                                      timerSeconds == 0)
                                  ? _handleResend
                                  : null,
                              child: Text(
                                isExpired || timerSeconds == 0
                                    ? 'Resend OTP'
                                    : 'Resend in ${_formatTimer(timerSeconds)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: (isExpired ||
                                              timerSeconds == 0)
                                          ? AppColors.leafGreen
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // ℹ️ INFO TEXT
                      Text(
                        'Didn\'t receive? Check spam folder or try again after some time.',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
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
              BlocBuilder<DriverOtpBloc, DriverOtpState>(
                builder: (context, state) {
                  final isVerifying = state is DriverOtpVerifying;
                  final isDisabled =
                      !_isOtpComplete() || isVerifying;

                  return Container(
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
                        onPressed: isDisabled ? null : _handleVerify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.forestGreen,
                          disabledBackgroundColor:
                              AppColors.textTertiary.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: isVerifying
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              )
                            : Text(
                                'Verify OTP',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔢 DRIVER OTP INPUT BOX
class _DriverOtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onBackspace;
  final bool isSmallScreen;

  const _DriverOtpBox({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
    this.isSmallScreen = false,
  }) : super(key: key);

  @override
  State<_DriverOtpBox> createState() => _DriverOtpBoxState();
}

class _DriverOtpBoxState extends State<_DriverOtpBox> {
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
    final boxSize = widget.isSmallScreen ? 52.0 : 56.0;
    final isFilled = widget.controller.text.isNotEmpty;

    return SizedBox(
      width: boxSize,
      height: 60,
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
              : Colors.white,
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
              fontSize: widget.isSmallScreen ? 20 : 24,
              letterSpacing: 1,
            ),
        cursorColor: AppColors.forestGreen,
      ),
    );
  }
}

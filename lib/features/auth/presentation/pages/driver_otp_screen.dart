import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/routes/route_paths.dart';
import '../bloc/driver_otp_bloc.dart';
import '../bloc/driver_otp_event.dart';
import '../bloc/driver_otp_state.dart';

class DriverOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const DriverOtpScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<DriverOtpScreen> createState() => _DriverOtpScreenState();
}

class _DriverOtpScreenState extends State<DriverOtpScreen> {
  // 4 Independent controllers for 4 OTP boxes
  late final TextEditingController _box1;
  late final TextEditingController _box2;
  late final TextEditingController _box3;
  late final TextEditingController _box4;

  // 4 Focus nodes
  late final FocusNode _focus1;
  late final FocusNode _focus2;
  late final FocusNode _focus3;
  late final FocusNode _focus4;

  @override
  void initState() {
    super.initState();
    _box1 = TextEditingController();
    _box2 = TextEditingController();
    _box3 = TextEditingController();
    _box4 = TextEditingController();

    _focus1 = FocusNode();
    _focus2 = FocusNode();
    _focus3 = FocusNode();
    _focus4 = FocusNode();

    // Start with focus on first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus1.requestFocus();
    });
  }

  @override
  void dispose() {
    _box1.dispose();
    _box2.dispose();
    _box3.dispose();
    _box4.dispose();

    _focus1.dispose();
    _focus2.dispose();
    _focus3.dispose();
    _focus4.dispose();

    super.dispose();
  }

  // Mask phone: +91 8123 •••• 90
  String _maskPhone(String phone) {
    if (phone.length < 4) return phone;
    final visible = phone.substring(0, 4);
    final last = phone.substring(phone.length - 2);
    return '+91 $visible •••• $last';
  }

  // Box 1 input handler
  void _handleBox1(String value) {
    if (value.isEmpty) return;
    if (value.length == 1) {
      _focus2.requestFocus();
    }
  }

  // Box 2 input handler
  void _handleBox2(String value) {
    if (value.isEmpty) return;
    if (value.length == 1) {
      _focus3.requestFocus();
    }
  }

  // Box 3 input handler
  void _handleBox3(String value) {
    if (value.isEmpty) return;
    if (value.length == 1) {
      _focus4.requestFocus();
    }
  }

  // Box 4 input handler
  void _handleBox4(String value) {
    if (value.isEmpty) return;
    if (value.length == 1) {
      _focus4.unfocus();
    }
  }

  // Handle backspace for Box 2
  void _handleBox2Backspace(String value) {
    if (value.isEmpty && _box2.text.isEmpty) {
      _box1.clear();
      _focus1.requestFocus();
    }
  }

  // Handle backspace for Box 3
  void _handleBox3Backspace(String value) {
    if (value.isEmpty && _box3.text.isEmpty) {
      _box2.clear();
      _focus2.requestFocus();
    }
  }

  // Handle backspace for Box 4
  void _handleBox4Backspace(String value) {
    if (value.isEmpty && _box4.text.isEmpty) {
      _box3.clear();
      _focus3.requestFocus();
    }
  }

  // Get complete OTP
  String _getOtp() {
    return '${_box1.text}${_box2.text}${_box3.text}${_box4.text}';
  }

  // Check if OTP is complete (all 4 boxes filled)
  bool _isOtpComplete() {
    return _box1.text.isNotEmpty &&
        _box2.text.isNotEmpty &&
        _box3.text.isNotEmpty &&
        _box4.text.isNotEmpty;
  }

  // Verify button tap
  void _handleVerify() {
    if (_isOtpComplete()) {
      context.read<DriverOtpBloc>().add(
            VerifyDriverOtp(otp: _getOtp()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.forestGreen,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<DriverOtpBloc, DriverOtpState>(
        listener: (context, state) {
          if (state is DriverOtpSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✓ Driver verified successfully!'),
                backgroundColor: AppColors.success,
                duration: const Duration(milliseconds: 1200),
              ),
            );

            // Navigate to driver home after delay
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutePaths.driverHome,
                  (route) => false,
                );
              }
            });
          } else if (state is DriverOtpError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: const Duration(milliseconds: 1500),
              ),
            );
            // Clear OTP boxes on error
            _box1.clear();
            _box2.clear();
            _box3.clear();
            _box4.clear();
            _focus1.requestFocus();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔐 TITLE
              Text(
                'Driver Verification',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.forestGreen,
                      fontSize: 26,
                    ),
              ),
              const SizedBox(height: 8),

              // 📱 SUBTITLE
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Enter the 4-digit OTP sent to\n',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                            fontSize: 14,
                          ),
                    ),
                    TextSpan(
                      text: _maskPhone(widget.phoneNumber),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.forestGreen,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // 🔢 OTP BOXES (4 INDEPENDENT)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Box 1
                  _OtpBox(
                    controller: _box1,
                    focusNode: _focus1,
                    onChanged: _handleBox1,
                    nextFocus: _focus2,
                  ),
                  const SizedBox(width: 12),

                  // Box 2
                  _OtpBox(
                    controller: _box2,
                    focusNode: _focus2,
                    onChanged: _handleBox2,
                    nextFocus: _focus3,
                    previousController: _box1,
                    previousFocus: _focus1,
                    onBackspace: _handleBox2Backspace,
                  ),
                  const SizedBox(width: 12),

                  // Box 3
                  _OtpBox(
                    controller: _box3,
                    focusNode: _focus3,
                    onChanged: _handleBox3,
                    nextFocus: _focus4,
                    previousController: _box2,
                    previousFocus: _focus2,
                    onBackspace: _handleBox3Backspace,
                  ),
                  const SizedBox(width: 12),

                  // Box 4
                  _OtpBox(
                    controller: _box4,
                    focusNode: _focus4,
                    onChanged: _handleBox4,
                    previousController: _box3,
                    previousFocus: _focus3,
                    onBackspace: _handleBox4Backspace,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ✅ VERIFY BUTTON
              BlocBuilder<DriverOtpBloc, DriverOtpState>(
                builder: (context, state) {
                  final isLoading = state is DriverOtpLoading;
                  final isDisabled = !_isOtpComplete() || isLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isDisabled ? null : _handleVerify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.forestGreen,
                        disabledBackgroundColor:
                            AppColors.textTertiary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
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
                                    fontSize: 16,
                                  ),
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ℹ️ HELP TEXT
              Center(
                child: Text(
                  'Didn\'t receive OTP? Check spam or try again.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔢 INDIVIDUAL OTP BOX WIDGET
class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String)? onBackspace;
  final FocusNode? nextFocus;
  final TextEditingController? previousController;
  final FocusNode? previousFocus;

  const _OtpBox({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onBackspace,
    this.nextFocus,
    this.previousController,
    this.previousFocus,
  }) : super(key: key);

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  late bool _isFocused;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = widget.focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
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
          widget.onChanged(value);
          setState(() {});
        },
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _isFocused ? AppColors.forestGreen : const Color(0xFFD0D5DD),
              width: _isFocused ? 2.5 : 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _isFocused ? AppColors.forestGreen : const Color(0xFFD0D5DD),
              width: _isFocused ? 2.5 : 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.forestGreen,
              width: 2.5,
            ),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
        cursorColor: AppColors.forestGreen,
      ),
    );
  }
}

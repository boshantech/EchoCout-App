import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_colors.dart';
import '../bloc/driver_auth_bloc.dart';
import '../bloc/driver_auth_event.dart';
import '../bloc/driver_auth_state.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late TextEditingController _otpController;
  String _currentOtp = '';

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _otpController.addListener(_onOtpChanged);
    
    // Auto focus OTP field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_otpFocusNode);
    });
  }

  final FocusNode _otpFocusNode = FocusNode();

  @override
  void dispose() {
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _onOtpChanged() {
    setState(() {
      _currentOtp = _otpController.text;
    });
  }

  bool get _isOtpComplete => _currentOtp.length == 4;

  void _handleVerify() {
    if (!_isOtpComplete) return;

    final authState = context.read<DriverAuthBloc>().state;
    if (authState is OtpWaitingState) {
      context.read<DriverAuthBloc>().add(
            VerifyOtpEvent(
              phoneNumber: authState.phoneNumber,
              otp: _currentOtp,
            ),
          );
    }
  }

  void _handleBackToPhone() {
    context.read<DriverAuthBloc>().add(const ResetAuthEvent());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverAuthBloc, DriverAuthState>(
      listener: (context, state) {
        if (state is DriverAuthenticatedState) {
          // Navigate to driver home
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/driver-home',
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isVerifying = state is OtpVerifyingState;
        final errorMessage = state is OtpErrorState ? state.error : null;
        final phoneNumber = state is OtpWaitingState
            ? state.maskedPhoneNumber
            : (state is OtpErrorState ? state.maskedPhoneNumber : '****');

        return WillPopScope(
          onWillPop: () async {
            _handleBackToPhone();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: _handleBackToPhone,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We\'ve sent a 4-digit OTP to\n$phoneNumber',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // OTP Input Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter OTP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _otpController,
                          focusNode: _otpFocusNode,
                          enabled: !isVerifying,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) =>
                              _isOtpComplete ? _handleVerify() : null,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: '0000',
                            hintStyle: TextStyle(
                              fontSize: 32,
                              letterSpacing: 16,
                              color: Colors.grey[300],
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[200]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Error Message
                    if (errorMessage != null)
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              border: Border.all(color: Colors.red[200]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red[700],
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 48),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            _isOtpComplete && !isVerifying ? _handleVerify : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isVerifying
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.8),
                                  ),
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Verify OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    // Validation Message
                    const SizedBox(height: 16),
                    if (!_isOtpComplete && _currentOtp.isNotEmpty)
                      Text(
                        'OTP must be exactly 4 digits',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[600],
                        ),
                      )
                    else if (_isOtpComplete)
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'OTP ready to verify',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 32),

                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(color: Colors.blue[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[700],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Test OTP',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Static OTP: 1234',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[700],
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

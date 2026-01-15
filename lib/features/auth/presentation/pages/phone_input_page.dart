import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/phone_validation.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/eco_components.dart';

class PhoneInputPage extends StatefulWidget {
  const PhoneInputPage({super.key});

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  late TextEditingController _phoneController;
  late FocusNode _phoneFocusNode;
  
  // 🇮🇳 INDIA-ONLY: Fixed country code (no country picker)
  static const String _countryCode = '+91';
  static const String _countryName = 'India';
  static const String _countryFlag = '🇮🇳';
  
  bool _syncContacts = false;
  bool _isLoading = false;
  
  // Validation state
  late PhoneValidationResult _validationResult;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _phoneFocusNode = FocusNode();
    
    // Initialize validation result as empty
    _validationResult = PhoneValidationResult.invalid(
      input: '',
      errorMessage: null,
    );
    
    // Auto-focus on phone input for better UX
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  /// Handle phone input change with validation
  void _onPhoneChanged(String value) {
    setState(() {
      _validationResult = PhoneValidator.validatePhone(
        phoneInput: value,
        countryCode: _countryCode,
      );
    });
  }

  /// Get whether phone input is valid (exactly 10 digits)
  bool get _isPhoneValid => _validationResult.isValid;

  /// Get validation error message (empty if no error or not focused)
  String get _validationErrorText {
    // Only show error if user has typed and input is invalid
    if (_phoneController.text.isEmpty) return '';
    if (_isPhoneValid) return '';
    return _validationResult.errorMessage ?? '';
  }

  void _handleContinue() {
    if (!_isPhoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_validationErrorText),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate OTP sending (mock mode)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        
        // Show success feedback
        final fullNumber = '$_countryCode${_phoneController.text.replaceAll(RegExp(r'\D'), '')}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent to $fullNumber'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to OTP verification page
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushNamed(
            context,
            '/auth/otp',
            arguments: fullNumber,
          );
        });
      }
    });
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
                  vertical: isSmallScreen ? 10 : 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🌍 HERO HEADING
                    Text(
                      'Welcome to EchoCout',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.forestGreen,
                            fontSize: isSmallScreen ? 22 : 26,
                          ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Text(
                      'Protect the planet together 🌱',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3,
                            fontSize: 13,
                          ),
                    ),
                    SizedBox(height: isSmallScreen ? 14 : 18),

                    // 🇮🇳 COUNTRY INFO (India only, non-editable)
                    EcoCard(
                      backgroundColor: AppColors.leafGreen.withOpacity(0.08),
                      child: Row(
                        children: [
                          Text(
                            _countryFlag,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 24 : 28,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 10 : 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selected Country',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textTertiary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                ),
                                SizedBox(height: isSmallScreen ? 1 : 2),
                                Text(
                                  _countryName,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.forestGreen,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _countryCode,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.forestGreen,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // 📱 PHONE NUMBER INPUT SECTION
                    Text(
                      'Phone Number',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),

                    Row(
                      children: [
                        // Fixed +91 prefix (non-editable)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 14,
                            vertical: isSmallScreen ? 10 : 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.divider,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.inputBackground,
                          ),
                          child: Text(
                            _countryCode,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.forestGreen,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 10),

                        // 10-digit phone number input
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: _onPhoneChanged,
                            decoration: InputDecoration(
                              hintText: '1234567890',
                              hintStyle: TextStyle(
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.inputBorder,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _isPhoneValid && _phoneController.text.isNotEmpty
                                      ? AppColors.success
                                      : AppColors.inputBorder,
                                  width: _isPhoneValid && _phoneController.text.isNotEmpty ? 2 : 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _validationErrorText.isNotEmpty
                                      ? AppColors.warning
                                      : AppColors.forestGreen,
                                  width: 2,
                                ),
                              ),
                              suffixIcon: _phoneController.text.isNotEmpty
                                  ? _isPhoneValid
                                      ? Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: AppColors.success,
                                            size: 20,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Icon(
                                            Icons.error_outline,
                                            color: AppColors.warning,
                                            size: 20,
                                          ),
                                        )
                                  : null,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 14,
                                vertical: isSmallScreen ? 10 : 12,
                              ),
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              isDense: true,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),

                    // VALIDATION FEEDBACK - Enhanced Professional Style
                    if (_phoneController.text.isNotEmpty && !_isPhoneValid)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.warning.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.warning,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _validationErrorText,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 11,
                                      color: AppColors.warning.withOpacity(0.9),
                                      height: 1.3,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_isPhoneValid && _phoneController.text.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '✓ Valid phone number',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    color: AppColors.success,
                                    height: 1.3,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: isSmallScreen ? 10 : 12),

                    // 📞 SYNC CONTACTS - Professional Toggle
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 14,
                        vertical: isSmallScreen ? 10 : 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.leafGreen.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.divider,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sync Contacts',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Save verified contacts automatically',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textTertiary,
                                        fontSize: 10,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: _syncContacts,
                              onChanged: (value) {
                                setState(() => _syncContacts = value);
                              },
                              activeThumbColor: AppColors.forestGreen,
                              inactiveThumbColor: AppColors.textTertiary,
                              inactiveTrackColor: AppColors.divider,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 10 : 12),

                    // Helper text
                    Text(
                      'We\'ll send a one-time OTP to verify your number.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                            height: 1.3,
                            fontSize: 11,
                          ),
                    ),

                    SizedBox(height: isSmallScreen ? 8 : 10),

                    // Driver login link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/driver-login');
                        },
                        child: Text.rich(
                          TextSpan(
                            text: 'Are you a driver? ',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.forestGreen,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🌍 CONTINUE BUTTON (Fixed at bottom - Professional)
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
              child: EcoActionButton(
                label: 'Continue',
                icon: Icons.arrow_forward,
                onPressed: _isPhoneValid && !_isLoading ? _handleContinue : null,
                isLoading: _isLoading,
                backgroundColor: AppColors.forestGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

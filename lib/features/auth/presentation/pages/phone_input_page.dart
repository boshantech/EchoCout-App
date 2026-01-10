import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputPage extends StatefulWidget {
  const PhoneInputPage({Key? key}) : super(key: key);

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  late TextEditingController _phoneController;
  late FocusNode _phoneFocusNode;
  
  String _selectedCountryCode = '+91';
  String _selectedCountryName = 'India';
  String _selectedCountryFlag = '🇮🇳';
  bool _syncContacts = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  bool get _isPhoneValid {
    return _phoneController.text.replaceAll(RegExp(r'\s'), '').length >= 9;
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _CountryPickerBottomSheet(
        onCountrySelected: (countryCode, countryName, flag) {
          setState(() {
            _selectedCountryCode = countryCode;
            _selectedCountryName = countryName;
            _selectedCountryFlag = flag;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _handleContinue() {
    if (!_isPhoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate OTP sending (mock mode)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent to $_selectedCountryCode${_phoneController.text}'),
            backgroundColor: Colors.green[400],
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to OTP verification page
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushNamed(
            context,
            '/auth/otp',
            arguments: '$_selectedCountryCode${_phoneController.text}',
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log in',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please confirm your country code and\nenter your phone number.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),

            // Country Code Picker
            GestureDetector(
              onTap: _showCountryPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedCountryFlag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _selectedCountryName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number Input
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedCountryCode,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: '000 000 0000',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF7FD8E8),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sync Contacts Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sync Contacts',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Switch(
                  value: _syncContacts,
                  onChanged: (value) {
                    setState(() => _syncContacts = value);
                  },
                  activeColor: Colors.green[400],
                  inactiveThumbColor: Colors.grey[300],
                  inactiveTrackColor: Colors.grey[200],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isPhoneValid && !_isLoading ? _handleContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Continue',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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

class _CountryPickerBottomSheet extends StatelessWidget {
  final Function(String, String, String) onCountrySelected;

  const _CountryPickerBottomSheet({
    Key? key,
    required this.onCountrySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countries = [
      ('🇫🇷', 'France', '+33'),
      ('🇬🇧', 'United Kingdom', '+44'),
      ('🇩🇪', 'Germany', '+49'),
      ('🇪🇸', 'Spain', '+34'),
      ('🇮🇹', 'Italy', '+39'),
      ('🇳🇱', 'Netherlands', '+31'),
      ('🇧🇪', 'Belgium', '+32'),
      ('🇦🇹', 'Austria', '+43'),
      ('🇵🇱', 'Poland', '+48'),
      ('🇨🇭', 'Switzerland', '+41'),
      ('🇸🇪', 'Sweden', '+46'),
      ('🇩🇰', 'Denmark', '+45'),
      ('🇳🇴', 'Norway', '+47'),
      ('🇵🇹', 'Portugal', '+351'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Country',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final (flag, name, code) = countries[index];
                return ListTile(
                  leading: Text(flag, style: const TextStyle(fontSize: 24)),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    code,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => onCountrySelected(code, name, flag),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

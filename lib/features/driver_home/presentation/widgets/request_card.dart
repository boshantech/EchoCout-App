import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/models/driver_models.dart';

/// Lightweight request card for driver home screen
/// 
/// Shows ONLY:
/// - User DP, name, phone, call button
/// - Waste type, quantity, distance
/// - Map button to view location
/// 
/// NO action buttons (those are on detail screen)
/// Tapping card navigates to detail screen
class RequestCard extends StatelessWidget {
  final PickupRequest request;
  final VoidCallback onTap;

  const RequestCard({
    Key? key,
    required this.request,
    required this.onTap,
  }) : super(key: key);

  /// Format distance nicely
  String _formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).toStringAsFixed(0)}m';
    }
    return '${km.toStringAsFixed(1)}km';
  }

  /// Open Google Maps for the pickup location
  Future<void> _openMap(BuildContext context) async {
    final latitude = request.latitude;
    final longitude = request.longitude;
    
    final googleMapsUrl = 'https://maps.google.com/?q=$latitude,$longitude';
    final gmapsUrl = Uri.parse('google.navigation:q=$latitude,$longitude&mode=d');

    try {
      if (await canLaunchUrl(gmapsUrl)) {
        await launchUrl(gmapsUrl, mode: LaunchMode.externalApplication);
      } else {
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.leafGreen.withOpacity(0.2),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // USER INFO SECTION
              Row(
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(request.userProfileImage),
                    backgroundColor: AppColors.leafGreen.withOpacity(0.1),
                  ),
                  const SizedBox(width: 12),

                  // User name and phone
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.userPhone,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Call button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.forestGreen.withOpacity(0.1),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.call,
                        color: AppColors.forestGreen,
                        size: 20,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling ${request.userPhone}...'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // WASTE DETAILS SECTION
              Row(
                children: [
                  // Waste type and quantity
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waste Type',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          request.wasteType,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${request.quantity.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Distance and OTP
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Distance',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.accentYellow.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _formatDistance(request.distanceKm),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentYellow.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _openMap(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.forestGreen.withOpacity(0.1),
                              border: Border.all(
                                color: AppColors.forestGreen.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: AppColors.forestGreen,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'View Map',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.forestGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Tap hint
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.leafGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info,
                      size: 14,
                      color: AppColors.leafGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tap to view details & take action',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.leafGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

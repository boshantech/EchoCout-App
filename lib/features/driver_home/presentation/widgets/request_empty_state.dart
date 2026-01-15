import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/managers/driver_state_manager.dart';

/// Empty state widget for request lists
class RequestEmptyState extends StatelessWidget {
  final RequestFilter filter;

  const RequestEmptyState({
    super.key,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon based on filter type
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getIcon(),
                size: 48,
                color: _getIconColor(),
              ),
            ),
            const SizedBox(height: 16),
            // Title based on filter type
            Text(
              _getTitle(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle based on filter type
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _getSubtitle(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (filter) {
      case RequestFilter.active:
        return Icons.inbox_outlined;
      case RequestFilter.hidden:
        return Icons.visibility_off_rounded;
      case RequestFilter.transferred:
        return Icons.person_add_outlined;
      case RequestFilter.transferredToMe:
        return Icons.arrow_downward_rounded;
    }
  }

  Color _getIconColor() {
    switch (filter) {
      case RequestFilter.active:
        return AppColors.textTertiary;
      case RequestFilter.hidden:
        return Colors.grey[400]!;
      case RequestFilter.transferred:
        return AppColors.leafGreen.withOpacity(0.5);
      case RequestFilter.transferredToMe:
        return AppColors.leafGreen.withOpacity(0.5);
    }
  }

  Color _getBackgroundColor() {
    switch (filter) {
      case RequestFilter.active:
        return AppColors.forestGreen.withOpacity(0.08);
      case RequestFilter.hidden:
        return Colors.grey[200]!;
      case RequestFilter.transferred:
        return AppColors.leafGreen.withOpacity(0.08);
      case RequestFilter.transferredToMe:
        return AppColors.leafGreen.withOpacity(0.08);
    }
  }

  String _getTitle() {
    switch (filter) {
      case RequestFilter.active:
        return 'No Active Requests';
      case RequestFilter.hidden:
        return 'No Hidden Requests';
      case RequestFilter.transferred:
        return 'No Transferred Requests';
      case RequestFilter.transferredToMe:
        return 'No Pending Transfers';
    }
  }

  String _getSubtitle() {
    switch (filter) {
      case RequestFilter.active:
        return 'New requests will appear here\nwhen someone needs waste collection';
      case RequestFilter.hidden:
        return 'You haven\'t hidden any requests yet.\nTap the hide button on any request to hide it';
      case RequestFilter.transferred:
        return 'You haven\'t transferred any requests yet.\nTransfer requests to other drivers when needed';
      case RequestFilter.transferredToMe:
        return 'No requests have been transferred to you.\nRequests transferred by other drivers appear here';
    }
  }
}

import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/managers/driver_state_manager.dart';

/// Request filter tabs widget with badge counts
class RequestFilterTabs extends StatelessWidget {
  final RequestFilter currentFilter;
  final int activeCount;
  final int hiddenCount;
  final int transferredCount;
  final int transferredToMeCount;
  final ValueChanged<RequestFilter> onFilterChanged;

  const RequestFilterTabs({
    super.key,
    required this.currentFilter,
    required this.activeCount,
    required this.hiddenCount,
    required this.transferredCount,
    required this.transferredToMeCount,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Active Filter
          _FilterChip(
            label: 'Active',
            count: activeCount,
            isSelected: currentFilter == RequestFilter.active,
            onTap: () => onFilterChanged(RequestFilter.active),
          ),
          const SizedBox(width: 10),
          // For Me Filter
          _FilterChip(
            label: 'For Me',
            count: transferredToMeCount,
            isSelected: currentFilter == RequestFilter.transferredToMe,
            onTap: () => onFilterChanged(RequestFilter.transferredToMe),
          ),
          const SizedBox(width: 10),
          // Hidden Filter
          _FilterChip(
            label: 'Hidden',
            count: hiddenCount,
            isSelected: currentFilter == RequestFilter.hidden,
            onTap: () => onFilterChanged(RequestFilter.hidden),
          ),
          const SizedBox(width: 10),
          // Transferred Filter
          _FilterChip(
            label: 'Transferred',
            count: transferredCount,
            isSelected: currentFilter == RequestFilter.transferred,
            onTap: () => onFilterChanged(RequestFilter.transferred),
          ),
        ],
      ),
    );
  }
}

/// Individual filter chip with badge
class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.forestGreen
              : AppColors.forestGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.forestGreen
                : AppColors.forestGreen.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.forestGreen,
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Badge with count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : AppColors.accentYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.forestGreen : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

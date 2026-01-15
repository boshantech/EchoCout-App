import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/models/driver_models.dart';

class _EarningsCard extends StatefulWidget {
  final DriverProfile? driver;

  const _EarningsCard({
    Key? key,
    required this.driver,
  }) : super(key: key);

  @override
  State<_EarningsCard> createState() => __EarningsCardState();
}

class __EarningsCardState extends State<_EarningsCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.driver;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.leafGreen.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (Always Visible)
          GestureDetector(
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.forestGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 20,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Earnings & Stats',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Tap to expand',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_less_rounded,
                      size: 24,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content (Expandable)
          SizeTransition(
            sizeFactor: _animationController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  Divider(
                    color: AppColors.leafGreen.withOpacity(0.1),
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 14),

                  // Earnings Grid
                  Row(
                    children: [
                      // Total Earned
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.trending_up_rounded,
                          label: 'Total Earned',
                          value: '₹${driver?.totalEarned.toStringAsFixed(0) ?? '0'}',
                          color: AppColors.leafGreen,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Withdrawn
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.download_rounded,
                          label: 'Withdrawn',
                          value: '₹${driver?.amountWithdrawn.toStringAsFixed(0) ?? '0'}',
                          color: AppColors.accentYellow,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      // Points
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.star_rounded,
                          label: 'Points',
                          value: '${driver?.pointsEarned.toStringAsFixed(0) ?? '0'}',
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Nature Saved
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.eco_rounded,
                          label: 'Nature Saved',
                          value: '${driver?.natureSavedPercentage.toStringAsFixed(1) ?? '0'}%',
                          color: AppColors.leafGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

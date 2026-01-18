import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/managers/driver_state_manager.dart';

class FilterBottomSheet extends StatefulWidget {
  final DriverStateManager driverStateManager;

  const FilterBottomSheet({
    super.key,
    required this.driverStateManager,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TextEditingController _locationController;
  late TextEditingController _nameController;
  double _minQuantity = 0;
  double _maxQuantity = 500;
  double _minDistance = 0;
  double _maxDistance = 1000;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Requests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 24,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Location Filter
              _buildFilterField(
                label: 'Location',
                controller: _locationController,
                hint: 'Search by location',
                icon: Icons.location_on_rounded,
              ),

              const SizedBox(height: 16),

              // Name Filter
              _buildFilterField(
                label: 'Request Name / Type',
                controller: _nameController,
                hint: 'Search by name',
                icon: Icons.label_rounded,
              ),

              const SizedBox(height: 16),

              // Quantity Range
              Text(
                'Quantity Range (kg)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Min Quantity
                  Expanded(
                    child: _buildRangeSlider(
                      label: 'Min',
                      value: _minQuantity,
                      maxValue: 500,
                      onDecrement: () {
                        setState(() {
                          if (_minQuantity > 0) {
                            _minQuantity = (_minQuantity - 10).clamp(0, 500);
                          }
                        });
                      },
                      onIncrement: () {
                        setState(() {
                          if (_minQuantity < _maxQuantity) {
                            _minQuantity = (_minQuantity + 10).clamp(0, _maxQuantity);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Max Quantity
                  Expanded(
                    child: _buildRangeSlider(
                      label: 'Max',
                      value: _maxQuantity,
                      maxValue: 500,
                      onDecrement: () {
                        setState(() {
                          if (_maxQuantity > _minQuantity) {
                            _maxQuantity = (_maxQuantity - 10).clamp(_minQuantity, 500);
                          }
                        });
                      },
                      onIncrement: () {
                        setState(() {
                          if (_maxQuantity < 500) {
                            _maxQuantity = (_maxQuantity + 10).clamp(_minQuantity, 500);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Distance Range
              Text(
                'Distance Range (km)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Min Distance
                  Expanded(
                    child: _buildRangeSlider(
                      label: 'Min',
                      value: _minDistance,
                      maxValue: 1000,
                      onDecrement: () {
                        setState(() {
                          if (_minDistance > 0) {
                            _minDistance = (_minDistance - 10).clamp(0, 1000);
                          }
                        });
                      },
                      onIncrement: () {
                        setState(() {
                          if (_minDistance < _maxDistance) {
                            _minDistance = (_minDistance + 10).clamp(0, _maxDistance);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Max Distance
                  Expanded(
                    child: _buildRangeSlider(
                      label: 'Max',
                      value: _maxDistance,
                      maxValue: 1000,
                      onDecrement: () {
                        setState(() {
                          if (_maxDistance > _minDistance) {
                            _maxDistance = (_maxDistance - 10).clamp(_minDistance, 1000);
                          }
                        });
                      },
                      onIncrement: () {
                        setState(() {
                          if (_maxDistance < 1000) {
                            _maxDistance = (_maxDistance + 10).clamp(_minDistance, 1000);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  // Clear Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _clearFilters,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.accentYellow,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'Clear',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentYellow,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Apply Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _applyFilters,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.forestGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Apply',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.leafGreen.withOpacity(0.08),
            border: Border.all(
              color: AppColors.leafGreen.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textTertiary.withOpacity(0.6),
                fontSize: 13,
              ),
              prefixIcon: Icon(
                icon,
                size: 18,
                color: AppColors.forestGreen.withOpacity(0.6),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRangeSlider({
    required String label,
    required double value,
    required double maxValue,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.leafGreen.withOpacity(0.08),
        border: Border.all(
          color: AppColors.leafGreen.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Decrease Button
              GestureDetector(
                onTap: onDecrement,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    size: 16,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
              // Value Display
              Text(
                value.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              // Increase Button
              GestureDetector(
                onTap: onIncrement,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    widget.driverStateManager.applyFilters(
      location: _locationController.text.trim(),
      name: _nameController.text.trim(),
      minQuantity: _minQuantity > 0 ? _minQuantity : null,
      maxQuantity: _maxQuantity < 500 ? _maxQuantity : null,
      minDistance: _minDistance > 0 ? _minDistance : null,
      maxDistance: _maxDistance < 1000 ? _maxDistance : null,
    );
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _locationController.clear();
      _nameController.clear();
      _minQuantity = 0;
      _maxQuantity = 500;
      _minDistance = 0;
      _maxDistance = 1000;
    });
    widget.driverStateManager.clearAdvancedFilters();
    Navigator.pop(context);
  }
}

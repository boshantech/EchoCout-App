import 'package:flutter/material.dart';
import '../../../../../config/theme/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  final double quantity;
  final double minQuantity;
  final ValueChanged<double> onQuantityChanged;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    this.minQuantity = 3.0,
    required this.onQuantityChanged,
  }) : super(key: key);

  void _decreaseQuantity() {
    if (quantity > minQuantity) {
      onQuantityChanged(quantity - 1.0);
    }
  }

  void _increaseQuantity() {
    onQuantityChanged(quantity + 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantity (KG)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: quantity.toStringAsFixed(1)),
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(8),
                              ),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (quantity < minQuantity)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Minimum $minQuantity KG required',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.error,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  GestureDetector(
                    onTap: _increaseQuantity,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _decreaseQuantity,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: quantity > minQuantity ? AppColors.primary : AppColors.disabled,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

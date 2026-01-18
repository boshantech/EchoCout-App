import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/theme/app_colors.dart';
import '../bloc/waste_item_bloc.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/invoice_card.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/success_popup.dart';

class WasteItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> wasteItem;

  const WasteItemDetailScreen({
    super.key,
    required this.wasteItem,
  });

  @override
  State<WasteItemDetailScreen> createState() => _WasteItemDetailScreenState();
}

class _WasteItemDetailScreenState extends State<WasteItemDetailScreen> {
  late WasteItemBloc _wasteItemBloc;

  @override
  void initState() {
    super.initState();
    _wasteItemBloc = WasteItemBloc();
    _wasteItemBloc.add(LoadWasteItem(widget.wasteItem));
  }

  @override
  void dispose() {
    _wasteItemBloc.close();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context, Map<String, dynamic> item, double quantity, double totalPrice) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessPopup(
        itemName: item['name'] ?? 'Item',
        quantity: quantity,
        totalAmount: totalPrice,
        onDismiss: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/main');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WasteItemBloc>.value(
      value: _wasteItemBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sell Waste'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocListener<WasteItemBloc, WasteItemState>(
          listener: (context, state) {
            if (state is SellSuccess) {
              _showSuccessDialog(
                context,
                state.item,
                state.quantity,
                state.totalPrice,
              );
            } else if (state is SellError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: BlocBuilder<WasteItemBloc, WasteItemState>(
            builder: (context, state) {
              if (state is WasteItemInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is WasteItemLoaded ||
                  state is InvoiceUpdating ||
                  state is ReadyToSell ||
                  state is Selling) {
                final item = state is WasteItemLoaded
                    ? state.item
                    : state is InvoiceUpdating
                        ? state.item
                        : state is ReadyToSell
                            ? state.item
                            : (state as Selling).item;

                final quantity = state is WasteItemLoaded
                    ? state.quantity
                    : state is InvoiceUpdating
                        ? state.quantity
                        : state is ReadyToSell
                            ? state.quantity
                            : (state as Selling).quantity;

                final imagePath = state is WasteItemLoaded
                    ? state.imagePath
                    : state is InvoiceUpdating
                        ? state.imagePath
                        : state is ReadyToSell
                            ? state.imagePath
                            : (state as Selling).imagePath;

                final totalPrice = state is WasteItemLoaded
                    ? state.totalPrice
                    : state is InvoiceUpdating
                        ? state.totalPrice
                        : state is ReadyToSell
                            ? state.totalPrice
                            : (state as Selling).totalPrice;

                final isLoading = state is Selling;
                final isReadyToSell = state is ReadyToSell;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item Header
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item['image'] ?? '',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.inputBackground,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: AppColors.illustrationGray,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] ?? 'Item',
                                        style: Theme.of(context).textTheme.headlineMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          item['category'] ?? 'Category',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppColors.primary,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '₹${item['price']}',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            color: AppColors.primary,
                                          ),
                                    ),
                                    Text(
                                      'per KG',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quantity Selector
                      QuantitySelector(
                        quantity: quantity,
                        onQuantityChanged: (newQuantity) {
                          context.read<WasteItemBloc>().add(
                                UpdateQuantity(newQuantity),
                              );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Invoice Card
                      InvoiceCard(
                        itemName: item['name'] ?? 'Item',
                        pricePerKg: (item['price'] as num).toDouble(),
                        quantity: quantity,
                        totalAmount: totalPrice,
                      ),
                      const SizedBox(height: 20),

                      // Image Picker
                      ImagePickerWidget(
                        imagePath: imagePath,
                        onImageSelected: (path) {
                          context.read<WasteItemBloc>().add(
                                SelectImage(path),
                              );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Sell Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isReadyToSell && !isLoading
                              ? () {
                                  context.read<WasteItemBloc>().add(
                                        const SellWasteItem(),
                                      );
                                }
                              : null,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Sell Now'),
                        ),
                      ),
                      if (quantity < 3.0 || imagePath == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    quantity < 3.0
                                        ? 'Minimum 3 KG required'
                                        : 'Photo is required',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.warning,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

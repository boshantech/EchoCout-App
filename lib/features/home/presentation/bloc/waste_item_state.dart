part of 'waste_item_bloc.dart';

abstract class WasteItemState extends Equatable {
  const WasteItemState();

  @override
  List<Object?> get props => [];
}

class WasteItemInitial extends WasteItemState {
  const WasteItemInitial();
}

class WasteItemLoaded extends WasteItemState {
  final Map<String, dynamic> item;
  final double quantity;
  final String? imagePath;
  final double totalPrice;

  const WasteItemLoaded({
    required this.item,
    required this.quantity,
    this.imagePath,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [item, quantity, imagePath, totalPrice];
}

class InvoiceUpdating extends WasteItemState {
  final Map<String, dynamic> item;
  final double quantity;
  final String? imagePath;
  final double totalPrice;

  const InvoiceUpdating({
    required this.item,
    required this.quantity,
    this.imagePath,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [item, quantity, imagePath, totalPrice];
}

class ReadyToSell extends WasteItemState {
  final Map<String, dynamic> item;
  final double quantity;
  final String imagePath;
  final double totalPrice;

  const ReadyToSell({
    required this.item,
    required this.quantity,
    required this.imagePath,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [item, quantity, imagePath, totalPrice];
}

class Selling extends WasteItemState {
  final Map<String, dynamic> item;
  final double quantity;
  final String imagePath;
  final double totalPrice;

  const Selling({
    required this.item,
    required this.quantity,
    required this.imagePath,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [item, quantity, imagePath, totalPrice];
}

class SellSuccess extends WasteItemState {
  final Map<String, dynamic> item;
  final double quantity;
  final double totalPrice;

  const SellSuccess({
    required this.item,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [item, quantity, totalPrice];
}

class SellError extends WasteItemState {
  final String message;

  const SellError(this.message);

  @override
  List<Object?> get props => [message];
}

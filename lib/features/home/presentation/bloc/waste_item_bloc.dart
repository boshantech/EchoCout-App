import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'waste_item_event.dart';
part 'waste_item_state.dart';

class WasteItemBloc extends Bloc<WasteItemEvent, WasteItemState> {
  WasteItemBloc() : super(const WasteItemInitial()) {
    on<LoadWasteItem>(_onLoadWasteItem);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<SelectImage>(_onSelectImage);
    on<SellWasteItem>(_onSellWasteItem);
    on<ClearSelection>(_onClearSelection);
  }

  Future<void> _onLoadWasteItem(
    LoadWasteItem event,
    Emitter<WasteItemState> emit,
  ) async {
    emit(WasteItemLoaded(
      item: event.item,
      quantity: 3.0,
      imagePath: null,
      totalPrice: _calculateTotal(event.item, 3.0),
    ));
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<WasteItemState> emit,
  ) async {
    final currentState = state;
    if (currentState is! WasteItemLoaded && currentState is! InvoiceUpdating && currentState is! ReadyToSell) {
      return;
    }

    final item = currentState is WasteItemLoaded
        ? currentState.item
        : currentState is InvoiceUpdating
            ? currentState.item
            : (currentState as ReadyToSell).item;

    final imagePath = currentState is WasteItemLoaded
        ? currentState.imagePath
        : currentState is InvoiceUpdating
            ? currentState.imagePath
            : (currentState as ReadyToSell).imagePath;

    final totalPrice = _calculateTotal(item, event.quantity);

    if (event.quantity >= 3.0 && imagePath != null) {
      emit(ReadyToSell(
        item: item,
        quantity: event.quantity,
        imagePath: imagePath,
        totalPrice: totalPrice,
      ));
    } else {
      emit(InvoiceUpdating(
        item: item,
        quantity: event.quantity,
        imagePath: imagePath,
        totalPrice: totalPrice,
      ));
    }
  }

  Future<void> _onSelectImage(
    SelectImage event,
    Emitter<WasteItemState> emit,
  ) async {
    final currentState = state;
    if (currentState is! WasteItemLoaded && currentState is! InvoiceUpdating && currentState is! ReadyToSell) {
      return;
    }

    final item = currentState is WasteItemLoaded
        ? currentState.item
        : currentState is InvoiceUpdating
            ? currentState.item
            : (currentState as ReadyToSell).item;

    final quantity = currentState is WasteItemLoaded
        ? currentState.quantity
        : currentState is InvoiceUpdating
            ? currentState.quantity
            : (currentState as ReadyToSell).quantity;

    if (quantity >= 3.0) {
      emit(ReadyToSell(
        item: item,
        quantity: quantity,
        imagePath: event.imagePath,
        totalPrice: _calculateTotal(item, quantity),
      ));
    } else {
      emit(InvoiceUpdating(
        item: item,
        quantity: quantity,
        imagePath: event.imagePath,
        totalPrice: _calculateTotal(item, quantity),
      ));
    }
  }

  Future<void> _onSellWasteItem(
    SellWasteItem event,
    Emitter<WasteItemState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ReadyToSell) return;

    emit(Selling(
      item: currentState.item,
      quantity: currentState.quantity,
      imagePath: currentState.imagePath,
      totalPrice: currentState.totalPrice,
    ));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    emit(SellSuccess(
      item: currentState.item,
      quantity: currentState.quantity,
      totalPrice: currentState.totalPrice,
    ));
  }

  Future<void> _onClearSelection(
    ClearSelection event,
    Emitter<WasteItemState> emit,
  ) async {
    emit(const WasteItemInitial());
  }

  double _calculateTotal(Map<String, dynamic> item, double quantity) {
    final price = (item['price'] as num).toDouble();
    return price * quantity;
  }
}

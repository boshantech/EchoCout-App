part of 'waste_item_bloc.dart';

abstract class WasteItemEvent extends Equatable {
  const WasteItemEvent();

  @override
  List<Object?> get props => [];
}

class LoadWasteItem extends WasteItemEvent {
  final Map<String, dynamic> item;

  const LoadWasteItem(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateQuantity extends WasteItemEvent {
  final double quantity;

  const UpdateQuantity(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

class SelectImage extends WasteItemEvent {
  final String imagePath;

  const SelectImage(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class SellWasteItem extends WasteItemEvent {
  const SellWasteItem();

  @override
  List<Object?> get props => [];
}

class ClearSelection extends WasteItemEvent {
  const ClearSelection();

  @override
  List<Object?> get props => [];
}

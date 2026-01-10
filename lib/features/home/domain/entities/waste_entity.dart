import 'package:equatable/equatable.dart';

class WasteCategory extends Equatable {
  final String id;
  final String name;
  final String icon;
  final double pricePerUnit;
  final String unit;

  const WasteCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.pricePerUnit,
    required this.unit,
  });

  @override
  List<Object?> get props => [id, name, icon, pricePerUnit, unit];
}

class WasteItem extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final double pricePerUnit;
  final String unit;
  final String? imageUrl;

  const WasteItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.pricePerUnit,
    required this.unit,
    this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [id, categoryId, name, pricePerUnit, unit, imageUrl];
}

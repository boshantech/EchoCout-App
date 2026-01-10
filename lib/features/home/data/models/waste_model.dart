import 'package:equatable/equatable.dart';

class WasteCategoryModel extends Equatable {
  final String id;
  final String name;
  final String icon;
  final double pricePerUnit;
  final String unit;

  const WasteCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.pricePerUnit,
    required this.unit,
  });

  factory WasteCategoryModel.fromJson(Map<String, dynamic> json) {
    return WasteCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, pricePerUnit, unit];
}

class WasteItemModel extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final double pricePerUnit;
  final String unit;
  final String? imageUrl;

  const WasteItemModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.pricePerUnit,
    required this.unit,
    this.imageUrl,
  });

  factory WasteItemModel.fromJson(Map<String, dynamic> json) {
    return WasteItemModel(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      unit: json['unit'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [id, categoryId, name, pricePerUnit, unit, imageUrl];
}

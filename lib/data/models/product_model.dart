import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.imageUrl,
    required super.stockQuantity,
    required super.category,
    super.isAvailable,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String categoryName = 'General';
    if (json['category'] is Map) {
      categoryName = json['category']['name']?.toString() ?? 'General';
    } else if (json['category'] != null) {
      categoryName = json['category'].toString();
    }

    bool available = true;
    if (json['status'] != null) {
      available = json['status'].toString().toUpperCase() == 'ACT';
    } else if (json['isAvailable'] != null) {
      available = json['isAvailable'] as bool;
    } else if (json['available'] != null) {
      available = json['available'] as bool;
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString(),
      stockQuantity:
          (json['stockQuantity'] as num?)?.toInt() ??
          (json['stock'] as num?)?.toInt() ??
          0,
      category: categoryName,
      isAvailable: available,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stockQuantity': stockQuantity,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      stockQuantity: entity.stockQuantity,
      category: entity.category,
      isAvailable: entity.isAvailable,
    );
  }
}

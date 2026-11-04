class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final int stockQuantity;
  final String category;
  final bool isAvailable;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.stockQuantity,
    required this.category,
    this.isAvailable = true,
  });
}

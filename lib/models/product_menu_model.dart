class ProductMenu {
  final String menuId;
  final String id;
  final String productName;
  final num actualPrice;
  final num supplierPrice;
  final String description;
  final String supplierId;
  final String supplierName;
  final String categoryName;
  final String address;
  final List<ProductImage> images;

  ProductMenu({
    required this.menuId,
    required this.id,
    required this.productName,
    required this.actualPrice,
    required this.supplierPrice,
    required this.description,
    required this.supplierId,
    required this.supplierName,
    required this.categoryName,
    required this.address,
    required this.images,
  });

  factory ProductMenu.fromJson(Map<String, dynamic> json) {
    final List<dynamic> imagesJson = json['images'];

    return ProductMenu(
      menuId: json['menuId'],
      id: json['id'],
      productName: json['productName'],
      actualPrice: json['actualPrice'].toDouble(),
      supplierPrice: json['supplierPrice'].toDouble(),
      description: json['description'],
      supplierId: json['supplierId'],
      supplierName: json['supplierName'],
      categoryName: json['categoryName'],
      address: json['address'],
      images: imagesJson
          .map((imageJson) => ProductImage.fromJson(imageJson))
          .toList(),
    );
  }
}

class ProductImage {
  final String fileURL;
  final String fileName;

  ProductImage({
    required this.fileURL,
    required this.fileName,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      fileURL: json['fileURL'],
      fileName: json['fileName'],
    );
  }
}

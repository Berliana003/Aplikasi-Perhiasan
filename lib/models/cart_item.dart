import 'package:flutter_application_1/models/product.dart';

class CartItem {
  final Product product;
  final Map<String, String>? selectedVariations;
  int quantity;

  CartItem({
    required this.product,
    this.selectedVariations,
    this.quantity = 1,
    String? selectedVariation,
  });

  double get totalPrice {
    return product.getFinalPrice() * quantity;
  }

  @override
  String toString() {
    return "${product.name} (${selectedVariations ?? "Default"}) x$quantity = Rp$totalPrice";
  }
}

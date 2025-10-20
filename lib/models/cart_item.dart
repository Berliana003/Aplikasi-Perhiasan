import 'package:flutter_application_1/models/product.dart';

class CartItem {
  final Product product;
  final Map<String, String>? selectedVariations;
  int quantity;
  Map<String, String>? variations;

  CartItem({
    required this.product,
    required this.quantity,
    this.selectedVariations,
    String? selectedVariation,
  });

  double get totalPrice => product.getFinalPrice() * quantity;

  @override
  String toString() {
    return "${product.name} (${selectedVariations ?? "Default"}) x$quantity = Rp$totalPrice";
  }
}

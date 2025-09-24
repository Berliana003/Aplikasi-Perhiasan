import 'product.dart';

class Order {
  final Product product;
  final int quantity;
  final String address;
  final String paymentMethod;
  final double total;
  final DateTime date;

  Order({
    required this.product,
    required this.quantity,
    required this.address,
    required this.paymentMethod,
    required this.total,
    required this.date,
  });
}

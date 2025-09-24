import 'order.dart';

class OrderHistory {
  static List<Order> orders = [];

  static void addOrder(Order order) {
    orders.add(order);
  }
}

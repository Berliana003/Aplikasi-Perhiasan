import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/order_history.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderHistory.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pemesanan"),
        backgroundColor: Colors.blue,
      ),
      body: orders.isEmpty
          ? const Center(child: Text("Belum ada pesanan"))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      order.product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(order.product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Jumlah: ${order.quantity}"),
                        Text("Metode: ${order.paymentMethod}"),
                        Text("Total: Rp ${order.total.toStringAsFixed(0)}"),
                        Text(
                          "Tanggal: ${DateFormat('dd/MM/yyyy HH:mm').format(order.date)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

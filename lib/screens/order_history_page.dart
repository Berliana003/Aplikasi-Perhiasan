import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/order_history.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderHistory.orders;
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Riwayat Pemesanan",
          style: GoogleFonts.youngSerif(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                "Belum ada pesanan",
                style: GoogleFonts.arvo(fontSize: 14, color: Colors.grey[700]),
              ),
            )
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
                    title: Text(
                      order.product.name,
                      style: GoogleFonts.youngSerif(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jumlah: ${order.quantity}",
                          style: GoogleFonts.arvo(fontSize: 14),
                        ),
                        Text(
                          "Metode: ${order.paymentMethod}",
                          style: GoogleFonts.arvo(fontSize: 14),
                        ),
                        Text(
                          "Total: ${formatCurrency.format(order.total)}",
                          style: GoogleFonts.arvo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Tanggal: ${DateFormat('dd/MM/yyyy HH:mm').format(order.date)}",
                          style: GoogleFonts.arvo(
                            fontSize: 14,
                            color: Colors.grey[700],
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

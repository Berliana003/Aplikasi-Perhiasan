import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy notifikasi
    final List<Map<String, dynamic>> notifications = [
      {
        "name": "Sistem Toko",
        "message":
            "Pesanan #INV123456 baru saja dibuat. Harap segera diproses.",
        "time": "5 mins ago",
        "highlight": true,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Sistem Pembayaran",
        "message":
            "Pembayaran untuk pesanan #INV123456 telah berhasil diverifikasi.",
        "time": "20 mins ago",
        "highlight": true,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Sistem Pembayaran",
        "message":
            "Pembayaran untuk pesanan #INV654321 gagal. Harap cek detailnya.",
        "time": "25 mins ago",
        "highlight": true,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Pengiriman",
        "message":
            "Pesanan #INV123456 sudah dikirim oleh kurir JNE dengan resi JP012345.",
        "time": "1 hr ago",
        "highlight": false,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Pengiriman",
        "message": "Pesanan #INV123456 sudah diterima oleh pembeli.",
        "time": "2 hrs ago",
        "highlight": false,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Pembatalan",
        "message":
            "Pembeli mengajukan pembatalan pesanan #INV987654. Harap ditinjau.",
        "time": "3 hrs ago",
        "highlight": true,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Retur & Refund",
        "message":
            "Permintaan retur/refund untuk pesanan #INV987654 menunggu konfirmasi Anda.",
        "time": "4 hrs ago",
        "highlight": true,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Stok Barang",
        "message":
            "Stok Kalung Emas Premium tersisa 2 pcs. Pertimbangkan untuk restok.",
        "time": "6 hrs ago",
        "highlight": true,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Ulasan Pelanggan",
        "message": "Pembeli memberikan ulasan 5⭐ pada pesanan #INV123456.",
        "time": "8 hrs ago",
        "highlight": false,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Ulasan Pelanggan",
        "message":
            "Pembeli memberikan ulasan negatif, mohon segera ditindaklanjuti.",
        "time": "9 hrs ago",
        "highlight": true,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Promo & Voucher",
        "message":
            "Voucher DISKON20 akan berakhir besok. Pastikan stok mencukupi.",
        "time": "12 hrs ago",
        "highlight": false,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Saldo",
        "message":
            "Dana dari pesanan #INV123456 sebesar Rp250.000 sudah masuk ke saldo Anda.",
        "time": "1 day ago",
        "highlight": true,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Pencairan Dana",
        "message": "Permintaan pencairan dana Rp1.000.000 sedang diproses.",
        "time": "2 days ago",
        "highlight": false,
        "avatar": "assets/image/default.jpg",
      },
    ];

    // hitung jumlah unread (highlight = true)
    final unreadCount = notifications
        .where((n) => n["highlight"] == true)
        .length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Notifikasi Admin",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      notif["avatar"] ?? "assets/images/default.png",
                    ),
                    radius: 24,
                  ),
                  title: Text(
                    notif["name"]!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: notif["highlight"] == true
                          ? Colors.blue[800]
                          : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    notif["message"]!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    notif["time"]!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              "Lihat semua aktivitas",
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

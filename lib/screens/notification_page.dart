import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> filteredNotifications = [];

  @override
  void initState() {
    super.initState();

    // Data dummy
    notifications = [
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
            "Dana dari pesanan #INV123456 sebesar Rp525.000 sudah masuk ke saldo Anda.",
        "time": "1 day ago",
        "highlight": true,
        "avatar": "assets/image/default.jpg",
      },
      {
        "name": "Pencairan Dana",
        "message": "Permintaan pencairan dana Rp2.000.000 sedang diproses.",
        "time": "2 days ago",
        "highlight": false,
        "avatar": "assets/image/default.jpg",
      },
    ];

    filteredNotifications = List.from(notifications);
  }

  void _searchNotifications(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNotifications = List.from(notifications);
      } else {
        filteredNotifications = notifications
            .where(
              (n) =>
                  n["name"].toLowerCase().contains(query.toLowerCase()) ||
                  n["message"].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notif in notifications) {
        notif["highlight"] = false;
      }
      filteredNotifications = List.from(notifications);
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications.remove(filteredNotifications[index]);
      filteredNotifications.removeAt(index);
    });
  }

  void _deleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Hapus Semua Notifikasi",
          style: GoogleFonts.patuaOne(fontSize: 20),
        ),
        content: Text(
          "Apakah Anda yakin ingin menghapus semua notifikasi?",
          style: GoogleFonts.arvo(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Batal",
              style: GoogleFonts.cinzel(
                color: const Color(0xFF0D47A1),
                fontSize: 15,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                notifications.clear();
                filteredNotifications.clear();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              "Hapus",
              style: GoogleFonts.cinzel(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications
        .where((n) => n["highlight"] == true)
        .length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Notifikasi Admin",
          style: GoogleFonts.youngSerif(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.notifications, color: Colors.white, size: 28),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 11,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchNotifications,
              decoration: InputDecoration(
                hintText: "Cari notifikasi...",
                hintStyle: GoogleFonts.berkshireSwash(),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Tombol aksi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _markAllAsRead,
                  icon: const Icon(
                    Icons.done_all,
                    size: 18,
                    color: Color(0xFF0D47A1),
                  ),
                  label: Text(
                    "Tandai semua dibaca",
                    style: GoogleFonts.cinzel(
                      fontSize: 15,
                      color: const Color(0xFF0D47A1),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF0D47A1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _deleteAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_forever,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Hapus semua",
                    style: GoogleFonts.cinzel(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Daftar notifikasi
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Text(
                      "Tidak ada notifikasi",
                      style: GoogleFonts.arvo(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notif = filteredNotifications[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(notif["avatar"]),
                          radius: 24,
                        ),
                        title: Text(
                          notif["name"],
                          style: GoogleFonts.patuaOne(
                            color: notif["highlight"] == true
                                ? const Color(0xFF0D47A1)
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          notif["message"],
                          style: GoogleFonts.arvo(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          notif["time"],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Hapus Notifikasi",
                                style: GoogleFonts.patuaOne(fontSize: 20),
                              ),
                              content: Text(
                                "Apakah Anda yakin ingin menghapus notifikasi ini?",
                                style: GoogleFonts.arvo(fontSize: 15),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Batal",
                                    style: GoogleFonts.cinzel(
                                      color: const Color(0xFF0D47A1),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    _deleteNotification(index);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Hapus",
                                    style: GoogleFonts.cinzel(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

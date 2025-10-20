import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  String query = "";

  final List<Map<String, String>> activeUsers = [
    {"name": "Deffan", "avatar": "assets/image/pp1.jpg"},
    {"name": "Raka", "avatar": "assets/image/pp2.jpg"},
    {"name": "Rangga", "avatar": "assets/image/pp3.jpg"},
    {"name": "Sasya", "avatar": "assets/image/pp4.jpg"},
  ];

  final List<Map<String, String>> messages = [
    {
      "name": "Deffan",
      "message": "Apakah cincin emas ini masih tersedia?",
      "time": "5m ago",
      "avatar": "assets/image/pp1.jpg",
    },
    {
      "name": "Raka",
      "message": "Kapan kalung saya dikirim?",
      "time": "10m ago",
      "avatar": "assets/image/pp2.jpg",
    },
    {
      "name": "Rangga",
      "message": "Apakah ada diskon untuk gelang perak?",
      "time": "1h ago",
      "avatar": "assets/image/pp3.jpg",
    },
    {
      "name": "Sasya",
      "message": "Saya ingin retur anting emas.",
      "time": "2h ago",
      "avatar": "assets/image/pp4.jpg",
    },
  ];

  void _updateQuery(String val) {
    setState(() {
      query = val;
    });
    // Scroll ke paling atas tiap kali query berubah
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter messages berdasarkan query
    List<Map<String, String>> filteredMessages = List.from(messages);
    // Jika query tidak kosong, urutkan agar yang mengandung query muncul di atas
    if (query.isNotEmpty) {
      filteredMessages.sort((a, b) {
        final aName = a["name"]!.toLowerCase();
        final bName = b["name"]!.toLowerCase();
        final q = query.toLowerCase();

        final aMatch = aName.contains(q);
        final bMatch = bName.contains(q);

        // Jika hanya satu yang cocok, dia di atas
        if (aMatch && !bMatch) return -1;
        if (!aMatch && bMatch) return 1;

        // Kalau dua-duanya cocok, urutkan berdasarkan posisi kecocokan (lebih awal = lebih atas)
        if (aMatch && bMatch) {
          return aName.indexOf(q).compareTo(bName.indexOf(q));
        }

        return 0;
      });
    }

    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        leading: GFIconButton(
          type: GFButtonType.transparent,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chat",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Cari nama atau pesan...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                _updateQuery(val);
              },
            ),
            const SizedBox(height: 20),

            // Active Now
            const Text(
              "Active Now",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: activeUsers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final user = activeUsers[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GFAvatar(
                        backgroundImage: AssetImage(user["avatar"]!),
                        shape: GFAvatarShape.circle,
                        size: GFSize.LARGE,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user["name"]!,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Messages
            const Text(
              "Messages",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: filteredMessages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final msg = filteredMessages[index];
                  return GFListTile(
                    avatar: GFAvatar(
                      backgroundImage: AssetImage(msg["avatar"]!),
                      shape: GFAvatarShape.circle,
                      size: GFSize.MEDIUM,
                    ),
                    titleText: msg["name"]!,
                    subTitleText: msg["message"]!,
                    icon: Text(
                      msg["time"]!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    color: Colors.white,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(8),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

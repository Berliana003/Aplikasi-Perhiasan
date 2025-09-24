import 'product.dart';

class Emas extends Product {
  Emas({
    required String id,
    required String name,
    required double diskon,
    required double price,
    required String image,
    required double rating,
    required int sold,
    required int stock,
    required int deliveryDays,
    String? description,
    List<String>? specs,
    Map<String, List<String>>? variations,
  }) : super(
         id: id,
         name: name,
         diskon: diskon,
         price: price,
         image: image,
         rating: rating,
         sold: sold,
         stock: stock,
         deliveryDays: deliveryDays,
         description: description,
         specs: specs,
         variations: variations,
       );

  // Override untuk memberi label khusus emas
  @override
  String toString() {
    return "💛 Emas: ${super.toString()}";
  }
}

// Contoh daftar produk emas
List<Emas> daftarEmas = [
  Emas(
    id: "E1",
    name: "✨ Kalung Emas Brilliant ✨",
    diskon: 5,
    price: 3900000,
    image: "assets/image/kalung_emas.jpg",
    rating: 4.7,
    sold: 150,
    stock: 20,
    deliveryDays: 3,

    description:
        "Kalung emas elegan dengan desain modern dan timeless, terbuat dari emas asli berkualitas tinggi. "
        "Kilau mewahnya tahan lama dan cocok digunakan untuk acara formal maupun sehari-hari. "
        "Dibuat dengan detail presisi dan finishing yang halus, kalung emas Brilliant memberikan sentuhan kemewahan pada setiap penampilan Anda.",

    specs: [
      "Material: Emas Asli (dengan sertifikat keaslian)",
      "Warna: Emas Kuning Berkilau",
      "Desain: Simple & Elegan",
      "Cocok untuk: Hadiah, koleksi pribadi, maupun investasi",
    ],

    variations: {
      "Panjang": ["40 cm", "45 cm", "50 cm"],
      "Berat": ["2 gram", "3 gram", "5 gram"],
      "Model": ["Rantai Polos", "Rantai Box", "Rantai Tali (Rope)"],
    },
  ),
  Emas(
    id: "E2",
    name: "💍 Cincin Emas Brilliant 💍",
    diskon: 0,
    price: 1600000,
    image: "assets/image/cincin_emas.jpg",
    rating: 4.5,
    sold: 98,
    stock: 35,
    deliveryDays: 3,

    description:
        "Cincin emas elegan dengan desain modern yang memancarkan kilau mewah. "
        "Dibuat dari emas asli berkualitas tinggi, cincin ini nyaman dipakai dan cocok untuk berbagai momen spesial, "
        "mulai dari pertunangan, pernikahan, hingga hadiah istimewa. Dengan detail presisi dan finishing halus, "
        "cincin emas Brilliant menjadi simbol keindahan, cinta, dan nilai investasi jangka panjang.",

    specs: [
      "Material: Emas Asli (dengan sertifikat keaslian)",
      "Warna: Emas Kuning Berkilau",
      "Desain: Minimalis & Elegan",
      "Cocok untuk: Pernikahan, pertunangan, hadiah, maupun koleksi pribadi",
    ],

    variations: {
      "Berat": ["2 gram", "3 gram", "5 gram"],
      "Ukuran": ["10", "12", "14", "16", "18"],
      "Model": ["Polos", "Bermotif", "Berhias Zircon/Permata"],
    },
  ),
  Emas(
    id: "E3",
    name: "✨ Gelang Emas Brilliant ✨",
    diskon: 3,
    price: 5000000,
    image: "assets/image/gelang_emas.jpg",
    rating: 4.6,
    sold: 87,
    stock: 15,
    deliveryDays: 3,

    description:
        "Tampilkan pesona yang anggun dengan Gelang Emas Brilliant. "
        "Dibuat dari emas asli berkualitas tinggi, gelang ini memiliki kilau alami yang mewah serta desain yang trendi. "
        "Ringan, nyaman, dan tahan lama, cocok dipakai sehari-hari maupun melengkapi gaya di acara spesial. "
        "Gelang Emas Brilliant tidak hanya mempercantik penampilan, tetapi juga menghadirkan kesan elegan yang bertahan sepanjang waktu.",

    specs: [
      "Material: Emas Asli (sertifikat keaslian disertakan)",
      "Warna: Emas Kuning Berkilau",
      "Finishing: Halus & Presisi",
      "Kategori: Fashion Jewelry sekaligus Investasi",
    ],

    variations: {
      "Panjang": ["16 cm", "18 cm", "20 cm"],
      "Berat": ["3 gr", "5 gr", "7 gr"],
      "Model": ["Rantai Klasik", "Box Chain", "Rope Chain", "Gelang Charm"],
    },
  ),
  Emas(
    id: "E4",
    name: "🌸 Anting Emas Brilliant 🌸",
    diskon: 0,
    price: 1200000,
    image: "assets/image/anting_emas.jpg",
    rating: 4.4,
    sold: 72,
    stock: 25,
    deliveryDays: 3,

    description:
        "Anting emas ini dirancang khusus untuk memberikan sentuhan manis sekaligus mewah pada penampilan Anda. "
        "Terbuat dari emas asli berkualitas tinggi, anting emas Brilliant menghadirkan kilau elegan yang tidak berlebihan, "
        "sehingga nyaman dipakai sehari-hari maupun pada acara spesial. "
        "Dengan desain menawan yang menyesuaikan gaya modern maupun klasik, "
        "Anting Emas Brilliant menjadi pilihan sempurna untuk melengkapi koleksi perhiasan Anda.",

    specs: [
      "Material: Emas Asli (dilengkapi sertifikat keaslian)",
      "Warna: Emas Kuning Mengkilap",
      "Desain: Ringan, Nyaman, & Stylish",
      "Kategori: Daily Wear & Special Occasion",
    ],

    variations: {
      "Bentuk": ["Stud", "Hoop", "Drop", "Twist"],
      "Berat": ["1 gr", "2 gr", "3 gr"],
      "Detail": ["Polos", "Bermotif", "Berhias Zircon/Permata"],
    },
  ),
];

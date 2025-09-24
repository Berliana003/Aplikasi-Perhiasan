import 'product.dart';

class Berlian extends Product {
  Berlian({
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

  /// Override method untuk menambahkan ikon khusus Berlian
  @override
  String toString() {
    return "💎 Berlian: ${super.toString()}";
  }
}

// Contoh daftar produk berlian
List<Berlian> daftarBerlian = [
  Berlian(
    id: "B1",
    name: "💎 Kalung Berlian Brilliant 💎",
    diskon: 10,
    price: 120000000,
    image: "assets/image/kalung_berlian.jpg",
    rating: 4.8,
    sold: 120,
    stock: 20,
    deliveryDays: 3,

    description:
        "Kalung berlian ini menghadirkan simbol keanggunan dan prestise, "
        "dirancang dengan detail sempurna menggunakan berlian asli pilihan serta material emas berkualitas. "
        "Setiap kilau berlian memberikan cahaya yang memikat, menjadikannya perhiasan istimewa untuk momen-momen berharga. "
        "Kalung Berlian Brilliant bukan hanya perhiasan, melainkan warisan kemewahan yang bernilai tinggi "
        "serta simbol cinta yang tak lekang oleh waktu.",

    specs: [
      "Material: Emas Asli + Berlian Murni (sertifikat keaslian disertakan)",
      "Warna: Emas Kuning / Emas Putih",
      "Finishing: Presisi & Premium",
      "Kategori: Fine Jewelry",
    ],

    variations: {
      "Karat Berlian": ["0.05 ct", "0.10 ct", "0.25 ct"],
      "Panjang Kalung": ["40 cm", "45 cm", "50 cm"],
      "Desain": [
        "Solitaire Diamond",
        "Halo Pendant",
        "Heart Shape",
        "Modern Classic",
      ],
    },
  ),
  Berlian(
    id: "B2",
    name: "💍 Cincin Berlian Brilliant 💍",
    diskon: 8,
    price: 9600000,
    image: "assets/image/cincin_berlian.jpg",
    rating: 4.6,
    sold: 95,
    stock: 10,
    deliveryDays: 3,

    description:
        "Didesain dengan keindahan yang tak lekang oleh waktu, cincin berlian Brilliant "
        "memadukan kemurnian berlian asli dengan material emas berkualitas tinggi. "
        "Setiap potongan berlian dipasang dengan detail presisi, menghasilkan kilau yang memikat hati. "
        "Sangat cocok untuk momen berharga seperti pertunangan, pernikahan, maupun hadiah istimewa. "
        "Cincin Berlian Brilliant bukan sekadar perhiasan, melainkan simbol cinta sejati "
        "yang akan selalu bersinar sepanjang masa.",

    specs: [
      "Material: Emas Asli + Berlian Murni (sertifikat keaslian disertakan)",
      "Warna: Emas Putih / Emas Kuning",
      "Potongan Berlian: Round Cut | Princess Cut | Oval | Cushion",
      "Kategori: Engagement Ring & Fine Jewelry",
    ],

    variations: {
      "Karat Berlian": ["0.10 ct", "0.25 ct", "0.50 ct"],
      "Berat Emas": ["2 gr", "3 gr", "5 gr"],
      "Model": ["Solitaire", "Three-Stone", "Halo", "Eternity"],
    },
  ),
  Berlian(
    id: "B3",
    name: "✨ Gelang Berlian Brilliant ✨",
    diskon: 9,
    price: 83600000,
    image: "assets/image/gelang_berlian.jpg",
    rating: 4.7,
    sold: 77,
    stock: 8,
    deliveryDays: 3,

    description:
        "Gelang berlian ini dirancang untuk menghadirkan kilau istimewa yang memancarkan "
        "pesona elegan. Terbuat dari emas berkualitas tinggi dengan taburan berlian asli pilihan, "
        "gelang ini tidak hanya memperindah penampilan, tetapi juga mencerminkan kemewahan yang berkelas. "
        "Gelang Berlian Brilliant adalah simbol keanggunan dan prestise, pilihan sempurna untuk hadiah berharga "
        "maupun koleksi pribadi yang bernilai tinggi.",

    specs: [
      "Material: Emas Asli + Berlian Murni (dilengkapi sertifikat keaslian)",
      "Warna: Emas Putih / Emas Kuning",
      "Finishing: Presisi, Nyaman Dipakai",
      "Kategori: Fine Jewelry & Luxury Collection",
    ],

    variations: {
      "Karat Berlian": ["0.05 ct", "0.10 ct", "0.25 ct"],
      "Panjang Gelang": ["16 cm", "18 cm", "20 cm"],
      "Model": ["Tennis Bracelet", "Charm Diamond", "Classic Chain"],
    },
  ),
  Berlian(
    id: "B4",
    name: "🌟 Anting Berlian Brilliant 🌟",
    diskon: 6,
    price: 7000000,
    image: "assets/image/anting_berlian.jpg",
    rating: 4.5,
    sold: 64,
    stock: 12,
    deliveryDays: 3,

    description:
        "Anting berlian Brilliant dirancang untuk menghadirkan pesona memikat yang "
        "menyempurnakan keanggunan wajah. Dengan taburan berlian asli berkualitas tinggi "
        "dan material emas premium, setiap detailnya memberikan kilau mewah yang elegan "
        "namun tetap nyaman dipakai sepanjang hari. Anting Berlian Brilliant adalah "
        "perhiasan istimewa yang memadukan kenyamanan dengan kemewahan, menjadikannya "
        "pilihan sempurna untuk hadiah berkelas maupun koleksi pribadi.",

    specs: [
      "Material: Emas Asli + Berlian Murni (sertifikat keaslian disertakan)",
      "Warna: Emas Putih / Emas Kuning",
      "Desain: Ringan, Elegan, & Modern",
      "Kategori: Luxury Daily Wear & Fine Jewelry",
    ],

    variations: {
      "Bentuk": ["Stud", "Hoop", "Drop", "Cluster"],
      "Karat Berlian": ["0.05 ct", "0.10 ct", "0.25 ct"],
      "Detail": ["Polos", "Solitaire", "Halo Design"],
    },
  ),
];

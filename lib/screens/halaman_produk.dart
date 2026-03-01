import 'package:flutter/material.dart';
import 'package:butik_stylish/utils/format_rupiah.dart';
import 'package:butik_stylish/screens/home_page.dart';

class HalamanProduk extends StatelessWidget {
  final HomePageState homeState;

  const HalamanProduk({super.key, required this.homeState});

  @override
  Widget build(BuildContext context) {
    return HalamanProdukWidget(homeState: homeState);
  }
}

class HalamanProdukWidget extends StatefulWidget {
  final HomePageState homeState;

  const HalamanProdukWidget({super.key, required this.homeState});

  @override
  State<HalamanProdukWidget> createState() => _HalamanProdukWidgetState();
}

class _HalamanProdukWidgetState extends State<HalamanProdukWidget> {
  final _formKeyTambah = GlobalKey<FormState>();
  final TextEditingController brandBaruController = TextEditingController();
  final TextEditingController namaBaruController = TextEditingController();
  final TextEditingController hargaBaruController = TextEditingController();
  final TextEditingController gambarBaruController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  void tampilFormTambahProduk() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKeyTambah,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "➕ Tambah Produk Baru",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: brandBaruController,
                  decoration: const InputDecoration(
                    labelText: "Nama Brand",
                    prefixIcon: Icon(Icons.store),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Brand wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: namaBaruController,
                  decoration: const InputDecoration(
                    labelText: "Nama Produk",
                    prefixIcon: Icon(Icons.checkroom),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Nama produk wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: hargaBaruController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Harga",
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return "Harga wajib diisi";
                    if (int.tryParse(value) == null)
                      return "Masukkan angka valid";
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: gambarBaruController,
                  decoration: const InputDecoration(
                    labelText: "Link Gambar (Opsional)",
                    prefixIcon: Icon(Icons.image),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKeyTambah.currentState!.validate()) {
                      widget.homeState.produkList.add({
                        "id": widget.homeState.produkList.length + 1,
                        "brand": brandBaruController.text,
                        "nama": namaBaruController.text,
                        "harga": int.parse(hargaBaruController.text),
                        "gambar": gambarBaruController.text.isEmpty
                            ? "https://via.placeholder.com/400"
                            : gambarBaruController.text,
                        "stok": 100,
                      });
                      brandBaruController.clear();
                      namaBaruController.clear();
                      hargaBaruController.clear();
                      gambarBaruController.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Produk berhasil ditambahkan!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Produk"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void tampilDialogCheckout(Map<String, dynamic> produk) {
    jumlahController.text = "1";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("🛒 ${produk['nama']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Brand: ${produk['brand']}"),
            Text("Harga: ${FormatRupiah.toRupiah(produk['harga'])}"),
            const SizedBox(height: 15),
            TextFormField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jumlah",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              int jumlah = int.parse(jumlahController.text);
              if (jumlah > 0) {
                int total = produk['harga'] * jumlah;
                widget.homeState.dataPenjualan.insert(0, {
                  "brand": produk['brand'],
                  "produk": produk['nama'],
                  "harga": produk['harga'],
                  "jumlah": jumlah,
                  "total": total,
                  "tanggal": DateTime.now().toString().split(' ')[0],
                  "jam":
                      DateTime.now().toString().split(' ')[1].substring(0, 5),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text("✅ Penjualan ${produk['nama']} x$jumlah dicatat!"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text("💰 Checkout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🛍️ Kasir - Butik Stylish"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            tooltip: "Tambah Produk Baru",
            onPressed: tampilFormTambahProduk,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.purple],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🔥 Sale Up to 50%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Pilih produk dan checkout",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: widget.homeState.produkList.length,
              itemBuilder: (context, index) {
                final produk = widget.homeState.produkList[index];
                return _buildKartuProduk(produk);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKartuProduk(Map<String, dynamic> produk) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                produk['gambar'],
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk['brand'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    produk['nama'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        FormatRupiah.toRupiah(produk['harga']),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      InkWell(
                        onTap: () => tampilDialogCheckout(produk),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:butik_stylish/utils/format_rupiah.dart';
import 'package:butik_stylish/screens/home_page.dart';

class HalamanPenjualan extends StatefulWidget {
  const HalamanPenjualan({super.key});

  @override
  State<HalamanPenjualan> createState() => _HalamanPenjualanState();
}

class _HalamanPenjualanState extends State<HalamanPenjualan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController produkController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  bool isEditing = false;
  int? editIndex;

  HomePageState get homeState =>
      context.findAncestorStateOfType<HomePageState>()!;

  void submitData() {
    if (_formKey.currentState!.validate()) {
      int harga = int.parse(hargaController.text);
      int jumlah = int.parse(jumlahController.text);
      int total = harga * jumlah;

      setState(() {
        if (isEditing) {
          homeState.dataPenjualan[editIndex!] = {
            "brand": brandController.text,
            "produk": produkController.text,
            "harga": harga,
            "jumlah": jumlah,
            "total": total,
            "tanggal": DateTime.now().toString().split(' ')[0],
            "jam": DateTime.now().toString().split(' ')[1].substring(0, 5),
          };
          isEditing = false;
          editIndex = null;
        } else {
          homeState.dataPenjualan.insert(0, {
            "brand": brandController.text,
            "produk": produkController.text,
            "harga": harga,
            "jumlah": jumlah,
            "total": total,
            "tanggal": DateTime.now().toString().split(' ')[0],
            "jam": DateTime.now().toString().split(' ')[1].substring(0, 5),
          });
        }
      });

      _clearControllers();
      Navigator.pop(context);
    }
  }

  void hapusData(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🗑️ Konfirmasi Hapus"),
        content: const Text("Yakin hapus data penjualan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() => homeState.dataPenjualan.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Data berhasil dihapus!"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void prepareEdit(int index) {
    final item = homeState.dataPenjualan[index];
    setState(() {
      isEditing = true;
      editIndex = index;
      brandController.text = item["brand"];
      produkController.text = item["produk"];
      hargaController.text = item["harga"].toString();
      jumlahController.text = item["jumlah"].toString();
    });
    tampilForm();
  }

  void _clearControllers() {
    brandController.clear();
    produkController.clear();
    hargaController.clear();
    jumlahController.clear();
  }

  void tampilForm() {
    if (!isEditing) _clearControllers();
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
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing
                      ? "✏️ Edit Data Penjualan"
                      : "➕ Tambah Data Penjualan",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: brandController,
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
                  controller: produkController,
                  decoration: const InputDecoration(
                    labelText: "Nama Produk",
                    prefixIcon: Icon(Icons.checkroom),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Produk wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: hargaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Harga",
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty || int.tryParse(value) == null
                          ? "Harga wajib diisi"
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Jumlah Terjual",
                    prefixIcon: Icon(Icons.numbers),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty || int.tryParse(value) == null
                          ? "Jumlah wajib diisi"
                          : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: submitData,
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                  label: Text(isEditing ? "💾 Simpan" : "➕ Tambah Data"),
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

  int totalKeseluruhan() {
    int total = 0;
    for (var item in homeState.dataPenjualan) {
      total += item["total"] as int;
    }
    return total;
  }

  int totalItems() {
    int total = 0;
    for (var item in homeState.dataPenjualan) {
      total += item["jumlah"] as int;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Data Penjualan"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  "Transaksi",
                  "${homeState.dataPenjualan.length}",
                  Icons.receipt,
                ),
                _buildStatCard("Items", "${totalItems()}", Icons.inventory),
                _buildStatCard(
                  "Pendapatan",
                  FormatRupiah.toRupiah(totalKeseluruhan()),
                  Icons.money,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.deepPurple[100],
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Produk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Harga",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Jml",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: homeState.dataPenjualan.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Belum ada data penjualan",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: homeState.dataPenjualan.length,
                    itemBuilder: (context, index) {
                      final item = homeState.dataPenjualan[index];
                      return Dismissible(
                        key: Key(index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async => await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Hapus"),
                            content: const Text("Yakin?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Hapus",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) => setState(
                          () => homeState.dataPenjualan.removeAt(index),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: InkWell(
                            onTap: () => prepareEdit(index),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["brand"],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item["produk"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${item['tanggal']} ${item['jam']}",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      FormatRupiah.toRupiah(item["harga"]),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${item["jumlah"]}",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      FormatRupiah.toRupiah(item["total"]),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              border: Border(
                top: BorderSide(color: Colors.deepPurple[300]!, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TOTAL:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  FormatRupiah.toRupiah(totalKeseluruhan()),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isEditing = false;
          tampilForm();
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 28),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}

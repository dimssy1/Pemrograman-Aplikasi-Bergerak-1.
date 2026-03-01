import 'package:flutter/material.dart';
import 'package:butik_stylish/screens/halaman_produk.dart';
import 'package:butik_stylish/screens/halaman_penjualan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Data produk
  final List<Map<String, dynamic>> produkList = [
    {
      "id": 1,
      "brand": "Zara",
      "nama": "Kaos Polos Hitam",
      "harga": 299000,
      "gambar":
          "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400",
      "stok": 50,
    },
    {
      "id": 2,
      "brand": "H&M",
      "nama": "Hoodie Abu Abu",
      "harga": 599000,
      "gambar":
          "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400",
      "stok": 30,
    },
    {
      "id": 3,
      "brand": "Uniqlo",
      "nama": "Kemeja Putih",
      "harga": 399000,
      "gambar":
          "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400",
      "stok": 25,
    },
    {
      "id": 4,
      "brand": "Nike",
      "nama": "Jaket Varsity",
      "harga": 899000,
      "gambar":
          "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400",
      "stok": 15,
    },
    {
      "id": 5,
      "brand": "Adidas",
      "nama": "Celana Jogger",
      "harga": 449000,
      "gambar":
          "https://images.unsplash.com/photo-1483721310020-03333e577078?w=400",
      "stok": 40,
    },
    {
      "id": 6,
      "brand": "GU",
      "nama": "Dress Floral",
      "harga": 549000,
      "gambar":
          "https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400",
      "stok": 20,
    },
  ];

  // Data penjualan
  final List<Map<String, dynamic>> dataPenjualan = [];

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([HalamanProduk(homeState: this), const HalamanPenjualan()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Kasir"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Penjualan",
          ),
        ],
      ),
    );
  }
}

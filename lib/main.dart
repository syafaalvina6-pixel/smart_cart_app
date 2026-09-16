import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Entry point aplikasi: Mendaftarkan CartProvider ke root widget menggunakan ChangeNotifierProvider
void main() => runApp(ChangeNotifierProvider(create: (_) => CartProvider(), child: const MyApp()));

// Helper Function: Mengubah angka integer menjadi format mata uang Rupiah (contoh: 120000 -> Rp 120.000)
String formatRupiah(int p) => 'Rp ${p.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

// Custom Widget Helper: Menampilkan gambar produk (dari asset lokal atau URL internet)
// Jika gambar gagal dimuat, akan menampilkan fallbackIcon bawaan model Product
Widget buildProductImage(Product p, double size) => Image(
      image: (p.isAsset ? Image.asset(p.imageUrl) : Image.network(p.imageUrl)).image,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(p.fallbackIcon, size: size, color: const Color(0xFF8B63DA)),
    );

// ==========================================
// KELAS MODEL DATA (DATA MODEL)
// ==========================================

// Model untuk menyimpan informasi detail produk katalog
class Product {
  final String id, name, imageUrl;
  final int price;
  final IconData fallbackIcon;
  final bool isAsset;
  Product({required this.id, required this.name, required this.price, required this.fallbackIcon, required this.imageUrl, this.isAsset = false});
}

// Model untuk menyimpan data produk yang ada di dalam keranjang belanja beserta kuantitasnya
class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

// ==========================================
// STATE MANAGEMENT (PROVIDER)
// ==========================================

// Pengelola State Keranjang Belanja yang mewarisi ChangeNotifier
class CartProvider with ChangeNotifier {
  final List<CartItem> items = [];

  // Getter: Menghitung total seluruh unit barang yang ada di keranjang untuk badge ikon keranjang
  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  // Getter: Menghitung akumulasi total harga belanjaan (harga x kuantitas)
  int get totalPrice => items.fold(0, (s, i) => s + (i.product.price * i.quantity));

  // Fungsi: Menambahkan produk ke keranjang (jika barang sudah ada, kuantitas ditambah 1)
  void addToCart(Product p) {
    final idx = items.indexWhere((i) => i.product.id == p.id);
    idx >= 0 ? items[idx].quantity++ : items.add(CartItem(product: p));
    notifyListeners(); // Memberitahu UI untuk memperbarui tampilan secara reaktif
  }

  // Fungsi: Menambah jumlah (+1) item tertentu berdasarkan ID produk
  void incrementItem(String id) {
    final idx = items.indexWhere((i) => i.product.id == id);
    if (idx >= 0) { items[idx].quantity++; notifyListeners(); }
  }

  // Fungsi: Mengurangi jumlah (-1) item. Jika kuantitas tinggal 1, item akan dihapus dari keranjang
  void decrementItem(String id) {
    final idx = items.indexWhere((i) => i.product.id == id);
    if (idx >= 0) { items[idx].quantity > 1 ? items[idx].quantity-- : items.removeAt(idx); notifyListeners(); }
  }
}

// ==========================================
// WIDGET UTAMA APLIKASI
// ==========================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Catalog Fashion Store',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF9F8FE),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B63DA), primary: const Color(0xFF8B63DA)),
          fontFamily: 'Roboto',
        ),
        home: const CatalogPage(),
      );
}

// ==========================================
// HALAMAN KATALOG PRODUK
// ==========================================

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  // Data tiruan (dummy data) berisi daftar produk katalog
  static final List<Product> products = [
    Product(id: 'p1', name: 'Hoodie Oversize', price: 120000, fallbackIcon: Icons.dry_cleaning_rounded, imageUrl: 'assets/hoodie_23.jpg', isAsset: true),
    Product(id: 'p2', name: 'Sneakers Unisex', price: 250000, fallbackIcon: Icons.roller_skating_rounded, imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&q=80'),
    Product(id: 'p3', name: 'Backpack Simple', price: 180000, fallbackIcon: Icons.backpack_rounded, imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&q=80'),
    Product(id: 'p4', name: 'Topi Baseball', price: 75000, fallbackIcon: Icons.sports_baseball_rounded, imageUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=500&q=80'),
    Product(id: 'p5', name: 'Jam Tangan', price: 150000, fallbackIcon: Icons.watch_rounded, imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80'),
    Product(id: 'p6', name: 'Kacamata Hitam', price: 100000, fallbackIcon: Icons.visibility_rounded, imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&q=80'),
  ];

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF8B63DA);
    
    // Mendengarkan perubahan itemCount dari CartProvider secara reaktif
    final count = context.watch<CartProvider>().itemCount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('E-Catalog Fashion Store', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Tombol menuju ke Halaman Keranjang Belanja
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: primary, size: 28),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
                ),
                // Badge indikator jumlah total item di keranjang (hanya muncul jika kuantitas > 0)
                if (count > 0)
                  Positioned(
                    right: 4, top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: primary, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.70, crossAxisSpacing: 16, mainAxisSpacing: 16),
          itemBuilder: (_, i) {
            final p = products[i];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE8DEF8))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widget Responsif: Expanded mencegah overflow vertikal pada area gambar produk
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: const Color(0xFFF2ECFB), borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: buildProductImage(p, 48)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF5A4B75)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(formatRupiah(p.price), style: const TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  // Tombol untuk menambah item ke dalam state CartProvider
                  SizedBox(
                    width: double.infinity, height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        // Memanggil fungsi penambahan produk di State Manager
                        context.read<CartProvider>().addToCart(p);
                        // Menampilkan umpan balik pesan SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} berhasil ditambahkan!'), duration: const Duration(milliseconds: 800)));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: primary, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN KERANJANG BELANJA
// ==========================================

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF8B63DA);
    
    // Mendengarkan perubahan data keranjang belanja secara reaktif dari CartProvider
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: primary), onPressed: () => Navigator.pop(context)),
        title: const Text('Keranjang Belanja', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      // Kondisi Rendering: Jika keranjang kosong, tampilkan pesan status kosong
      body: cart.items.isEmpty
          ? const Center(child: Text('Keranjang belanja masih kosong', style: TextStyle(color: Colors.grey)))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header Card: Menampilkan total kalkulasi pembayaran secara otomatis
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE8DEF8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(color: Color(0xFF5A4B75), fontWeight: FontWeight.bold, fontSize: 13)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)),
                          child: Text(formatRupiah(cart.totalPrice), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Widget Responsif: Expanded agar ListView menempati sisa ruang layar tanpa overflow ke bawah
                  Expanded(
                    child: ListView.separated(
                      itemCount: cart.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final item = cart.items[i];
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE8DEF8))),
                          child: Row(
                            children: [
                              // Gambar miniatur produk di keranjang
                              Container(
                                width: 60, height: 60,
                                decoration: BoxDecoration(color: const Color(0xFFF2ECFB), borderRadius: BorderRadius.circular(8)),
                                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: buildProductImage(item.product, 32)),
                              ),
                              const SizedBox(width: 12),
                              
                              // Widget Responsif: Expanded agar teks informasi produk fleksibel mengisi ruang tengah
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name, style: const TextStyle(color: Color(0xFF5A4B75), fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text('Total: ${formatRupiah(item.product.price * item.quantity)}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  ],
                                ),
                              ),
                              
                              // Kontrol Pengubah Kuantitas (- / +)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE8DEF8)), borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    // Tombol Kurangi Kuantitas / Hapus Item
                                    InkWell(onTap: () => cart.decrementItem(item.product.id), child: const Text(' – ', style: TextStyle(color: primary, fontWeight: FontWeight.bold))),
                                    const SizedBox(width: 6),
                                    Text('${item.quantity} x', style: const TextStyle(fontSize: 11, color: Color(0xFF5A4B75))),
                                    const SizedBox(width: 6),
                                    // Tombol Tambah Kuantitas
                                    InkWell(onTap: () => cart.incrementItem(item.product.id), child: const Text(' + ', style: TextStyle(color: primary, fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
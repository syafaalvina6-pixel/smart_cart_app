import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'product_list_screen.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF8B63DA);
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: primary), onPressed: () => Navigator.pop(context)),
        title: const Text('Keranjang Belanja', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Keranjang belanja masih kosong', style: TextStyle(color: Colors.grey)))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                              Container(
                                width: 60, height: 60,
                                decoration: BoxDecoration(color: const Color(0xFFF2ECFB), borderRadius: BorderRadius.circular(8)),
                                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: buildProductImage(item.product, 32)),
                              ),
                              const SizedBox(width: 12),
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE8DEF8)), borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    InkWell(onTap: () => cart.decrementItem(item.product.id), child: const Text(' – ', style: TextStyle(color: primary, fontWeight: FontWeight.bold))),
                                    const SizedBox(width: 6),
                                    Text('${item.quantity} x', style: const TextStyle(fontSize: 11, color: Color(0xFF5A4B75))),
                                    const SizedBox(width: 6),
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
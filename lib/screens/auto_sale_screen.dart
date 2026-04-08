import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/catalogue.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';


class AutoSaleData {
  static List<Map<String, dynamic>> getPermanentSaleItems() {
    List<Map<String, dynamic>> saleItems = [];

    for (final cat in Catalogue.categories) {
      for (final sub in cat.subCategories) {
        if (sub.products.isNotEmpty) {
          final p = sub.products.last;
          saleItems.add({
            'product': p,
            'salePrice': p.price * 0.85,
          });
        }
      }
    }
    return saleItems;
  }
}


class AutoSaleScreen extends StatelessWidget {
  const AutoSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saleItems = AutoSaleData.getPermanentSaleItems();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context, 'Private Archives'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(
              'CURATED PIECES AT EXCLUSIVE ARCHIVE PRICING',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
                childAspectRatio: 0.58,
              ),
              itemCount: saleItems.length,
              itemBuilder: (context, index) {
                final item = saleItems[index];
                return _buildArchiveCard(context, item['product'], item['salePrice']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchiveCard(BuildContext context, Product product, double salePrice) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
                product: product,
              salePrice: salePrice,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F8F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.image_outlined, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                // Luxury Discount Tag
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.black,
                    child: const Text(
                      'ARCHIVE',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w400, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '£${salePrice.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Text(
                product.formattedPrice,
                style: TextStyle(fontSize: 11, color: Colors.grey[400], decoration: TextDecoration.lineThrough),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget _buildHeader(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
      onPressed: () => Navigator.pop(context),
    ),
    centerTitle: true,
    title: Text(
      title,
      style: GoogleFonts.josefinSans(fontSize: 22, fontWeight: FontWeight.w300, letterSpacing: 2, color: Colors.black),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 22),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
        ),
      ),
    ],
  );
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import '../data/catalogue.dart';

class NewArrivalsScreen extends StatelessWidget {
  const NewArrivalsScreen({super.key});

  List<Product> _getNewArrivals() {
    List<Product> items = [];
    for (final cat in Catalogue.categories) {
      for (final sub in cat.subCategories) {
        if (sub.products.isNotEmpty) {
          items.add(sub.products.first);
        }
      }
    }
    return items.take(8).toList();
  }

  @override
  Widget build(BuildContext context) {

    final newArrivals = _getNewArrivals();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context, 'New Arrivals'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'DISCOVER THE LATEST CREATIONS',
              style: GoogleFonts.josefinSans(
                fontSize: 12,
                letterSpacing: 4,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
                childAspectRatio: 0.58,
              ),
              itemCount: newArrivals.length,
              itemBuilder: (context, index) {
                return _buildProductCard(context, newArrivals[index]);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }


  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F8F6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox.expand(
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, progress) => progress == null
                            ? child
                            : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black12,
                            strokeWidth: 2,
                          ),
                        ),
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_outlined, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'CARTIER',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            product.name,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          Text(
            product.formattedPrice,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
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
      onPressed: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.pop(context);
      },
    ),
    centerTitle: true,
    title: Text(
      title,
      style: GoogleFonts.josefinSans(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        letterSpacing: 3,
        color: Colors.black,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 22),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
      ),
    ],
  );
}
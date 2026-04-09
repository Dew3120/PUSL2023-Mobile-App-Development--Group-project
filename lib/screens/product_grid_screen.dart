import 'package:flutter/material.dart';
import '../data/catalogue.dart';
import 'product_detail_screen.dart';

class ProductGridScreen extends StatelessWidget {
  final SubCategory subCategory;
  final String categoryName;

  const ProductGridScreen({
    super.key,
    required this.subCategory,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        cacheExtent: 1500,
        slivers: [
          //  Hero app bar (big image + sub name overlaid bottom-left) 
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => Navigator.pop(context),
              color: Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero image - local asset if available, else fallback
                  if (subCategory.imageAsset != null)
                    Image.asset(
                      subCategory.imageAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFF0EDEA)),
                    )
                  else
                    Image.network(
                      subCategory.products.first.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) => progress == null
                          ? child
                          : Container(color: const Color(0xFFF0EDEA)),
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFF0EDEA)),
                    ),
                  // Dark gradient for legibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.20),
                          Colors.black.withOpacity(0.65),
                        ],
                      ),
                    ),
                  ),
                  // Title block - bottom-left
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subCategory.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 3.5,
                            fontFamily: 'Basis',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //  Description 
          if (subCategory.description.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Text(
                  subCategory.description,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    height: 1.8,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),

          //  Pieces count 
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: Row(
                children: [
                  Container(width: 22, height: 0.8, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    '${subCategory.itemCount} PIECES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.5,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Divider(height: 1, color: Color(0xFFE0E0E0)),
            ),
          ),

          //  Grid 
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 20,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final product = subCategory.products[i];
                  return _ProductCard(
                    product: product,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    ),
                  );
                },
                childCount: subCategory.products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: SizedBox.expand(
                    child: product.isAsset
                        ? Image.asset(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFF4F1EE),
                              child: const Center(
                                child: Icon(Icons.image_outlined,
                                    color: Color(0xFFCBC2B8), size: 32),
                              ),
                            ),
                          )
                        : Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (ctx, child, progress) =>
                                progress == null
                                    ? child
                                    : Container(color: const Color(0xFFF4F1EE)),
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFF4F1EE),
                              child: const Center(
                                child: Icon(Icons.image_outlined,
                                    color: Color(0xFFCBC2B8), size: 32),
                              ),
                            ),
                          ),
                  ),
                ),
                // Wishlist icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_outline,
                        size: 16, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Name
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Price
          Text(
            product.formattedPrice,
            style: TextStyle(
              fontSize: 13,
              fontWeight: product.requestPrice
                  ? FontWeight.w400
                  : FontWeight.w500,
              fontStyle: product.requestPrice
                  ? FontStyle.italic
                  : FontStyle.normal,
              letterSpacing: 0.5,
              color: product.requestPrice ? Colors.grey[700] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

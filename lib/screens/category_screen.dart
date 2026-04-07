import 'package:flutter/material.dart';
import '../data/catalogue.dart';
import 'product_grid_screen.dart';

class CategoryScreen extends StatelessWidget {
  final MainCategory category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Hero app bar ───────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => Navigator.pop(context),
              color: Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    category.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, progress) =>
                        progress == null ? child : Container(color: const Color(0xFFF0EDEA)),
                    errorBuilder: (ctx, _, __) =>
                        Container(color: const Color(0xFFF0EDEA)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 24,
                    right: 20,
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 4,
                        fontFamily: 'Basis',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Description ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                category.description,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  height: 1.8,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Divider(height: 1, color: Color(0xFFE0E0E0)),
            ),
          ),

          // ── Subcategory list ───────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final sub = category.subCategories[i];
                final isLast = i == category.subCategories.length - 1;
                return _SubCategoryTile(
                  sub: sub,
                  isLast: isLast,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductGridScreen(
                        subCategory: sub,
                        categoryName: category.name,
                      ),
                    ),
                  ),
                );
              },
              childCount: category.subCategories.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _SubCategoryTile extends StatelessWidget {
  final SubCategory sub;
  final bool isLast;
  final VoidCallback onTap;

  const _SubCategoryTile({
    required this.sub,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.network(
                      sub.products.first.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFF0EDEA)),
                      loadingBuilder: (ctx, child, progress) =>
                          progress == null ? child : Container(color: const Color(0xFFF0EDEA)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sub.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${sub.itemCount} pieces',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Color(0xFF999999)),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Color(0xFFF0F0F0)),
          ),
      ],
    );
  }
}

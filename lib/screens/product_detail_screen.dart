import 'package:flutter/material.dart';
import '../data/catalogue.dart';
import 'payment_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _wishlisted = false;
  String? _selectedSize;
  bool _expandedDescription = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final gallery = p.gallery;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          cacheExtent: 1500,
          slivers: [
            //  Top bar 
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 18, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _wishlisted ? Icons.favorite : Icons.favorite_outline,
                        size: 22,
                        color: _wishlisted
                            ? const Color(0xFFD50032)
                            : Colors.black,
                      ),
                      onPressed: () =>
                          setState(() => _wishlisted = !_wishlisted),
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined,
                          size: 22, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            //  2x2 image gallery grid 
            SliverToBoxAdapter(
              child: _GalleryGrid(images: gallery, isAsset: p.isAsset),
            ),

            //  Name + price block 
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.collection.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Short story
                    _ExpandableText(
                      text: p.description,
                      expanded: _expandedDescription,
                      onToggle: () => setState(
                          () => _expandedDescription = !_expandedDescription),
                    ),

                    const SizedBox(height: 24),

                    // Full product description
                    if (p.fullDescription.isNotEmpty) ...[
                      const Text(
                        'PRODUCT DESCRIPTION',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        p.fullDescription,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          height: 1.85,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Shipping / returns badges
                    const _ServiceBadge(
                      title: 'Cartier',
                      subtitle: 'Complimentary shipping',
                    ),
                    const SizedBox(height: 8),
                    const _ServiceBadge(
                      title: 'Cartier',
                      subtitle: 'Complimentary returns and exchanges',
                    ),

                    const SizedBox(height: 28),

                    // Find your size
                    if (p.sizes.isNotEmpty) ...[
                      const Text(
                        'FIND YOUR SIZE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SizeDropdown(
                        sizes: p.sizes,
                        selected: _selectedSize,
                        onSelected: (s) =>
                            setState(() => _selectedSize = s),
                      ),
                      const SizedBox(height: 22),
                    ],

                    // Price
                    Text(
                      p.formattedPrice,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: p.requestPrice
                            ? FontWeight.w400
                            : FontWeight.w500,
                        fontStyle: p.requestPrice
                            ? FontStyle.italic
                            : FontStyle.normal,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (!p.requestPrice) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Price includes applicable taxes',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],

                    const SizedBox(height: 26),

                    //  CTA buttons 
                    if (!p.requestPrice) ...[
                      _RedButton(
                        label: 'BUY NOW',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(product: p),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _BlackButton(
                        label: 'ADD TO BAG',
                        onPressed: () => _showAddedToBag(context, p),
                      ),
                    ] else
                      _BlackButton(
                        label: 'REQUEST PRICE',
                        onPressed: () => _showBoutiqueDialog(context, p),
                      ),

                    const SizedBox(height: 12),

                    // Add to wish list
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton.icon(
                        onPressed: () =>
                            setState(() => _wishlisted = !_wishlisted),
                        icon: Icon(
                          _wishlisted
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          size: 18,
                          color: _wishlisted
                              ? const Color(0xFFD50032)
                              : Colors.black,
                        ),
                        label: Text(
                          _wishlisted ? 'SAVED TO WISH LIST' : 'ADD TO WISH LIST',
                          style: TextStyle(
                            color: _wishlisted
                                ? const Color(0xFFD50032)
                                : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 18),

                    //  Service icon list 
                    _ServiceTile(
                      icon: Icons.phone_outlined,
                      label: 'ORDER BY PHONE 1-800-227-8437',
                      onTap: () {},
                    ),
                    _ServiceTile(
                      icon: Icons.storefront_outlined,
                      label: 'FIND IN BOUTIQUE',
                      onTap: () => _showBoutiqueDialog(context, p),
                    ),
                    _ServiceTile(
                      icon: Icons.headset_mic_outlined,
                      label: 'CONTACT AN AMBASSADOR',
                      onTap: () => _showBoutiqueDialog(context, p),
                    ),
                    _ServiceTile(
                      icon: Icons.book_outlined,
                      label: 'BOOK AN APPOINTMENT',
                      onTap: () => _showBoutiqueDialog(context, p),
                    ),

                    // Share + Ref
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.share_outlined,
                              size: 18, color: Colors.black87),
                          const SizedBox(width: 16),
                          const Text(
                            'SHARE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Container(
                              width: 1, height: 16, color: const Color(0xFFDDDDDD)),
                          const SizedBox(width: 18),
                          if (p.ref != null)
                            Text(
                              'Ref. ${p.ref}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddedToBag(BuildContext context, Product p) {
    if (p.sizes.isNotEmpty && _selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.name} added to bag'),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// 
// 2x2 image gallery grid
// 

class _GalleryGrid extends StatelessWidget {
  final List<String> images;
  final bool isAsset;
  const _GalleryGrid({required this.images, required this.isAsset});

  @override
  Widget build(BuildContext context) {
    // Show up to 4 in a 2x2 grid; if fewer, fill remaining with placeholder.
    final imgs = List<String>.from(images);
    while (imgs.length < 4) {
      imgs.add('');
    }
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: imgs.take(4).map((url) => _GalleryCell(
            url: url,
            isAsset: isAsset,
          )).toList(),
    );
  }
}

class _GalleryCell extends StatelessWidget {
  final String url;
  final bool isAsset;
  const _GalleryCell({required this.url, required this.isAsset});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: const Color(0xFFF4F1EE),
        child: url.isEmpty
            ? const _ImagePlaceholder()
            : (isAsset
                ? Image.asset(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                  )
                : Image.network(
                    url,
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, progress) => progress == null
                        ? child
                        : Container(color: const Color(0xFFF4F1EE)),
                    errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                  )),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_outlined, color: Color(0xFFCBC2B8), size: 28),
    );
  }
}

// 
// Expandable description ("Read More / Read Less")
// 

class _ExpandableText extends StatelessWidget {
  final String text;
  final bool expanded;
  final VoidCallback onToggle;
  const _ExpandableText({
    required this.text,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: expanded ? null : 3,
          overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            height: 1.85,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onToggle,
          child: Text(
            expanded ? 'Read Less' : 'Read More',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

// 
// Size dropdown
// 

class _SizeDropdown extends StatelessWidget {
  final List<String> sizes;
  final String? selected;
  final ValueChanged<String> onSelected;
  const _SizeDropdown({
    required this.sizes,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCCCCCC), width: 0.8),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: selected,
            isExpanded: true,
            hint: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Select Size',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87),
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: Colors.black54, size: 22),
            items: sizes
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) onSelected(v);
            },
          ),
        ),
      ),
    );
  }
}

// 
// Buttons
// 

class _RedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _RedButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD50032),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.5,
          ),
        ),
      ),
    );
  }
}

class _BlackButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _BlackButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.5,
          ),
        ),
      ),
    );
  }
}

// 
// Service tile (icon + caption row)
// 

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 
// Service badge (Cartier shipping/returns)
// 

class _ServiceBadge extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ServiceBadge({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.local_shipping_outlined,
            size: 16, color: Colors.black54),
        const SizedBox(width: 10),
        Text(
          '$title - ',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        Expanded(
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}

// 
// Boutique bottom sheet (kept for FIND IN BOUTIQUE / CONTACT AMBASSADOR taps)
// 

void _showBoutiqueDialog(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'CONTACT A BOUTIQUE',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Our client advisors are available to assist you with '
            '"${product.name}".',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              height: 1.6,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 22),
          _boutiqueTile(
            icon: Icons.phone_outlined,
            title: 'Call us',
            subtitle: '+1 800 CARTIER (227 8437)',
            hint: 'Mon - Sat · 9am - 9pm EST',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _boutiqueTile(
            icon: Icons.mail_outline,
            title: 'Email',
            subtitle: 'clientrelations@cartier.com',
            hint: 'Replies within 24 hours',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _boutiqueTile(
            icon: Icons.event_outlined,
            title: 'Book an appointment',
            subtitle: 'Schedule a private viewing',
            hint: 'At your nearest boutique',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _boutiqueTile(
            icon: Icons.location_on_outlined,
            title: 'Nearest boutique',
            subtitle: '653 Fifth Avenue, New York',
            hint: '0.8 mi away · Open now',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: const Text(
                'CLOSE',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _boutiqueTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required String hint,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Icon(icon, size: 16, color: Colors.black87),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hint,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFFAAAAAA),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios,
            size: 12, color: Color(0xFFBBBBBB)),
      ],
    ),
  );
}

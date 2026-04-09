import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../data/catalogue.dart';
import 'coming_soon_screen.dart';
import 'product_grid_screen.dart';

// Subcategory IDs that are fully implemented for the demo.
// Everything else routes to a "Coming Soon" page.
const Set<String> _liveSubCategoryIds = {'hj_panther'};

class CategoryScreen extends StatefulWidget {
  final MainCategory category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  VideoPlayerController? _heroVideo;
  MainCategory get category => widget.category;

  bool get _useVideoHero =>
      category.name.toUpperCase() == 'HIGH JEWELLERY';

  @override
  void initState() {
    super.initState();
    if (_useVideoHero) {
      _heroVideo = VideoPlayerController.asset(
        'assets/videos/home_hj_v1.mp4',
      )..initialize().then((_) {
          if (!mounted) return;
          _heroVideo!
            ..setLooping(true)
            ..setVolume(0)
            ..play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _heroVideo?.dispose();
    super.dispose();
  }

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
          //  Hero app bar 
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
                  if (_useVideoHero &&
                      _heroVideo != null &&
                      _heroVideo!.value.isInitialized)
                    FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: _heroVideo!.value.size.width,
                        height: _heroVideo!.value.size.height,
                        child: VideoPlayer(_heroVideo!),
                      ),
                    )
                  else
                    Image.network(
                      category.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) =>
                          progress == null
                              ? child
                              : Container(color: const Color(0xFFF0EDEA)),
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

          //  Description 
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

          //  Subcategory list 
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final sub = category.subCategories[i];
                final isLast = i == category.subCategories.length - 1;
                final isLive = _liveSubCategoryIds.contains(sub.id);
                return _SubCategoryTile(
                  sub: sub,
                  isLast: isLast,
                  comingSoon: !isLive,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => isLive
                          ? ProductGridScreen(
                              subCategory: sub,
                              categoryName: category.name,
                            )
                          : ComingSoonScreen(title: sub.name),
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
  final bool comingSoon;
  final VoidCallback onTap;

  const _SubCategoryTile({
    required this.sub,
    required this.isLast,
    required this.onTap,
    this.comingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail (local asset if provided, else fallback to product image)
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: SizedBox(
                    width: 92,
                    height: 92,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        sub.imageAsset != null
                            ? Image.asset(
                                sub.imageAsset!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFFF0EDEA),
                                  child: const Center(
                                    child: Icon(Icons.image_outlined,
                                        size: 22, color: Color(0xFFCBC2B8)),
                                  ),
                                ),
                              )
                            : Image.network(
                                sub.products.first.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    color: const Color(0xFFF0EDEA)),
                                loadingBuilder: (ctx, child, progress) =>
                                    progress == null
                                        ? child
                                        : Container(
                                            color: const Color(0xFFF0EDEA)),
                              ),
                        // Coming-soon subs: keep the image untouched (no badge),
                        // the tap handler still routes them to ComingSoonScreen.
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sub.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      if (sub.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          sub.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w300,
                            height: 1.55,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '${sub.itemCount} pieces',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.5,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4, left: 6),
                  child: Icon(Icons.arrow_forward_ios,
                      size: 13, color: Color(0xFF999999)),
                ),
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

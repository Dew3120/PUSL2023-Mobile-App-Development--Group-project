import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../data/catalogue.dart';
import 'category_screen.dart';
import 'coming_soon_screen.dart';
import 'sale_screen.dart';
import 'cart_screen.dart';

// 
// Home screen - ultra luxury editorial layout
//
// Sections (top → bottom):
// 1. Top bar (Cartier wordmark)
// 2. Hero - full-width looping video carousel cycling through all 8 clips,
// with a tagline swap every 6 seconds
// 3. "THE MAISON" divider
// 4. Six category editorial sections. Each has:
// - a full-bleed hero (video if one is available, else a photo)
// - tagline overlay bottom-left
// - a horizontal carousel of thumbnails (remaining photos + any
// secondary video for that category)
// Home & Stationery has no video → shown as a split panel instead.
// 5. La Sélection banner (existing)
// 6. Footer wordmark
// 

//  Elegant taglines (provided by the user) 

const Map<String, String> _taglines = {
  'HIGH JEWELLERY':
      "Beyond rarity, beyond beauty - a dialogue between nature's most precious gifts and the hands that dare to reimagine them. Each piece exists only once. So does its wearer.",
  'JEWELLERY':
      "Not to adorn, but to reveal. Every curve, every stone, every light that catches - a reflection of something already within you, now given its truest form.",
  'WATCHES':
      "Time bows to no one. But in the hands of Cartier, it learns to move with grace. An icon on the wrist - silent, certain, eternal.",
  'BAGS & ACCESSORIES':
      "Crafted not to be carried, but to accompany. Each piece holds the quiet authority of a maison that has dressed kings - and the intimacy of something made only for you.",
  'FRAGRANCES':
      "Invisible, yet unforgettable. A Cartier fragrance does not announce - it lingers in memory, like a name you cannot forget, a room you never want to leave.",
  'HOME & STATIONERY':
      "Where the world slows and beauty lives in every detail. Objects not of function, but of devotion - because how you live should honour who you are.",
};

//  Per-category asset manifest 

class _CatAssets {
  final String catKey; // maps to catalogue name (uppercased)
  final String heroVideo; // hero video for the section (empty if none)
  final List<String> carouselVideos;
  final List<String> photos;

  const _CatAssets({
    required this.catKey,
    this.heroVideo = '',
    this.carouselVideos = const [],
    this.photos = const [],
  });
}

const _hjAssets = _CatAssets(
  catKey: 'HIGH JEWELLERY',
  heroVideo: 'assets/videos/home_hj_v1.mp4',
  photos: [
    'assets/images/home_hj_1.jpg',
    'assets/images/home_hj_2.jpg',
    'assets/images/home_hj_3.jpg',
  ],
);
const _jwAssets = _CatAssets(
  catKey: 'JEWELLERY',
  heroVideo: 'assets/videos/home_jw_v1.mp4',
  carouselVideos: ['assets/videos/home_jw_v2.mp4'],
  photos: [
    'assets/images/home_jw_1.jpg',
    'assets/images/home_jw_2.jpg',
    'assets/images/home_jw_3.jpg',
    'assets/images/home_jw_4.jpg',
  ],
);
const _wtAssets = _CatAssets(
  catKey: 'WATCHES',
  heroVideo: 'assets/videos/home_wt_v1.mp4',
  carouselVideos: ['assets/videos/home_wt_v2.mp4'],
  photos: [
    'assets/images/home_wt_1.jpg',
    'assets/images/home_wt_2.jpg',
    'assets/images/home_wt_3.jpg',
    'assets/images/home_wt_4.jpg',
  ],
);
const _bgAssets = _CatAssets(
  catKey: 'BAGS & ACCESSORIES',
  heroVideo: 'assets/videos/home_bg_v1.mp4',
  photos: [
    'assets/images/home_bg_1.jpg',
    'assets/images/home_bg_2.jpg',
    'assets/images/home_bg_3.jpg',
    'assets/images/home_bg_4.jpg',
  ],
);
const _frAssets = _CatAssets(
  catKey: 'FRAGRANCES',
  heroVideo: 'assets/videos/home_fr_v1.mp4',
  photos: [
    'assets/images/home_fr_1.jpg',
    'assets/images/home_fr_2.jpg',
    'assets/images/home_fr_3.jpg',
  ],
);
const _hsAssets = _CatAssets(
  catKey: 'HOME & STATIONERY',
  photos: [
    'assets/images/home_hs_1.jpg',
    'assets/images/home_hs_2.jpg',
  ],
);

// All 8 videos for the hero carousel, in viewing order.
const List<_HeroSlide> _heroSlides = [
  _HeroSlide('assets/videos/home_hj_v1.mp4', 'HIGH JEWELLERY'),
  _HeroSlide('assets/videos/home_jw_v1.mp4', 'JEWELLERY'),
  _HeroSlide('assets/videos/home_jw_v2.mp4', 'JEWELLERY'),
  _HeroSlide('assets/videos/home_wt_v1.mp4', 'WATCHES'),
  _HeroSlide('assets/videos/home_wt_v2.mp4', 'WATCHES'),
  _HeroSlide('assets/videos/home_bg_v1.mp4', 'BAGS & ACCESSORIES'),
  _HeroSlide('assets/videos/home_fr_v1.mp4', 'FRAGRANCES'),
];

class _HeroSlide {
  final String videoPath;
  final String catKey;
  const _HeroSlide(this.videoPath, this.catKey);
}

// 
// Home screen
// 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = Catalogue.categories;

    return SafeArea(
      child: CustomScrollView(
        // Smooth iOS-style scroll + bigger offscreen render window so
        // videos/images don't pop in when they enter the viewport.
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        cacheExtent: 2200,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, size: 22),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'CARTIER',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 6,
                          fontFamily: 'Basis',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, size: 22),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),

          //  1. Hero video carousel 
          const SliverToBoxAdapter(child: _HeroCarousel()),

          //  2. "THE MAISON" divider 
          const SliverToBoxAdapter(child: _MaisonDivider()),

          //  3. Six editorial sections 
          // Each section's hero video is initialised after a staggered
          // delay so the decoder isn't slammed with 5 clips at once.
          SliverToBoxAdapter(
            child: _CategorySection(
              assets: _hjAssets,
              category: cats[0],
              comingSoon: false,
              initDelayMs: 400,
            ),
          ),
          SliverToBoxAdapter(
            child: _CategorySection(
              assets: _jwAssets,
              category: cats[1],
              comingSoon: true,
              initDelayMs: 800,
            ),
          ),
          SliverToBoxAdapter(
            child: _CategorySection(
              assets: _wtAssets,
              category: cats[2],
              comingSoon: true,
              initDelayMs: 1200,
            ),
          ),
          SliverToBoxAdapter(
            child: _CategorySection(
              assets: _bgAssets,
              category: cats[3],
              comingSoon: true,
              initDelayMs: 1600,
            ),
          ),
          SliverToBoxAdapter(
            child: _CategorySection(
              assets: _frAssets,
              category: cats[4],
              comingSoon: true,
              initDelayMs: 2000,
            ),
          ),
          SliverToBoxAdapter(
            child: _HomeStationerySection(
              assets: _hsAssets,
              category: cats[5],
            ),
          ),

          //  4. La Sélection banner 
          const SliverToBoxAdapter(child: _SelectionBanner()),

          //  5. Footer wordmark 
          const SliverToBoxAdapter(child: _FooterWordmark()),
        ],
      ),
    );
  }
}

// 
// 1. Hero video carousel (auto-advancing)
// 

class _HeroCarousel extends StatefulWidget {
  const _HeroCarousel();

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoAdvance;

  @override
  void initState() {
    super.initState();
    _autoAdvance = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!mounted) return;
      final next = (_currentIndex + 1) % _heroSlides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoAdvance?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 540,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemCount: _heroSlides.length,
            itemBuilder: (context, index) {
              final slide = _heroSlides[index];
              final tagline = _taglines[slide.catKey] ?? '';
              return _HeroSlideView(
                videoPath: slide.videoPath,
                categoryName: slide.catKey,
                tagline: tagline,
                isActive: index == _currentIndex,
              );
            },
          ),

          // Dots indicator
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_heroSlides.length, (i) {
                final active = i == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 5,
                  height: 2,
                  color:
                      active ? Colors.white : Colors.white.withOpacity(0.5),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSlideView extends StatefulWidget {
  final String videoPath;
  final String categoryName;
  final String tagline;
  final bool isActive;

  const _HeroSlideView({
    required this.videoPath,
    required this.categoryName,
    required this.tagline,
    required this.isActive,
  });

  @override
  State<_HeroSlideView> createState() => _HeroSlideViewState();
}

class _HeroSlideViewState extends State<_HeroSlideView> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    // Only initialise the video when this slide is actually active.
    // Adjacent pages of a PageView stay in memory, but we don't need them
    // decoding frames until they come into view.
    if (!widget.isActive) return;
    if (_controller != null) return;
    final c = VideoPlayerController.asset(widget.videoPath);
    _controller = c;
    try {
      await c.initialize();
      if (!mounted) {
        c.dispose();
        _controller = null;
        return;
      }
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
      setState(() => _ready = true);
    } catch (_) {
      // Leave _ready = false - fallback UI will show
    }
  }

  @override
  void didUpdateWidget(covariant _HeroSlideView old) {
    super.didUpdateWidget(old);
    // Slide just became active → lazily init if we haven't yet.
    if (widget.isActive && _controller == null) {
      _initVideo();
      return;
    }
    final c = _controller;
    if (c == null || !_ready) return;
    if (widget.isActive && !c.value.isPlaying) c.play();
    if (!widget.isActive && c.value.isPlaying) c.pause();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tap the hero → find and open that category on the list below.
        // For simplicity, we just scroll the feed. Routing is optional here.
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video layer
          if (_ready && _controller != null && _controller!.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            )
          else
            Container(color: const Color(0xFF1A1A1A)),

          // Dark gradient top + bottom for legibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.45),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.75),
                ],
                stops: const [0.0, 0.25, 0.55, 1.0],
              ),
            ),
          ),

          // Top-left red label
          Positioned(
            top: 22,
            left: 24,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFFD50032), width: 0.8),
              ),
              child: const Text(
                'MAISON CARTIER',
                style: TextStyle(
                  color: Color(0xFFD50032),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.5,
                ),
              ),
            ),
          ),

          // Bottom text block
          Positioned(
            left: 24,
            right: 24,
            bottom: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.categoryName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 4,
                    fontFamily: 'Basis',
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.tagline,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    height: 1.7,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'DISCOVER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(width: 22, height: 0.8, color: Colors.white),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward,
                        size: 13, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 
// 2. "THE MAISON" divider
// 

class _MaisonDivider extends StatelessWidget {
  const _MaisonDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 50, 32, 30),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Divider(color: Color(0xFFCCCCCC), thickness: 0.6),
              ),
              const SizedBox(width: 14),
              const Text(
                'THE MAISON',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  color: Color(0xFFD50032),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Divider(color: Color(0xFFCCCCCC), thickness: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Six houses. One legacy.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// 
// 3. Category section - hero video/photo + thumbnail carousel
// 

class _CategorySection extends StatelessWidget {
  final _CatAssets assets;
  final MainCategory category;
  final bool comingSoon;
  final int initDelayMs;

  const _CategorySection({
    required this.assets,
    required this.category,
    required this.comingSoon,
    this.initDelayMs = 0,
  });

  void _openCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => comingSoon
            ? ComingSoonScreen(title: category.name)
            : CategoryScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagline = _taglines[assets.catKey] ?? '';

    // Thumbnails = all secondary videos + all photos except [0] which is
    // used only as a fallback for the hero if there's no video.
    final hasHeroVideo = assets.heroVideo.isNotEmpty;
    final photos = assets.photos;
    final carouselItems = <_ThumbItem>[
      ...assets.carouselVideos.map((v) => _ThumbItem(path: v, isVideo: true)),
      // If we have a hero video, show all photos in the carousel.
      // If we don't, photo[0] is the hero, so skip it.
      ...photos
          .skip(hasHeroVideo ? 0 : 1)
          .map((p) => _ThumbItem(path: p, isVideo: false)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  Hero 
        GestureDetector(
          onTap: () => _openCategory(context),
          child: SizedBox(
            height: 460,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasHeroVideo)
                  _SectionVideo(
                    path: assets.heroVideo,
                    initDelayMs: initDelayMs,
                  )
                else if (photos.isNotEmpty)
                  Image.asset(
                    photos.first,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFF1A1A1A)),
                  )
                else
                  Container(color: const Color(0xFF1A1A1A)),

                // Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.78),
                      ],
                      stops: const [0.0, 0.25, 0.5, 1.0],
                    ),
                  ),
                ),

                // Text block
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 36,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 3.5,
                          fontFamily: 'Basis',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                          width: 32,
                          height: 1.2,
                          color: const Color(0xFFD50032)),
                      const SizedBox(height: 14),
                      Text(
                        tagline,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.92),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          height: 1.7,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            comingSoon ? 'COMING SOON' : 'EXPLORE',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                              width: 22, height: 0.8, color: Colors.white),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward,
                              size: 13, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        //  Thumbnail carousel 
        if (carouselItems.isNotEmpty) ...[
          const SizedBox(height: 22),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: carouselItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final item = carouselItems[i];
                return GestureDetector(
                  onTap: () => _openCategory(context),
                  child: SizedBox(
                    width: 190,
                    child: item.isVideo
                        ? _SectionVideo(path: item.path, corner: 2)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: Image.asset(
                              item.path,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFFF0EDEA)),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],

        const SizedBox(height: 50),
      ],
    );
  }
}

class _ThumbItem {
  final String path;
  final bool isVideo;
  const _ThumbItem({required this.path, required this.isVideo});
}

//  Reusable section video widget 

class _SectionVideo extends StatefulWidget {
  final String path;
  final double corner;
  final int initDelayMs;
  const _SectionVideo({
    required this.path,
    this.corner = 0,
    this.initDelayMs = 0,
  });

  @override
  State<_SectionVideo> createState() => _SectionVideoState();
}

class _SectionVideoState extends State<_SectionVideo> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    // Stagger video initialisation to avoid decoder contention.
    Future.delayed(Duration(milliseconds: widget.initDelayMs), _init);
  }

  Future<void> _init() async {
    if (!mounted) return;
    final c = VideoPlayerController.asset(widget.path);
    _controller = c;
    try {
      await c.initialize();
      if (!mounted) {
        c.dispose();
        return;
      }
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
      setState(() => _ready = true);
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_ready && _controller != null) {
      child = FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      );
    } else {
      child = Container(color: const Color(0xFF1A1A1A));
    }
    if (widget.corner > 0) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(widget.corner),
        child: child,
      );
    }
    return SizedBox.expand(child: child);
  }
}

// 
// Home & Stationery - split panel, no video
// 

class _HomeStationerySection extends StatelessWidget {
  final _CatAssets assets;
  final MainCategory category;
  const _HomeStationerySection({
    required this.assets,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final tagline = _taglines[assets.catKey] ?? '';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ComingSoonScreen(title: category.name),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 420,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left - image with overlay text
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          assets.photos.isNotEmpty
                              ? assets.photos[0]
                              : 'assets/images/home_hs_1.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: const Color(0xFFF0EDEA)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.15),
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 2,
                                fontFamily: 'Basis',
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                                width: 22,
                                height: 1,
                                color: const Color(0xFFD50032)),
                            const SizedBox(height: 10),
                            Text(
                              tagline,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.92),
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                                height: 1.7,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'COMING SOON',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 2),
                // Right - clean image
                Expanded(
                  child: SizedBox.expand(
                    child: Image.asset(
                      assets.photos.length > 1
                          ? assets.photos[1]
                          : 'assets/images/home_hs_2.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFF0EDEA)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// 
// La Sélection banner (kept)
// 

class _SelectionBanner extends StatelessWidget {
  const _SelectionBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SaleScreen()),
      ),
      child: Container(
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.fromLTRB(24, 46, 24, 46),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFFD50032), width: 0.8),
              ),
              child: const Text(
                'TODAY ONLY',
                style: TextStyle(
                  color: Color(0xFFD50032),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.5,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'LA SÉLECTION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w400,
                letterSpacing: 6,
                fontFamily: 'Basis',
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'A curated window of our finest pieces -\nopen for six hours, every day.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 12,
                fontWeight: FontWeight.w300,
                height: 1.8,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ENTER LA SÉLECTION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 22,
                  height: 0.8,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward,
                    size: 13, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 
// Footer wordmark
// 

class _FooterWordmark extends StatelessWidget {
  const _FooterWordmark();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: Column(
        children: [
          Text(
            'CARTIER',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 8,
              fontFamily: 'Basis',
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Maître Joaillier',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.5,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'depuis 1847 · Paris',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.5,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

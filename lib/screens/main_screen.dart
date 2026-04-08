import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'shop_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'wheel_screen.dart';
import '../services/wheel_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _pendingIndex = 0;
  bool _showTransition = false;

  // ── Debug HUD (small counter showing wheel schedule) ──
  int _openCount = 0;
  int _nextWheelOpen = 0;

  late AnimationController _controller;

  // Simple opacity fade for the white overlay covering the screen swap.
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = const [
    HomeScreen(),
    ShopScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkAndShowWheel();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Bell curve: 0 → 1 → 0 (fade in, hold, fade out)
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 30),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
    ]).animate(_controller);
  }

  Future<void> _checkAndShowWheel() async {
    final show = await WheelService.recordOpenAndCheck();
    final count = await WheelService.getOpenCount();
    if (mounted) {
      setState(() {
        _openCount = count;
        _nextWheelOpen = WheelService.nextTriggerOpen(count);
      });
    }
    if (show && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WheelScreen()),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex || _showTransition) return;

    setState(() {
      _pendingIndex = index;
      _showTransition = true;
    });

    // Swap the screen at the midpoint — while the overlay still hides it
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _currentIndex = _pendingIndex);
    });

    _controller.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() => _showTransition = false);
        _controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Active screen ──────────────────────────────────────────────
          _screens[_currentIndex],

          // ── Debug counter (top-right) ──────────────────────────────────
          Positioned(
            top: 38,
            right: 10,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'open #$_openCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      'next 🎡 #$_nextWheelOpen',
                      style: const TextStyle(
                        color: Color(0xFFFFB3C1),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Simple fade overlay ────────────────────────────────────────
          if (_showTransition)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return IgnorePointer(
                  ignoring: _fadeAnimation.value < 0.05,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(color: Colors.white),
                  ),
                );
              },
            ),
        ],
      ),

      // ── Bottom navigation ──────────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color(0xFF9E9E9E),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(letterSpacing: 0.5),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }
}

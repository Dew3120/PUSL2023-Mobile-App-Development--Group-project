import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late VideoPlayerController _controller;
  bool _isMuted = false;
  bool _isReady = false;
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/background.mp4')
      ..setLooping(true)
      ..setVolume(1.0)
      ..initialize().then((_) {
        _controller.play();
        if (mounted) setState(() => _isReady = true);
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-decode the login background so the next screen has zero flash.
    if (!_precached) {
      _precached = true;
      precacheImage(
        const AssetImage('assets/images/login_bg.jpg'),
        context,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _goToMain() {
    _controller.pause();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background video
          if (_isReady)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),

          // Dark overlay for readability
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0x99000000),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Mute button — top right
          Positioned(
            top: 52,
            right: 20,
            child: GestureDetector(
              onTap: _toggleMute,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          // Start button — bottom center
          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: GestureDetector(
              onTap: _goToMain,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.2),
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.transparent,
                ),
                child: const Center(
                  child: Text(
                    'E N T E R',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      letterSpacing: 6,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Basis',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

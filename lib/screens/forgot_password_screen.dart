import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Please enter your email address.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await AuthService.sendPasswordReset(email);
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AuthService.parseError(e);
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withOpacity(0.18)),
          ),
          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const Spacer(flex: 2),

                // Logo
                const Column(
                  children: [
                    Text(
                      'MY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 6,
                        fontFamily: 'Basis',
                      ),
                    ),
                    Text(
                      'CARTIER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 8,
                        fontFamily: 'Basis',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                if (_sent) ...[
                  // ── Success state ──
                  const Icon(Icons.mark_email_read_outlined,
                      color: Colors.white, size: 52),
                  const SizedBox(height: 20),
                  const Text(
                    'EMAIL SENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      'We\'ve sent a password reset link to your email. Please check your inbox and follow the instructions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        height: 1.7,
                      ),
                    ),
                  ),
                ] else ...[
                  // ── Input state ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      'Enter the email address associated with your account and we\'ll send you a reset link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        height: 1.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.6),
                                  width: 0.8),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                const Spacer(flex: 3),

                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : (_sent ? () => Navigator.pop(context) : _onSend),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.white70,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.black54, strokeWidth: 2),
                            )
                          : Text(
                              _sent ? 'BACK TO SIGN IN' : 'SEND RESET LINK',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.5,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

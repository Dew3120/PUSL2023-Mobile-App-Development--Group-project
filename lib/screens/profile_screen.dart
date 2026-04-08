import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'panther_screen.dart';
import 'cart_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _shopPreference = 'Women';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── Sticky header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ravini',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, size: 24),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, size: 24),
                      onPressed: () {
                        // ── ADDED NAVIGATION HERE ──
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Scrollable body ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [

                // ── FOR THE PANTHER (top priority) ──
                _ForThePantherCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PantherScreen()),
                  ),
                ),

                const SizedBox(height: 28),

                // ── MY LOYALTY PROGRAM ──
                _sectionHeader('My Loyalty Program'),
                const SizedBox(height: 10),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'ACCESS ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                      TextSpan(
                        text: 'Bronze',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFD50032),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Learn more about your progress and rewards',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),

                const SizedBox(height: 32),

                // ── MY ACCOUNT ──
                _sectionHeader('My Account'),
                const SizedBox(height: 8),
                _simpleItem('Orders and Returns'),
                _simpleItem('Details and Security'),
                _simpleItem('Address book'),

                const SizedBox(height: 32),

                // ── LANGUAGE AND REGION ──
                _sectionHeader('Language and region'),
                const SizedBox(height: 8),
                _flagItem('🇬🇧', 'English (United Kingdom)', 'Language'),
                _flagItem('🇬🇧', 'United Kingdom  GBP £', 'Region'),
                const SizedBox(height: 10),
                Text(
                  'You\'re currently shopping in United Kingdom and will be billed in GBP £',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),

                const SizedBox(height: 32),

                // ── MY SHOP PREFERENCES ──
                _sectionHeader('My Shop Preferences'),
                const SizedBox(height: 8),
                _radioItem('Women'),
                _radioItem('Men'),
                const SizedBox(height: 8),
                Text(
                  'This will tailor your app experience, showing you the type of products most suited to you',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),

                const SizedBox(height: 32),

                // ── MY SETTINGS ──
                _sectionHeader('My Settings'),
                const SizedBox(height: 8),
                _simpleItem('Communication Preferences'),

                const SizedBox(height: 32),

                // ── SUPPORT ──
                _sectionHeader('Support'),
                const SizedBox(height: 8),
                _simpleItem('About Cartier'),
                _simpleItem('Terms & conditions'),
                _simpleItem('Privacy Policy'),
                _simpleItem('Do not sell my info'),
                _simpleItem('FAQ\'s & guides'),

                const SizedBox(height: 32),

                // ── WE'RE HERE TO HELP ──
                _sectionHeader('We\'re here to help'),
                const SizedBox(height: 6),
                Text(
                  'Get in touch with our Global Customer Service team.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // Contact Us button — outlined
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text(
                      'Contact Us',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Sign out button — black filled
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                              (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _simpleItem(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
        ),
        Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }

  Widget _flagItem(String flag, String title, String subtitle) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }

  Widget _radioItem(String value) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _shopPreference = value),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: _shopPreference,
                  onChanged: (v) => setState(() => _shopPreference = v!),
                  activeColor: Colors.black,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }
}

// ── For the Panther card ─────────────────────────────────────────────────────

class _ForThePantherCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ForThePantherCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: [
            // Small red outlined panther icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFD50032), width: 1),
              ),
              child: const Center(
                child: Icon(
                  Icons.pets,
                  size: 16,
                  color: Color(0xFFD50032),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FOR THE PANTHER',
                    style: TextStyle(
                      color: const Color(0xFFD50032).withOpacity(0.95),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'La Panthère',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                      fontFamily: 'Basis',
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Our tribute to the wild panther',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 12, color: Color(0xFF888888)),
          ],
        ),
      ),
    );
  }
}
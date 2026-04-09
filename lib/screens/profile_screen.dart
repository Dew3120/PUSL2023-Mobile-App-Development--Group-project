import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import 'account_screens.dart';
import 'login_screen.dart';
import 'loyalty_screen.dart';
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
          //  Sticky header 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AuthService.displayNameOrEmailPrefix(),
                  style: const TextStyle(
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

          //  Scrollable body 
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [

                //  FOR THE PANTHER (top priority) 
                _ForThePantherCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PantherScreen()),
                  ),
                ),

                const SizedBox(height: 28),

                //  MY LOYALTY PROGRAM 
                _sectionHeader('My Loyalty Program'),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoyaltyScreen()),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
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
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios,
                                size: 14, color: Color(0xFF999999)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Learn more about your progress and rewards',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                //  MY ACCOUNT 
                _sectionHeader('My Account'),
                const SizedBox(height: 8),
                _simpleItem(
                  'Orders and Returns',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const OrdersScreen()),
                  ),
                ),
                _simpleItem(
                  'Details and Security',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DetailsScreen()),
                  ),
                ),
                _simpleItem(
                  'Address book',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddressBookScreen()),
                  ),
                ),

                const SizedBox(height: 32),

                //  LANGUAGE AND REGION 
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

                //  MY SHOP PREFERENCES 
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

                //  MY SETTINGS 
                _sectionHeader('My Settings'),
                const SizedBox(height: 8),
                _simpleItem('Communication Preferences'),

                const SizedBox(height: 32),

                //  SUPPORT 
                _sectionHeader('Support'),
                const SizedBox(height: 8),
                _simpleItem(
                  'About Cartier',
                  onTap: () => _confirmExternalLink(
                    context,
                    title: 'About Cartier',
                    url: 'https://www.cartier.com/en-us/la-maison-cartier/',
                  ),
                ),
                _simpleItem(
                  'Terms & conditions',
                  onTap: () => _confirmExternalLink(
                    context,
                    title: 'Terms & Conditions',
                    url:
                        'https://www.cartier.com/en-us/legal-area/terms-of-use.html',
                  ),
                ),
                _simpleItem(
                  'Privacy Policy',
                  onTap: () => _confirmExternalLink(
                    context,
                    title: 'Privacy Policy',
                    url:
                        'https://www.cartier.com/en-us/legal-area/privacy-notice.html',
                  ),
                ),
                _simpleItem(
                  'Do not sell my info',
                  onTap: () => _confirmExternalLink(
                    context,
                    title: 'Do Not Sell My Info',
                    url:
                        'https://www.cartier.com/en-us/legal-area/do-not-sell-my-info.html',
                  ),
                ),
                _simpleItem(
                  "FAQ's & guides",
                  onTap: () => _confirmExternalLink(
                    context,
                    title: 'FAQs & Guides',
                    url: 'https://www.cartier.com/en-us/customer-service/',
                  ),
                ),

                const SizedBox(height: 32),

                //  WE'RE HERE TO HELP 
                _sectionHeader('We\'re here to help'),
                const SizedBox(height: 6),
                Text(
                  'Get in touch with our Global Customer Service team.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // Contact Us button - outlined
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => _showContactUsSheet(context),
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

                // Sign out button - black filled
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

  Widget _simpleItem(String title, {VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ),
                if (onTap != null)
                  const Icon(Icons.arrow_forward_ios,
                      size: 13, color: Color(0xFF999999)),
              ],
            ),
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

  //  External link permission popup 
  void _confirmExternalLink(
    BuildContext context, {
    required String title,
    required String url,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will open the official Cartier website in your browser.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              url,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontFamily: 'monospace',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final uri = Uri.parse(url);
              try {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not open the link'),
                      backgroundColor: Colors.black87,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
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
              'CONTINUE',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Contact Us bottom sheet 
  void _showContactUsSheet(BuildContext context) {
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
              'CONTACT US',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Our client advisors are available to assist you with any question.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                height: 1.6,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 22),
            _contactTile(
              icon: Icons.phone_outlined,
              title: 'Call us',
              subtitle: '+1 800 CARTIER (227 8437)',
              hint: 'Mon - Sat · 9am - 9pm EST',
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _contactTile(
              icon: Icons.mail_outline,
              title: 'Email',
              subtitle: 'clientrelations@cartier.com',
              hint: 'Replies within 24 hours',
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _contactTile(
              icon: Icons.chat_bubble_outline,
              title: 'Live chat',
              subtitle: 'Speak to an advisor now',
              hint: 'Available 24/7',
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _contactTile(
              icon: Icons.location_on_outlined,
              title: 'Nearest boutique',
              subtitle: '653 Fifth Avenue, New York',
              hint: 'Find a location worldwide',
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
                      borderRadius: BorderRadius.circular(2)),
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

  Widget _contactTile({
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
                      fontSize: 13, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 2),
                Text(
                  hint,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFAAAAAA)),
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

//  For the Panther card 

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
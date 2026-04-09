import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PantherScreen extends StatelessWidget {
  const PantherScreen({super.key});

  static const _pantheraUrl = 'https://panthera.org';

  Future<void> _openPanthera(BuildContext context) async {
    final uri = Uri.parse(_pantheraUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not open the link. Please try again.'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          //  App bar 
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  size: 18, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'FOR THE PANTHER',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 3,
              ),
            ),
            centerTitle: true,
          ),

          //  Hero image with fading top & bottom edges 
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.18, 0.82, 1.0],
                ).createShader(bounds),
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  width: double.infinity,
                  height: 360,
                  child: Image.asset(
                    'assets/images/for_the_panther.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(
                      color: const Color(0xFFF0EDEA),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined,
                                size: 40, color: Color(0xFFCBC2B8)),
                            SizedBox(height: 10),
                            Text(
                              'Add your panther image to\nassets/images/for_the_panther.jpg',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF888888),
                                fontWeight: FontWeight.w300,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          //  Body 
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Small red label
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFD50032), width: 0.8),
                      ),
                      child: const Text(
                        'IN PARTNERSHIP WITH PANTHERA',
                        style: TextStyle(
                          color: Color(0xFFD50032),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Headline
                  const Center(
                    child: Text(
                      'La Panthère',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                        fontFamily: 'Basis',
                        height: 1.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'Our eternal muse · Our quiet promise',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 28),

                  // Heritage paragraph
                  const Text(
                    'OUR MUSE SINCE 1914',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The panther has walked beside the Maison for more than a century. '
                    'She first appeared in a Cartier illustration in 1914 - wild, elegant, '
                    'impossible to tame - and soon became the spirit of the house. '
                    'Jeanne Toussaint, our legendary Directrice of Haute Joaillerie, was '
                    'affectionately called "La Panthère" by Louis Cartier himself. Under her '
                    'hand, the creature became Cartier\'s quiet symbol of grace, strength, '
                    'and freedom.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.85,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Partnership paragraph
                  const Text(
                    'HOW WE WORK TOGETHER',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We owe her everything - and so we stand beside those who protect her. '
                    'Cartier partners with Panthera, the world\'s leading wild cat '
                    'conservation organisation, to safeguard panthers, leopards, jaguars '
                    'and snow leopards in their natural habitats. Together, we support '
                    'anti-poaching patrols, scientific research, and community programmes '
                    'across Africa, Asia and the Americas, so that the panther\'s song '
                    'never falls silent in the wild.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.85,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Gratitude paragraph
                  const Text(
                    'WITH GRATITUDE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                      color: Color(0xFFD50032),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The panther has given Cartier a soul. In return, we promise to '
                    'return the favour - piece by piece, pawprint by pawprint. Every '
                    'jewel carrying her silhouette is a small thank-you to the wild. '
                    'And every tap on the link below carries that same gratitude a '
                    'little further. Thank you for walking with us.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.85,
                      color: Colors.grey[800],
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 40),

                  //  CTA 
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => _openPanthera(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'VISIT PANTHERA.ORG',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.5,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.open_in_new, size: 14),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      'Opens panthera.org in your browser',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

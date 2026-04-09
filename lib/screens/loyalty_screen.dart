import 'package:flutter/material.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  // Demo: user currently on Bronze.
  final String _currentTier = 'Bronze';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'LOYALTY PROGRAM',
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        children: [
          //  Intro 
          const Text(
            'MY CARTIER CIRCLE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.5,
              color: Color(0xFFD50032),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'A rewarding journey',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
              fontFamily: 'Basis',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Unlock exclusive benefits, previews, and experiences as you progress through our three membership tiers.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              height: 1.8,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 30),

          //  Tier cards 
          _TierCard(
            tierName: 'BRONZE',
            subtitle: 'Welcome tier',
            price: 'Included',
            accent: const Color(0xFFB08D57),
            current: _currentTier == 'Bronze',
            perks: const [
              'Personalized product recommendations',
              'Early access to seasonal campaigns',
              'Complimentary gift wrapping',
              'Birthday message from Cartier',
            ],
            onSubscribe: () {},
          ),
          const SizedBox(height: 16),
          _TierCard(
            tierName: 'SILVER',
            subtitle: 'Valued member',
            price: '\$250 / year',
            accent: const Color(0xFF9AA0A6),
            current: _currentTier == 'Silver',
            perks: const [
              'All Bronze benefits',
              'Priority client advisor',
              'Private in-boutique appointments',
              'Early access to new collections',
              'Complimentary engraving on select pieces',
            ],
            onSubscribe: () => _showSubscribeDialog(context, 'Silver'),
          ),
          const SizedBox(height: 16),
          _TierCard(
            tierName: 'GOLD',
            subtitle: 'Maison inner circle',
            price: '\$1,000 / year',
            accent: const Color(0xFFD4AF37),
            current: _currentTier == 'Gold',
            perks: const [
              'All Silver benefits',
              'Dedicated ambassador on call 24/7',
              'Invitations to private Maison events',
              'Preview of High Jewellery collections',
              'Complimentary lifetime cleaning & servicing',
              'Annual Cartier gift',
            ],
            onSubscribe: () => _showSubscribeDialog(context, 'Gold'),
          ),

          const SizedBox(height: 30),

          Text(
            'Prices shown are demo values. All tiers bill in local currency through your default payment method.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _showSubscribeDialog(BuildContext context, String tier) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        title: Text(
          'Upgrade to $tier',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        content: Text(
          'You are about to upgrade your membership to the $tier tier. You will be redirected to the secure payment portal to complete your subscription.',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Redirecting to $tier subscription...'),
                  backgroundColor: Colors.black87,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: const Text('CONTINUE',
                style: TextStyle(
                    fontWeight: FontWeight.w600, letterSpacing: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final String tierName;
  final String subtitle;
  final String price;
  final Color accent;
  final bool current;
  final List<String> perks;
  final VoidCallback onSubscribe;

  const _TierCard({
    required this.tierName,
    required this.subtitle,
    required this.price,
    required this.accent,
    required this.current,
    required this.perks,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: current ? accent.withOpacity(0.06) : Colors.white,
        border: Border.all(
          color: current ? accent : const Color(0xFFE0E0E0),
          width: current ? 1.4 : 0.8,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 26, height: 0.9, color: accent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tierName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (current)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  color: accent,
                  child: const Text(
                    'CURRENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            price,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 18),
          ...perks.map((perk) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child:
                          Container(width: 4, height: 4, color: accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        perk,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w300,
                          height: 1.7,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          if (!current)
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                child: Text(
                  'UPGRADE TO $tierName',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

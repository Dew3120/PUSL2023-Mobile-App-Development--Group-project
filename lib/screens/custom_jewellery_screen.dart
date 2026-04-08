import 'package:flutter/material.dart';
import 'bespoke_booking_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_details_screen.dart';

class CustomJewelleryScreen extends StatefulWidget {
  const CustomJewelleryScreen({super.key});

  @override
  State<CustomJewelleryScreen> createState() => _CustomJewelleryScreenState();
}

class _CustomJewelleryScreenState extends State<CustomJewelleryScreen> {
  // State variables
  String? _selectedType = 'Ring';
  String? _selectedMetal = 'Gold';
  String? _selectedGemstone = 'Diamond';
  String? _selectedOccasion = 'Everyday';

  final TextEditingController _descriptionController = TextEditingController();
  int _attemptCounter = 0;

  // Mock data successfully removed!

  void _handleGenerate() async {
    // 1. Show a loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.black)),
    );

    try {
      // 2. Fetch the inventory from Firebase Firestore
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();

      // Close the loading circle
      if (mounted) Navigator.pop(context);

      // 3. FAILSafe: Check if the database is empty
      if (snapshot.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No products found in Firebase. Please add items to the "products" collection.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return; // Stop running the function
      }

      // 4. Convert Firestore documents into a list we can score
      List<Map<String, dynamic>> scoredItems = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        int score = 0;
        // Match against the exact field names in your Firestore database
        if (data['type'] == _selectedType) score += 10;
        if (data['metal'] == _selectedMetal) score += 3;
        if (data['gemstone'] == _selectedGemstone) score += 3;
        if (data['occasion'] == _selectedOccasion) score += 1;

        // Provide fallback values just in case a field is missing in Firebase
        return {
          'productData': {
            'name': data['name'] ?? 'Unknown Item',
            'price': data['price'] ?? 'Price upon request',
            'type': data['type'] ?? 'N/A',
            'metal': data['metal'] ?? 'N/A',
            'gemstone': data['gemstone'] ?? 'N/A',
            'occasion': data['occasion'] ?? 'N/A',
          },
          'score': score
        };
      }).toList();

      // 5. Sort items from highest score to lowest
      scoredItems.sort((a, b) => b['score'].compareTo(a['score']));

      // 6. Run the 3-Attempt Logic
      final bestMatch = scoredItems[0]['productData'];
      final highestScore = scoredItems[0]['score'];
      final secondBestMatch = scoredItems.length > 1 ? scoredItems[1]['productData'] : bestMatch;

      setState(() {
        if (highestScore == 17) {
          _attemptCounter = 0;
          _showResultDialog(bestMatch, "Perfect Match Found!");
        } else {
          _attemptCounter++;

          if (_attemptCounter == 1) {
            _showResultDialog(bestMatch, "We don't have this exact combination, but this stunning piece aligns beautifully with your style.");
          } else if (_attemptCounter == 2) {
            _showResultDialog(secondBestMatch, "Still exploring? Here is another exquisite option curated from our collection.");
          } else if (_attemptCounter >= 3) {
            _attemptCounter = 0;
            _navigateToBespokeConsultation();
          }
        }
      });
    } catch (e) {
      // FAILSafe: Catch network errors or missing packages
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _showResultDialog(Map<String, dynamic> product, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text(
          'MY CARTIER',
          style: TextStyle(fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: TextStyle(color: Colors.grey[700], fontSize: 13), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Icon(Icons.diamond_outlined, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(product['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(product['price'], style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog first
              Navigator.push(         // Push the user to the details screen
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            ),
            child: const Text('VIEW ITEM', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToBespokeConsultation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text('Bespoke Request', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.architecture, size: 60, color: Colors.black87),
                  const SizedBox(height: 24),
                  const Text(
                    'Your vision is truly one-of-a-kind.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Since you have a very specific design in mind, let our master artisans bring it to life.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BespokeBookingScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('BOOK A CONSULTATION', style: TextStyle(color: Colors.white, letterSpacing: 1)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Custom Jewellery',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/cartier-hd-logo.png',
                  height: 18,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Design your perfect piece',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle('JEWELLERY TYPE'),
                  _buildOptionGrid(
                    ['Ring', 'Necklace', 'Bracelet', 'Earring'],
                    _selectedType,
                        (val) => setState(() => _selectedType = val),
                  ),

                  _buildSectionTitle('METAL TYPE'),
                  _buildOptionGrid(
                    ['Gold', 'Silver', 'Rose Gold'],
                    _selectedMetal,
                        (val) => setState(() => _selectedMetal = val),
                  ),

                  _buildSectionTitle('GEMSTONE'),
                  _buildOptionGrid(
                    ['Diamond', 'Ruby', 'Sapphire', 'Emerald'],
                    _selectedGemstone,
                        (val) => setState(() => _selectedGemstone = val),
                  ),

                  _buildSectionTitle('OCCASION'),
                  _buildOptionGrid(
                    ['Wedding', 'Everyday', 'Gift', 'Anniversary'],
                    _selectedOccasion,
                        (val) => setState(() => _selectedOccasion = val),
                  ),

                  _buildSectionTitle('DESCRIBE YOUR PIECE'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'e.g. A vintage style ring with a ruby...',
                      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Sticky Bottom Generate Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
            ),
            child: ElevatedButton(
              onPressed: _handleGenerate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'GENERATE MY DESIGN',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 24),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          letterSpacing: 3,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildOptionGrid(List<String> options, String? selectedValue, Function(String) onSelect) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isSelected = option == selectedValue;
        return GestureDetector(
          onTap: () => onSelect(option),
          child: Container(
            width: (MediaQuery.of(context).size.width - 44) / 2,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
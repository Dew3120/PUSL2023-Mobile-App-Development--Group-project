import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bespoke_booking_screen.dart';
import 'product_detail_screen.dart';
import '../data/catalogue.dart';
import 'auto_sale_screen.dart';

class CustomJewelleryScreen extends StatefulWidget {
  const CustomJewelleryScreen({super.key});

  @override
  State<CustomJewelleryScreen> createState() => _CustomJewelleryScreenState();
}

class _CustomJewelleryScreenState extends State<CustomJewelleryScreen> {

  String? _selectedType = 'Ring';
  String? _selectedMetal = 'Gold';
  String? _selectedGemstone = 'Diamond';
  String? _selectedOccasion = 'Everyday';

  final TextEditingController _descriptionController = TextEditingController();
  int _attemptCounter = 0;
  bool _isGenerating = false;

  void _handleGenerate() {
    if (_isGenerating) return;
    setState(() => _isGenerating = true);


    final List<Map<String, dynamic>> saleItems = AutoSaleData.getPermanentSaleItems();

    if (saleItems.isEmpty && mounted) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catalogue is currently updating.'), backgroundColor: Colors.black),
      );
      return;
    }

    List<Map<String, dynamic>> scoredItems = saleItems.map((item) {
      final Product p = item['product'];
      final double displayPrice = item['salePrice'];

      int score = 0;
      final searchString = '${p.name} ${p.collection} ${p.description}'.toLowerCase();

      if (searchString.contains(_selectedType!.toLowerCase())) score += 10;
      if (searchString.contains(_selectedMetal!.toLowerCase())) score += 3;
      if (searchString.contains(_selectedGemstone!.toLowerCase())) score += 3;
      score += 1;

      return {
        'product': p,
        'displayPrice': displayPrice,
        'score': score
      };
    }).toList();

    scoredItems.sort((a, b) => b['score'].compareTo(a['score']));

    final bestMatchMap = scoredItems[0];
    final secondBestMatchMap = scoredItems.length > 1 ? scoredItems[1] : bestMatchMap;
    final highestScore = bestMatchMap['score'] as int;

    setState(() {
      _isGenerating = false;
      if (highestScore >= 16) {
        _attemptCounter = 0;
      } else {
        _attemptCounter++;
      }
    });

    if (_attemptCounter >= 3) {
      setState(() => _attemptCounter = 0);
      _showLoadingAndNavigateToBespoke();
    } else {
      Product productToShow;
      double priceToShow;
      String messageToShow;

      if (highestScore >= 16) {
        productToShow = bestMatchMap['product'];
        priceToShow = bestMatchMap['displayPrice'];
        messageToShow = "Perfect Match Found!";
      } else if (_attemptCounter == 1) {
        productToShow = bestMatchMap['product'];
        priceToShow = bestMatchMap['displayPrice'];
        messageToShow = "We don't have this exact combination, but this stunning piece aligns beautifully with your vision.";
      } else {
        productToShow = secondBestMatchMap['product'];
        priceToShow = secondBestMatchMap['displayPrice'];
        messageToShow = "Still exploring? Here is another exquisite option curated from our collection.";
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _SmartCurateDialog(
          product: productToShow,
          salePrice: priceToShow,
          message: messageToShow,
        ),
      );
    }
  }

  void _showLoadingAndNavigateToBespoke() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
              const SizedBox(height: 24),
              Text(
                'PREPARING BESPOKE...',
                style: GoogleFonts.josefinSans(letterSpacing: 2, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                centerTitle: true,
                title: Text('Bespoke Request', style: GoogleFonts.josefinSans(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w300)),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.architecture, size: 48, color: Colors.black87),
                      const SizedBox(height: 32),
                      Text(
                        'YOUR VISION IS\nONE-OF-A-KIND',
                        style: GoogleFonts.josefinSans(fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 4, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Since you have a very specific design in mind, let our master artisans bring it to life.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.6),
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
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                        ),
                        child: const Text('BOOK A CONSULTATION', style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 12)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Custom Design',
          style: GoogleFonts.josefinSans(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://images.pexels.com/photos/6263143/pexels-photo-6263143.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      alignment: Alignment.center,
                      child: Text(
                        'CRAFT YOUR VISION',
                        style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Let us curate or craft a masterpiece perfectly suited to your specifications.',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 32),

                        _buildSectionTitle('JEWELLERY TYPE'),
                        _buildOptionGrid(
                          ['Ring', 'Necklace', 'Bracelet', 'Earring'],
                          _selectedType,
                              (val) => setState(() => _selectedType = val),
                        ),

                        _buildSectionTitle('METAL TYPE'),
                        _buildOptionGrid(
                          ['Gold', 'Silver', 'Rose Gold', 'Platinum'],
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

                        _buildSectionTitle('ADDITIONAL DETAILS'),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: 'e.g. A vintage style ring with a ruby center stone...',
                            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13, fontStyle: FontStyle.italic),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                )
              ],
            ),
            child: ElevatedButton(
              onPressed: _isGenerating ? null : _handleGenerate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey[400],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: Text(
                _isGenerating ? 'CURATING...' : 'CURATE MY DESIGN',
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 3,
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
      padding: const EdgeInsets.only(bottom: 16, top: 32),
      child: Text(
        title,
        style: GoogleFonts.josefinSans(
          fontSize: 12,
          letterSpacing: 3,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildOptionGrid(List<String> options, String? selectedValue, Function(String) onSelect) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = option == selectedValue;
        return GestureDetector(
          onTap: () => onSelect(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: (MediaQuery.of(context).size.width - 50) / 2,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey[300]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 12,
                letterSpacing: 1,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


class _SmartCurateDialog extends StatefulWidget {
  final Product product;
  final double salePrice;
  final String message;

  const _SmartCurateDialog({
    required this.product,
    required this.salePrice,
    required this.message,
  });

  @override
  State<_SmartCurateDialog> createState() => _SmartCurateDialogState();
}

class _SmartCurateDialogState extends State<_SmartCurateDialog> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
              const SizedBox(height: 24),
              Text(
                'CONSULTING THE ARCHIVES...',
                style: GoogleFonts.josefinSans(letterSpacing: 2, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }


    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      title: Text(
        'THE MAISON',
        style: GoogleFonts.josefinSans(fontSize: 16, letterSpacing: 4, fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.message, style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              widget.product.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                width: double.infinity,
                color: const Color(0xFFF9F8F6),
                child: const Center(
                  child: Icon(Icons.image_outlined, color: Colors.grey, size: 32),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(widget.product.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('£${widget.salePrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CLOSE', style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                    product: widget.product,
                  salePrice: widget.salePrice,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('VIEW PIECE', style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1)),
        ),
      ],
    );
  }
}
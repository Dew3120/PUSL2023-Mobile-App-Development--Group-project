import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/catalogue.dart';
import '../services/order_service.dart';
import 'panther_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Product product;

  const PaymentScreen({super.key, required this.product});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  String _method = 'Card';
  bool _processing = false;

  //  Demo tap-to-fill 
  // For the hero product (Panthère de Cartier ring, paved, id == 'pn1'),
  // each field auto-types its value the first time the presenter taps it.
  // This keeps the demo fast while still looking like real typing.
  late final bool _demoMode;
  late final Map<TextEditingController, String> _demoValues;
  final Set<TextEditingController> _filledFields = {};
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _demoMode = widget.product.id == 'pn1';
    _demoValues = {
      _nameController: 'Dewmina Rajarathna',
      _cardController: '4532 1548 0343 6467',
      _expiryController: '12/28',
      _cvvController: '318',
      _addressController: '13 Rue de la Paix',
      _cityController: 'Paris',
      _zipController: '75002',
    };
  }

  Future<void> _demoFill(TextEditingController controller) async {
    if (!_demoMode) return;
    if (_isTyping) return;
    if (_filledFields.contains(controller)) return;
    if (controller.text.isNotEmpty) {
      _filledFields.add(controller);
      return;
    }
    final value = _demoValues[controller];
    if (value == null) return;

    _filledFields.add(controller);
    _isTyping = true;

    // Simulated typing - one character at a time.
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (!mounted) return;
      buffer.write(value[i]);
      controller.value = TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.length),
      );
      await Future.delayed(const Duration(milliseconds: 28));
    }

    _isTyping = false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _processing = true);

    // Mock card processing delay
    await Future.delayed(const Duration(milliseconds: 1800));

    final p = widget.product;
    final digits = _cardController.text.replaceAll(' ', '');
    final lastFour =
        digits.length >= 4 ? digits.substring(digits.length - 4) : digits;

    String? savedOrderId;
    String? errorMessage;

    // Save order to Firestore (payment itself is mocked).
    try {
      savedOrderId = await OrderService.placeOrder(
        productId: p.id,
        productName: p.name,
        productRef: p.ref,
        productImage: p.imageUrl,
        collection: p.collection,
        unitPrice: p.price,
        cardHolder: _nameController.text.trim(),
        cardLastFour: lastFour,
        shippingName: _nameController.text.trim(),
        shippingLine1: _addressController.text.trim(),
        shippingCity: _cityController.text.trim(),
        shippingZip: _zipController.text.trim(),
      );
    } catch (e) {
      errorMessage = 'Could not save order: $e';
    }

    if (!mounted) return;
    setState(() => _processing = false);

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(
        product: widget.product,
        orderId: savedOrderId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CHECKOUT',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Product summary 
              Container(
                margin: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: p.isAsset
                            ? Image.asset(
                                p.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) => Container(
                                  color: const Color(0xFFF0EDEA),
                                  child: const Icon(Icons.image_outlined,
                                      color: Color(0xFFCBC2B8)),
                                ),
                              )
                            : Image.network(
                                p.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) => Container(
                                  color: const Color(0xFFF0EDEA),
                                  child: const Icon(Icons.image_outlined,
                                      color: Color(0xFFCBC2B8)),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.collection.toUpperCase().replaceAll('_', ' '),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p.formattedPrice,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //  Payment method 
              _section('PAYMENT METHOD'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _methodChip('Card', Icons.credit_card_outlined),
                    const SizedBox(width: 10),
                    _methodChip('Apple Pay', Icons.apple),
                    const SizedBox(width: 10),
                    _methodChip('PayPal', Icons.account_balance_wallet_outlined),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              //  Card details 
              _section('CARD DETAILS'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _field(
                      controller: _nameController,
                      label: 'Cardholder name',
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 18),
                    _field(
                      controller: _cardController,
                      label: 'Card number',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                        _CardNumberFormatter(),
                      ],
                      validator: (v) {
                        final digits = (v ?? '').replaceAll(' ', '');
                        if (digits.length < 13) return 'Invalid card number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            controller: _expiryController,
                            label: 'MM / YY',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                              _ExpiryFormatter(),
                            ],
                            validator: (v) {
                              if ((v ?? '').length < 5) return 'Invalid';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _field(
                            controller: _cvvController,
                            label: 'CVV',
                            keyboardType: TextInputType.number,
                            obscure: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (v) {
                              if ((v ?? '').length < 3) return 'Invalid';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              //  Billing address 
              _section('BILLING ADDRESS'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _field(
                      controller: _addressController,
                      label: 'Street address',
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _field(
                            controller: _cityController,
                            label: 'City',
                            validator: (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _field(
                            controller: _zipController,
                            label: 'Zip',
                            keyboardType: TextInputType.number,
                            validator: (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //  Order total 
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
                color: const Color(0xFFFAFAFA),
                child: Column(
                  children: [
                    _totalRow('Subtotal', p.formattedPrice),
                    const SizedBox(height: 6),
                    _totalRow('Shipping', 'Complimentary'),
                    const SizedBox(height: 6),
                    _totalRow('Taxes', 'Included'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Color(0xFFE0E0E0)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          p.formattedPrice,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              //  Pay button 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _processing ? null : _pay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.black54,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: _processing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'PAY  ${p.formattedPrice}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.5,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 14),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline,
                          size: 12, color: Colors.black45),
                      SizedBox(width: 6),
                      Text(
                        'Secure checkout - encrypted end-to-end',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  //  Helpers 
  Widget _section(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.5,
            color: Color(0xFF888888),
          ),
        ),
      );

  Widget _methodChip(String label, IconData icon) {
    final active = _method == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _method = label),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.white,
            border: Border.all(
              color: active ? Colors.black : const Color(0xFFDDDDDD),
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16, color: active ? Colors.white : Colors.black),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: active ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscure,
      onTap: () => _demoFill(controller),
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
          color: Color(0xFF888888),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD50032)),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD50032), width: 1.2),
        ),
        errorStyle: const TextStyle(
          fontSize: 10,
          color: Color(0xFFD50032),
        ),
      ),
      validator: validator,
    );
  }

  Widget _totalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

//  Success dialog 

class _SuccessDialog extends StatelessWidget {
  final Product product;
  final String? orderId;
  const _SuccessDialog({required this.product, this.orderId});

  String get _shortRef {
    final id = orderId;
    if (id == null || id.isEmpty) return '';
    final slice = id.substring(0, id.length < 6 ? id.length : 6).toUpperCase();
    return 'CT-$slice';
  }

  @override
  Widget build(BuildContext context) {
    final donation = product.price * 0.03;
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //  Hero panther image 
            SizedBox(
              height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/hj_panther.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFF1A1A1A)),
                  ),
                  // Dark gradient for legibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                  // Confirmed badge
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD50032),
                      ),
                      child: const Text(
                        'PAYMENT CONFIRMED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  // Check icon centered
                  Center(
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFFD50032),
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(26, 28, 26, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Thank you for buying',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Basis',
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 22),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 22),

                  //  Panther donation block 
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PantherScreen(),
                      ),
                    ),
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF6F3EF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 22,
                          color: Color(0xFFD50032),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FOR THE PANTHER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                color: Color(0xFFD50032),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '3% of your purchase goes towards taking care of '
                              'panther animals in the wild, through our partnership '
                              'with Panthera.',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                height: 1.65,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your contribution · \$${donation.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ),

                  if (orderId != null) ...[
                    const SizedBox(height: 22),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black, width: 0.8),
                        ),
                        child: Text(
                          'ORDER ID  $_shortRef',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        // Close dialog → pop payment screen → back to product detail
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
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
                        'CONTINUE SHOPPING',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Card number formatter (XXXX XXXX XXXX XXXX) 

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final result = buf.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

//  Expiry formatter (MM/YY) 

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll('/', '').replaceAll(' ', '');
    String result;
    if (digits.length >= 3) {
      result = '${digits.substring(0, 2)}/${digits.substring(2)}';
    } else {
      result = digits;
    }
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

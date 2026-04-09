import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/order_service.dart';

// 
// Shared scaffold
// 

class _AccountScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _AccountScaffold({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
          ),
        ),
      ),
      body: child,
    );
  }
}

// 
// Orders and Returns
// 

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AccountScaffold(
      title: 'Orders and Returns',
      child: StreamBuilder<List<OrderRecord>>(
        stream: OrderService.watchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Colors.black,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load orders.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            );
          }
          final orders = snapshot.data ?? const <OrderRecord>[];
          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        size: 48, color: Color(0xFF999999)),
                    const SizedBox(height: 16),
                    const Text(
                      'NO ORDERS YET',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your completed orders will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: orders.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 28, color: Color(0xFFEEEEEE)),
            itemBuilder: (context, i) {
              final o = orders[i];
              return _OrderTile(order: o);
            },
          );
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderRecord order;
  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    final delivered = order.status == 'Delivered';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order ${order.shortRef}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
                color: Color(0xFF888888),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(
                  color: delivered
                      ? Colors.black
                      : const Color(0xFFD50032),
                  width: 0.8,
                ),
              ),
              child: Text(
                order.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: delivered
                      ? Colors.black
                      : const Color(0xFFD50032),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          order.productName,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, height: 1.4),
        ),
        const SizedBox(height: 6),
        Text(
          order.formattedDate.isEmpty ? 'Just now' : order.formattedDate,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 10),
        Text(
          '\$${order.unitPrice.toStringAsFixed(0)}',
          style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        if (order.cardLastFour.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Paid with card ending ${order.cardLastFour}',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          children: [
            _linkButton('VIEW DETAILS', () {}),
            const SizedBox(width: 20),
            _linkButton(delivered ? 'RETURN' : 'TRACK', () {}),
          ],
        ),
      ],
    );
  }

  Widget _linkButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

// 
// Details and Security
// 

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();

    String first;
    String last;
    String email;
    String phone;

    if (AuthService.isDemoUser) {
      // Demo session - pre-fill with the showcase identity.
      first = AuthService.demoDisplayName;
      last = 'Perera';
      email = AuthService.demoEmail;
      phone = AuthService.demoPhone;
    } else {
      final user = AuthService.currentUser;
      // Split "First Last" from Firebase displayName if present.
      final fullName = (user?.displayName ?? '').trim();
      final parts =
          fullName.isEmpty ? <String>[] : fullName.split(RegExp(r'\s+'));
      first = parts.isNotEmpty
          ? parts.first
          : AuthService.displayNameOrEmailPrefix();
      last = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      email = user?.email ?? '';
      phone = user?.phoneNumber ?? '';
    }

    _firstName = TextEditingController(text: first);
    _lastName = TextEditingController(text: last);
    _email = TextEditingController(text: email);
    _phone = TextEditingController(text: phone);
  }

  Future<void> _save() async {
    final newName =
        '${_firstName.text.trim()} ${_lastName.text.trim()}'.trim();
    // Only push to Firebase when we're on a real account. In demo mode
    // we just show the snackbar so screenshots look successful.
    if (!AuthService.isDemoUser && newName.isNotEmpty) {
      await AuthService.updateDisplayName(newName);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Details saved'),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AccountScaffold(
      title: 'Details and Security',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: [
          const _SectionLabel('PERSONAL DETAILS'),
          const SizedBox(height: 14),
          _Field(label: 'First name', controller: _firstName),
          const SizedBox(height: 14),
          _Field(label: 'Last name', controller: _lastName),
          const SizedBox(height: 14),
          _Field(label: 'Email', controller: _email),
          const SizedBox(height: 14),
          _Field(label: 'Phone', controller: _phone),
          const SizedBox(height: 30),
          const _SectionLabel('SECURITY'),
          const SizedBox(height: 10),
          _LinkRow(label: 'Change password', onTap: () {}),
          _LinkRow(label: 'Two-factor authentication', onTap: () {}),
          _LinkRow(label: 'Connected devices', onTap: () {}),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
              ),
              child: const Text(
                'SAVE CHANGES',
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
    );
  }
}

// 
// Address Book
// 

class AddressBookScreen extends StatelessWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = [
      _Address(
        label: 'Home',
        name: 'Ravini Wickramasinghe',
        line1: '42 Galle Road',
        line2: 'Colombo 03',
        country: 'Sri Lanka',
        phone: '+94 77 123 4567',
        isDefault: true,
      ),
      _Address(
        label: 'Work',
        name: 'Ravini Wickramasinghe',
        line1: 'NSBM Green University',
        line2: 'Pitipana, Homagama',
        country: 'Sri Lanka',
        phone: '+94 77 123 4567',
        isDefault: false,
      ),
    ];

    return _AccountScaffold(
      title: 'Address Book',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          ...addresses.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _AddressCard(address: a),
              )),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18, color: Colors.black),
              label: const Text(
                'ADD NEW ADDRESS',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Address {
  final String label;
  final String name;
  final String line1;
  final String line2;
  final String country;
  final String phone;
  final bool isDefault;
  const _Address({
    required this.label,
    required this.name,
    required this.line1,
    required this.line2,
    required this.country,
    required this.phone,
    required this.isDefault,
  });
}

class _AddressCard extends StatelessWidget {
  final _Address address;
  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                address.label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              if (address.isDefault) ...[
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Colors.black,
                  child: const Text(
                    'DEFAULT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(address.name,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(address.line1,
              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          Text(address.line2,
              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          Text(address.country,
              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          const SizedBox(height: 6),
          Text(address.phone,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 14),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: const Text(
                  'EDIT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {},
                child: const Text(
                  'REMOVE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    decoration: TextDecoration.underline,
                    color: Color(0xFFD50032),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 
// Small shared widgets
// 

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.5,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _Field({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey[600]),
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 1.2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LinkRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 13, color: Color(0xFF999999)),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}

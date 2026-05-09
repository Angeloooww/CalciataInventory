import 'package:calciatainventory/admin/staff_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'menu_page.dart';
import 'inventory_page.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// SalesPage
// ═══════════════════════════════════════════════════════════════════════════════
class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  int _selectedNavIndex = 3;

  String get _currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@').first ?? 'Manager';
  }

  void _onNavSelect(int i) {
    setState(() => _selectedNavIndex = i);
    switch (i) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const DashboardPage()));
        break;
      case 1:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const MenuPage()));
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const InventoryPage()));
        break;
      case 3:
        break; // Already here
      case 4:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const StaffPage()));
        break;
      case 5:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      backgroundColor: const Color(0xFFF2EDE8),
      body: isWide
          ? Row(children: [
              _SalesSidebar(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
              Expanded(child: _SalesContent(userName: _currentUser)),
            ])
          : Column(children: [
              Expanded(child: _SalesContent(userName: _currentUser)),
              _SalesBottomNav(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
            ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sidebar
// ═══════════════════════════════════════════════════════════════════════════════
class _SalesSidebar extends StatelessWidget {
  const _SalesSidebar({required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _sidebarBg = Color(0xFFF7F3EF);

  static const List<Map<String, dynamic>> _items = [
    {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
    {'icon': Icons.restaurant_menu_rounded, 'label': 'Menu'},
    {'icon': Icons.inventory_2_rounded, 'label': 'Inventory'},
    {'icon': Icons.bar_chart_rounded, 'label': 'Sales'},
    {'icon': Icons.people_rounded, 'label': 'Staff'},
    {'icon': Icons.settings_rounded, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: _sidebarBg,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _brown,
                  child: const Text('B',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BeanStockk',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black87)),
                    Text('Admin Dashboard',
                        style:
                            TextStyle(fontSize: 10, color: Colors.black45)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_items.length, (i) {
            final selected = i == selectedIndex;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? _brown : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(_items[i]['icon'] as IconData,
                        size: 18,
                        color: selected ? Colors.white : Colors.black54),
                    const SizedBox(width: 10),
                    Text(_items[i]['label'] as String,
                        style: TextStyle(
                            fontSize: 13,
                            color: selected ? Colors.white : Colors.black54,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal)),
                  ],
                ),
              ),
            );
          }),

          // Sales section label
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Sales section',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5)),
            ),
          ),

          const Spacer(),
          Container(
            margin: const EdgeInsets.all(12),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50), shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('System Status',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    Text('All systems operational',
                        style:
                            TextStyle(fontSize: 9, color: Colors.black45)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Bottom nav ────────────────────────────────────────────────────────────────
class _SalesBottomNav extends StatelessWidget {
  const _SalesBottomNav(
      {required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onSelect,
      selectedItemColor: const Color(0xFF8B5E3C),
      unselectedItemColor: Colors.black38,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_rounded), label: 'Menu'),
        BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded), label: 'Inventory'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded), label: 'Sales'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded), label: 'Staff'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded), label: 'Settings'),
      ],
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
class _SalesTopBar extends StatelessWidget {
  const _SalesTopBar({required this.userName});
  final String userName;

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0xFFF7F3EF),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Search bar (decorative, matches screenshot)
          Expanded(
            child: Container(
              height: 36,
              constraints: const BoxConstraints(maxWidth: 340),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0D8D0)),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.search, size: 16, color: Colors.black38),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style:
                          TextStyle(fontSize: 12, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Search orders, customers, menu items...',
                        hintStyle: TextStyle(
                            fontSize: 12, color: Colors.black38),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Today date chip
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0D8D0)),
            ),
            child: Row(
              children: [
                const Text('Today',
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down,
                    size: 14, color: Colors.black38),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Notification bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined,
                  size: 22, color: Colors.black54),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                      color: Color(0xFFE53935), shape: BoxShape.circle),
                  child: const Center(
                      child: Text('0',
                          style: TextStyle(
                              color: Colors.white, fontSize: 8))),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // User
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'signout') _signOut(context);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: 'signout',
                  child: Row(children: [
                    Icon(Icons.logout, size: 16),
                    SizedBox(width: 8),
                    Text('Sign out'),
                  ])),
            ],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: const Color(0xFF8B5E3C),
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const Text('Manager',
                        style:
                            TextStyle(fontSize: 10, color: Colors.black38)),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down,
                    size: 16, color: Colors.black38),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sales Content
// ═══════════════════════════════════════════════════════════════════════════════
class _SalesContent extends StatelessWidget {
  const _SalesContent({required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SalesTopBar(userName: userName),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daily Sales Records',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 20),

                // ── Stat cards ────────────────────────────────────────
                _SalesStatCards(),
                const SizedBox(height: 20),

                // ── Two column layout: Form + History ─────────────────
                LayoutBuilder(builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _RecordSalesForm()),
                        const SizedBox(width: 16),
                        Expanded(child: _SalesHistoryList()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _RecordSalesForm(),
                      const SizedBox(height: 16),
                      _SalesHistoryList(),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Stat cards — computed from Firestore
// ═══════════════════════════════════════════════════════════════════════════════
class _SalesStatCards extends StatelessWidget {
  const _SalesStatCards();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('daily_sales')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        // Total all-time
        double totalAllTime = 0;
        for (final d in docs) {
          final data = d.data() as Map<String, dynamic>;
          totalAllTime += (data['amount'] as num? ?? 0).toDouble();
        }

        // Average daily
        final avgDaily =
            docs.isEmpty ? 0.0 : totalAllTime / docs.length;

        // Week-over-week
        final now = DateTime.now();
        final thisWeekStart =
            now.subtract(Duration(days: now.weekday - 1));
        final lastWeekStart =
            thisWeekStart.subtract(const Duration(days: 7));

        double thisWeekTotal = 0;
        double lastWeekTotal = 0;
        for (final d in docs) {
          final data = d.data() as Map<String, dynamic>;
          final ts = data['date'];
          if (ts == null) continue;
          DateTime date;
          if (ts is Timestamp) {
            date = ts.toDate();
          } else {
            continue;
          }
          final amount = (data['amount'] as num? ?? 0).toDouble();
          if (!date.isBefore(thisWeekStart)) {
            thisWeekTotal += amount;
          } else if (!date.isBefore(lastWeekStart) &&
              date.isBefore(thisWeekStart)) {
            lastWeekTotal += amount;
          }
        }

        double wowPercent = 0;
        if (lastWeekTotal > 0) {
          wowPercent =
              ((thisWeekTotal - lastWeekTotal) / lastWeekTotal) * 100;
        }

        final isPositive = wowPercent >= 0;

        return LayoutBuilder(builder: (context, constraints) {
          final cols = constraints.maxWidth > 500 ? 3 : 1;
          return GridView.count(
            crossAxisCount: cols,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: cols == 3 ? 2.2 : 3.5,
            children: [
              _StatCard(
                icon: Icons.attach_money,
                label: 'Total Sales (All Time)',
                value:
                    '₱${totalAllTime.toStringAsFixed(2)}',
                sub:
                    '${docs.length} entr${docs.length == 1 ? 'y' : 'ies'} recorded',
                valueColor: Colors.black87,
              ),
              _StatCard(
                icon: Icons.trending_up,
                label: 'Average Daily Sales',
                value: '₱${avgDaily.toStringAsFixed(2)}',
                sub: 'Based on all entries',
                valueColor: Colors.black87,
              ),
              _StatCard(
                icon: Icons.show_chart,
                label: 'Week-over-Week',
                value:
                    '${isPositive ? '+' : ''}${wowPercent.toStringAsFixed(1)}%',
                sub:
                    'Last 7 days, ₱${thisWeekTotal.toStringAsFixed(2)}',
                valueColor: isPositive
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFE53935),
              ),
            ],
          );
        });
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.black38),
              const SizedBox(width: 6),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black45),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: valueColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(sub,
              style: const TextStyle(
                  fontSize: 11, color: Colors.black38)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Record Daily Sales Form
// ═══════════════════════════════════════════════════════════════════════════════
class _RecordSalesForm extends StatefulWidget {
  const _RecordSalesForm();

  @override
  State<_RecordSalesForm> createState() => _RecordSalesFormState();
}

class _RecordSalesFormState extends State<_RecordSalesForm> {
  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _borderGray = Color(0xFFD9D9D9);

  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime? _selectedDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF8B5E3C),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('daily_sales').add({
        'date': Timestamp.fromDate(_selectedDate!),
        'amount': double.tryParse(_amountCtrl.text.trim()) ?? 0.0,
        'notes': _notesCtrl.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
        'created_by': FirebaseAuth.instance.currentUser?.email ?? '',
      });

      // Reset form
      setState(() {
        _selectedDate = null;
        _isSaving = false;
      });
      _amountCtrl.clear();
      _notesCtrl.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(children: [
              Icon(Icons.check_circle, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('Sales record saved successfully'),
            ]),
            backgroundColor: Color(0xFF4CAF50),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Row(
              children: [
                Icon(Icons.add, size: 16, color: Colors.black54),
                SizedBox(width: 6),
                Text('Record Daily Sales',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 20),

            // Date picker
            _label('Date'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _borderGray),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: Colors.black38),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDate != null
                          ? _formatDate(_selectedDate!)
                          : '',
                      style: TextStyle(
                          fontSize: 13,
                          color: _selectedDate != null
                              ? Colors.black87
                              : Colors.black38),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sales amount
            _label('Sales Amount (₱)'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              style: const TextStyle(
                  fontSize: 13, color: Colors.black87),
              decoration: _inputDec('₱  0.00'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Amount is required';
                }
                if (double.tryParse(v.trim()) == null) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Notes
            _label('Notes (Optional)'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              style: const TextStyle(
                  fontSize: 13, color: Colors.black87),
              decoration: _inputDec('e.g., Busy weekend, slow day...'),
            ),
            const SizedBox(height: 20),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brown,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Save Record',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black87));

  InputDecoration _inputDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(fontSize: 13, color: Colors.black38),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _borderGray)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _borderGray)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: _brown, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade300)),
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sales History List
// ═══════════════════════════════════════════════════════════════════════════════
class _SalesHistoryList extends StatelessWidget {
  const _SalesHistoryList();

  String _formatDate(DateTime d) {
    const days = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = days[d.weekday - 1];
    return '$day, ${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  Future<void> _deleteRecord(
      BuildContext context, String docId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Record',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: const Text(
            'Are you sure you want to delete this sales record? This cannot be undone.',
            style: TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection('daily_sales')
          .doc(docId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sales History',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('daily_sales')
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (context, snap) {
              if (snap.hasError) {
                return Text('Error: ${snap.error}',
                    style: const TextStyle(
                        color: Colors.red, fontSize: 13));
              }
              if (snap.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ));
              }

              final docs = snap.data?.docs ?? [];

              if (docs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 48,
                            color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No sales records yet.\nUse the form to add your first entry.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1, color: Color(0xFFF0EBE5)),
                itemBuilder: (context, i) {
                  final data =
                      docs[i].data() as Map<String, dynamic>;
                  final ts = data['date'];
                  DateTime? date;
                  if (ts is Timestamp) date = ts.toDate();
                  final amount =
                      (data['amount'] as num? ?? 0).toDouble();
                  final notes =
                      data['notes'] as String? ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Date icon
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Colors.black38),
                        ),
                        const SizedBox(width: 8),
                        // Date + notes
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                date != null
                                    ? _formatDate(date)
                                    : '—',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87),
                              ),
                              if (notes.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(
                                          top: 2),
                                  child: Text(notes,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black38),
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis),
                                ),
                            ],
                          ),
                        ),
                        // Amount
                        Text(
                          '₱${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(width: 8),
                        // Delete button
                        GestureDetector(
                          onTap: () =>
                              _deleteRecord(context, docs[i].id),
                          child: const Icon(
                              Icons.delete_outline,
                              size: 15,
                              color: Colors.black26),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
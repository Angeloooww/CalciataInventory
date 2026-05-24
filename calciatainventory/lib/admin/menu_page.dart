import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'inventory_page.dart';
import 'sales_page.dart';
import 'staff_page.dart';
// ═══════════════════════════════════════════════════════════════════════════════
// MenuPage
// ═══════════════════════════════════════════════════════════════════════════════
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedNavIndex = 1; // Menu is index 1

  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _sidebarBg = Color(0xFFF7F3EF);

  String get _currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@').first ?? 'Manager';
  }

  void _onNavSelect(int i) {
    setState(() => _selectedNavIndex = i);
    switch (i) {
      case 0: // Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
        break;
      case 1: // Menu — already here
        break;
      case 2: // Inventory — uncomment when ready
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const InventoryPage()));
        break;
      case 3: // Sales — uncomment when ready
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SalesPage()));
        break;
      case 4: // Staff — uncomment when ready
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StaffPage()));
        break;
      case 5: // Settings — uncomment when ready
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
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
              _Sidebar(
                selectedIndex: _selectedNavIndex,
                onSelect: _onNavSelect,
              ),
              Expanded(child: _MenuContent(userName: _currentUser)),
            ])
          : Column(children: [
              Expanded(child: _MenuContent(userName: _currentUser)),
              _BottomNav(
                selectedIndex: _selectedNavIndex,
                onSelect: _onNavSelect,
              ),
            ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sidebar (identical to dashboard)
// ═══════════════════════════════════════════════════════════════════════════════
class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _sidebarBg = Color(0xFFF7F3EF);

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.restaurant_menu_rounded, label: 'Menu'),
    _NavItem(icon: Icons.inventory_2_rounded, label: 'Inventory'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Sales'),
    _NavItem(icon: Icons.people_rounded, label: 'Staff'),
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
                        style: TextStyle(fontSize: 10, color: Colors.black45)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_items.length, (i) {
            final selected = i == selectedIndex;
            return _SidebarTile(
              item: _items[i],
              selected: selected,
              onTap: () => onSelect(i),
            );
          }),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
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
                        style: TextStyle(fontSize: 9, color: Colors.black45)),
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

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile(
      {required this.item, required this.selected, required this.onTap});
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF8B5E3C);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? brown : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(item.icon,
                size: 18, color: selected ? Colors.white : Colors.black54),
            const SizedBox(width: 10),
            Text(item.label,
                style: TextStyle(
                    fontSize: 13,
                    color: selected ? Colors.white : Colors.black54,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

// ── Bottom nav (mobile) ───────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = [
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
    ];
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onSelect,
      selectedItemColor: const Color(0xFF8B5E3C),
      unselectedItemColor: Colors.black38,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: items,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Top Bar
// ═══════════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  const _TopBar({required this.userName});
  final String userName;

  Future<void> _signOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.logout, size: 20, color: Color(0xFF8B5E3C)),
            SizedBox(width: 8),
            Text('Sign Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black45, fontSize: 13)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5E3C),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Sign Out', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0xFFF7F3EF),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Spacer(),
          const SizedBox(width: 16),
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
// Menu Content — Firestore-driven
// ═══════════════════════════════════════════════════════════════════════════════
class _MenuContent extends StatefulWidget {
  const _MenuContent({required this.userName});
  final String userName;

  @override
  State<_MenuContent> createState() => _MenuContentState();
}

class _MenuContentState extends State<_MenuContent> {
  static const Color _brown = Color(0xFF8B5E3C);

  // Categories: 'All Drinks', 'Espresso', 'Non-Coffee'
  // Stored in Firestore field: category
  String _selectedCategory = 'All Drinks';

  static const List<String> _categories = [
    'All Drinks',
    'Espresso-Based',
    'Non-Coffee',
    'Frappe',
    'Tea',
  ];

  static const Map<String, IconData> _catIcons = {
    'All Drinks': Icons.local_cafe_outlined,
    'Espresso-Based': Icons.coffee_outlined,
    'Non-Coffee': Icons.emoji_food_beverage_outlined,
    'Frappe': Icons.local_drink_outlined,
    'Tea': Icons.emoji_food_beverage_outlined,
  };

  // ── Firestore reference ───────────────────────────────────────────────────
  CollectionReference get _menuRef =>
      FirebaseFirestore.instance.collection('menu_items');

  // ── Delete item ───────────────────────────────────────────────────────────
  Future<void> _deleteItem(String docId) async {
    await _menuRef.doc(docId).delete();
  }

  // ── Open add/edit dialog ──────────────────────────────────────────────────
  void _openDrinkDialog({DocumentSnapshot? doc}) {
    showDialog(
      context: context,
      builder: (_) => _DrinkDialog(doc: doc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBar(userName: widget.userName),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row ────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Menu Items',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        SizedBox(height: 2),
                        Text('Manage drinks and pricing.',
                            style: TextStyle(
                                fontSize: 12, color: Colors.black45)),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openDrinkDialog(),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add New Drink',
                          style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Category tabs with live count ─────────────────────────
                StreamBuilder<QuerySnapshot>(
                  stream: _menuRef.snapshots(),
                  builder: (context, snap) {
                    final docs = snap.data?.docs ?? [];

                    Map<String, int> counts = {'All Drinks': docs.length};
                    for (final d in docs) {
                      final cat =
                          (d.data() as Map<String, dynamic>)['category']
                                  as String? ??
                              'Other';
                      counts[cat] = (counts[cat] ?? 0) + 1;
                    }

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        spacing: 8,
                        children: _categories.map((cat) {
                          final selected = _selectedCategory == cat;
                          final count = counts[cat] ?? 0;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedCategory = cat),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: selected
                                    ? _brown.withOpacity(0.12)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: selected
                                      ? _brown
                                      : Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _catIcons[cat] ??
                                        Icons.local_cafe_outlined,
                                    size: 14,
                                    color: selected
                                        ? _brown
                                        : Colors.black45,
                                  ),
                                  const SizedBox(width: 5),
                                  Text('$cat ($count)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: selected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: selected
                                              ? _brown
                                              : Colors.black54)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // ── Drink grid ────────────────────────────────────────────
                StreamBuilder<QuerySnapshot>(
                  stream: _selectedCategory == 'All Drinks'
                      ? _menuRef.snapshots()
                      : _menuRef
                          .where('category', isEqualTo: _selectedCategory)
                          .snapshots(),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Error loading drinks: ${snap.error}',
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      );
                    }
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ));
                    }

                    final docs = List<QueryDocumentSnapshot>.from(snap.data?.docs ?? [])
                      ..sort((a, b) {
                        final aName = ((a.data() as Map<String, dynamic>)['name'] as String? ?? '').toLowerCase();
                        final bName = ((b.data() as Map<String, dynamic>)['name'] as String? ?? '').toLowerCase();
                        return aName.compareTo(bName);
                      });

                    if (docs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.coffee_outlined,
                                  size: 48,
                                  color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text(
                                'No drinks yet. Tap "Add New Drink" to get started.',
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFD4A96A), width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedCategory,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 14),
                          LayoutBuilder(builder: (context, constraints) {
                            final cols =
                                constraints.maxWidth > 500 ? 3 : 2;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.1,
                              ),
                              itemCount: docs.length,
                              itemBuilder: (context, i) {
                                return _DrinkCard(
                                  doc: docs[i],
                                  onEdit: () =>
                                      _openDrinkDialog(doc: docs[i]),
                                  onDelete: () =>
                                      _deleteItem(docs[i].id),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Drink Card
// ═══════════════════════════════════════════════════════════════════════════════
class _DrinkCard extends StatelessWidget {
  const _DrinkCard({
    required this.doc,
    required this.onEdit,
    required this.onDelete,
  });

  final DocumentSnapshot doc;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final name = data['name'] as String? ?? '';
    final description = data['description'] as String? ?? '';
    final hotPrice8oz = data['hot_price_8oz'];
    final hotPrice16oz = data['hot_price_16oz'];
    final icedPrice8oz = data['iced_price_8oz'];
    final icedPrice16oz = data['iced_price_16oz'];
    final note = data['note'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDE8E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon + edit button ──────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.coffee_outlined,
                  size: 18, color: Colors.black45),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                },
                icon: const Icon(Icons.edit_note_outlined,
                    size: 18, color: Colors.black38),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit_outlined, size: 15),
                        SizedBox(width: 8),
                        Text('Edit', style: TextStyle(fontSize: 13)),
                      ])),
                  const PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_outline,
                            size: 15, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete',
                            style: TextStyle(
                                fontSize: 13, color: Colors.red)),
                      ])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),

          // ── Name & description ──────────────────────────────────────────
          Text(name,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(description,
              style: const TextStyle(fontSize: 10, color: Colors.black45),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),

          // ── Prices ─────────────────────────────────────────────────────
          if (hotPrice8oz != null)
            _PriceRow(
                icon: Icons.local_fire_department_outlined,
                label: '8oz Hot',
                price: hotPrice8oz),
          if (hotPrice16oz != null)
            _PriceRow(
                icon: Icons.local_fire_department_outlined,
                label: '16oz Iced',
                price: hotPrice16oz),
          if (icedPrice8oz != null)
            _PriceRow(
                icon: Icons.ac_unit_outlined,
                label: '8oz Hot',
                price: icedPrice8oz),
          if (icedPrice16oz != null)
            _PriceRow(
                icon: Icons.ac_unit_outlined,
                label: '16oz Iced',
                price: icedPrice16oz),

          // ── Note ───────────────────────────────────────────────────────
          if (note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('+ $note',
                style: const TextStyle(
                    fontSize: 9,
                    color: Colors.black38,
                    fontStyle: FontStyle.italic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow(
      {required this.icon, required this.label, required this.price});
  final IconData icon;
  final String label;
  final dynamic price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 10, color: const Color(0xFF8B5E3C)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(label,
                style:
                    const TextStyle(fontSize: 10, color: Colors.black54)),
          ),
          Text('₱$price',
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Add / Edit Drink Dialog
// ═══════════════════════════════════════════════════════════════════════════════
class _DrinkDialog extends StatefulWidget {
  const _DrinkDialog({this.doc});
  final DocumentSnapshot? doc;

  @override
  State<_DrinkDialog> createState() => _DrinkDialogState();
}

class _DrinkDialogState extends State<_DrinkDialog> {
  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _borderGray = Color(0xFFD9D9D9);

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _hot8Ctrl = TextEditingController();
  final _iced16Ctrl = TextEditingController();

  String _category = 'Espresso-Based';
  bool _hot8Enabled = true;
  bool _iced16Enabled = true;
  bool _isSaving = false;

  bool get _isEditing => widget.doc != null;

  static const List<String> _categories = [
    'Espresso-Based',
    'Non-Coffee',
    'Frappe',
    'Tea',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final data = widget.doc!.data() as Map<String, dynamic>;
      _nameCtrl.text = data['name'] ?? '';
      _descCtrl.text = data['description'] ?? '';
      _hot8Ctrl.text = data['hot_price_8oz']?.toString() ?? '';
      _iced16Ctrl.text = data['iced_price_16oz']?.toString() ?? '';
      _category = data['category'] ?? 'Espresso-Based';
      _hot8Enabled = data['hot_price_8oz'] != null;
      _iced16Enabled = data['iced_price_16oz'] != null;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _hot8Ctrl.dispose();
    _iced16Ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final payload = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'category': _category,
      'hot_price_8oz':
          _hot8Enabled && _hot8Ctrl.text.isNotEmpty ? num.tryParse(_hot8Ctrl.text) : null,
      'iced_price_16oz':
          _iced16Enabled && _iced16Ctrl.text.isNotEmpty ? num.tryParse(_iced16Ctrl.text) : null,
      'updated_at': FieldValue.serverTimestamp(),
    };

    final ref = FirebaseFirestore.instance.collection('menu_items');
    if (_isEditing) {
      await ref.doc(widget.doc!.id).update(payload);
    } else {
      payload['created_at'] = FieldValue.serverTimestamp();
      await ref.add(payload);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Dialog title bar ────────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing ? 'Edit Drink' : 'Add New Drink',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        if (_isEditing && _nameCtrl.text.isNotEmpty)
                          Text(
                            _nameCtrl.text,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8B5E3C),
                                fontWeight: FontWeight.w500),
                          ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18, color: Colors.black45),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // ── Form body ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Drink Name ──────────────────────────────────────
                      _label('Drink Name *'),
                      const SizedBox(height: 6),
                      _field(
                        _nameCtrl,
                        'e.g. Salted Caramel Latte',
                        validator: (v) =>
                            v!.trim().isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 16),

                      // ── Description ─────────────────────────────────────
                      _label('Description (3-5 words) *'),
                      const SizedBox(height: 6),
                      _field(
                        _descCtrl,
                        'e.g. Sweet salty caramel',
                        validator: (v) =>
                            v!.trim().isEmpty ? 'Description is required' : null,
                      ),
                      const SizedBox(height: 16),

                      // ── Category ────────────────────────────────────────
                      _label('Category *'),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _category,
                        decoration: _inputDec(''),
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87),
                        items: _categories
                            .map((c) => DropdownMenuItem(
                                value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setState(() => _category = v!),
                      ),
                      const SizedBox(height: 20),

                      // ── Sizes & Pricing label ───────────────────────────
                      const Text('Sizes & Pricing',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      const SizedBox(height: 10),

                      // ── 8oz Hot row ─────────────────────────────────────
                      _SizePriceRow(
                        label: '8oz Hot',
                        enabled: _hot8Enabled,
                        controller: _hot8Ctrl,
                        onToggle: (v) => setState(() => _hot8Enabled = v),
                      ),
                      const SizedBox(height: 8),

                      // ── 16oz Iced row ───────────────────────────────────
                      _SizePriceRow(
                        label: '16oz Iced',
                        enabled: _iced16Enabled,
                        controller: _iced16Ctrl,
                        onToggle: (v) => setState(() => _iced16Enabled = v),
                      ),
                      const SizedBox(height: 24),

                      // ── Buttons ─────────────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton.icon(
                                onPressed: _isSaving ? null : _save,
                                icon: _isSaving
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white))
                                    : const Icon(Icons.add, size: 16),
                                label: Text(
                                  _isEditing ? 'Save Changes' : 'Add to Menu',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _brown,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black54,
                                side: const BorderSide(color: _borderGray),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Cancel',
                                  style: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87),
      );

  InputDecoration _inputDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
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
            borderSide: const BorderSide(color: _brown, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade300)),
      );

  Widget _field(
    TextEditingController ctrl,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        decoration: _inputDec(hint),
        validator: validator,
      );
}

// ── Size + price toggle row ───────────────────────────────────────────────────
class _SizePriceRow extends StatelessWidget {
  const _SizePriceRow({
    required this.label,
    required this.enabled,
    required this.controller,
    required this.onToggle,
  });

  final String label;
  final bool enabled;
  final TextEditingController controller;
  final ValueChanged<bool> onToggle;

  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _borderGray = Color(0xFFD9D9D9);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borderGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Toggle switch
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: _brown,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 10),
          // Label
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13,
                  color: enabled ? Colors.black87 : Colors.black38,
                  fontWeight: FontWeight.w500),
            ),
          ),
          // ₱ prefix + price field
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('₱ ',
                  style: TextStyle(
                      fontSize: 13,
                      color: enabled ? Colors.black54 : Colors.black26,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: controller,
                  enabled: enabled,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 13,
                      color: enabled ? Colors.black87 : Colors.black26,
                      fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.black26),
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
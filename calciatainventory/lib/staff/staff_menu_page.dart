import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_inventory_page.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// StaffMenuPage
// ═══════════════════════════════════════════════════════════════════════════════
class StaffMenuPage extends StatefulWidget {
  const StaffMenuPage({super.key});

  @override
  State<StaffMenuPage> createState() => _StaffMenuPageState();
}

class _StaffMenuPageState extends State<StaffMenuPage> {
  int _selectedNavIndex = 0; // 0 = Menu, 1 = Inventory

  String get _currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@').first ?? 'Staff';
  }

  void _onNavSelect(int i) {
    if (i == _selectedNavIndex) return;
    setState(() => _selectedNavIndex = i);
    if (i == 1) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const StaffInventoryPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      backgroundColor: const Color(0xFFF2EDE8),
      body: isWide
          ? Row(children: [
              _StaffMenuSidebar(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
              Expanded(child: _StaffMenuContent(userName: _currentUser)),
            ])
          : Column(children: [
              Expanded(child: _StaffMenuContent(userName: _currentUser)),
              _StaffMenuBottomNav(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
            ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sidebar
// ═══════════════════════════════════════════════════════════════════════════════
class _StaffMenuSidebar extends StatelessWidget {
  const _StaffMenuSidebar(
      {required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _sidebarBg = Color(0xFFF7F3EF);

  static const List<Map<String, dynamic>> _items = [
    {'icon': Icons.restaurant_menu_rounded, 'label': 'Menu'},
    {'icon': Icons.inventory_2_rounded, 'label': 'Inventory'},
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
                    Text('Staff Panel',
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
                            color:
                                selected ? Colors.white : Colors.black54,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal)),
                  ],
                ),
              ),
            );
          }),
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
class _StaffMenuBottomNav extends StatelessWidget {
  const _StaffMenuBottomNav(
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
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_rounded), label: 'Menu'),
        BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded), label: 'Inventory'),
      ],
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
class _StaffMenuTopBar extends StatelessWidget {
  const _StaffMenuTopBar({required this.userName});
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
          const Spacer(),
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
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
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
                    const Text('Staff',
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
// Menu Content — read-only, no add/edit/delete
// ═══════════════════════════════════════════════════════════════════════════════
class _StaffMenuContent extends StatefulWidget {
  const _StaffMenuContent({required this.userName});
  final String userName;

  @override
  State<_StaffMenuContent> createState() => _StaffMenuContentState();
}

class _StaffMenuContentState extends State<_StaffMenuContent> {
  static const Color _brown = Color(0xFF8B5E3C);

  String _selectedCategory = 'All Drinks';
  String _search = '';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    'All Drinks',
    'Espresso-Based',
    'Non-Coffee',
    'Frappe',
    'Tea',
  ];

  CollectionReference get _menuRef =>
      FirebaseFirestore.instance.collection('menu_items');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StaffMenuTopBar(userName: widget.userName),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Menu Items',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    SizedBox(height: 2),
                    Text('View drinks and pricing.',
                        style:
                            TextStyle(fontSize: 12, color: Colors.black45)),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Search bar ───────────────────────────────────────────
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.search,
                          size: 16, color: Colors.black38),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _search = v),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: 'Search drinks...',
                            hintStyle: TextStyle(
                                fontSize: 13, color: Colors.black38),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_search.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() {
                            _search = '';
                            _searchController.clear();
                          }),
                          child: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.close,
                                size: 15, color: Colors.black38),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Category tabs with live count ────────────────────────
                StreamBuilder<QuerySnapshot>(
                  stream: _menuRef.snapshots(),
                  builder: (context, snap) {
                    final docs = snap.data?.docs ?? [];

                    Map<String, int> counts = {
                      'All Drinks': docs.length
                    };
                    for (final d in docs) {
                      final cat =
                          (d.data() as Map<String, dynamic>)['category']
                                  as String? ??
                              'Other';
                      counts[cat] = (counts[cat] ?? 0) + 1;
                    }

                    // Apply category + search filter
                    final filtered = docs.where((d) {
                      final data = d.data() as Map<String, dynamic>;
                      final cat = data['category'] as String? ?? '';
                      final name =
                          (data['name'] as String? ?? '').toLowerCase();
                      final matchesCat = _selectedCategory == 'All Drinks' ||
                          cat == _selectedCategory;
                      final matchesSearch = _search.isEmpty ||
                          name.contains(_search.toLowerCase());
                      return matchesCat && matchesSearch;
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category tabs
                        Container(
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
                                onTap: () => setState(
                                    () => _selectedCategory = cat),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 180),
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
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(cat,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: selected
                                                  ? _brown
                                                  : Colors.black54,
                                              fontWeight: selected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal)),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? _brown.withOpacity(0.15)
                                              : Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text('$count',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: selected
                                                    ? _brown
                                                    : Colors.black38,
                                                fontWeight:
                                                    FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Drink cards ─────────────────────────────────
                        if (filtered.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    _search.isNotEmpty
                                        ? Icons.search_off_rounded
                                        : Icons.local_cafe_outlined,
                                    size: 48,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _search.isNotEmpty
                                        ? 'No drinks found for "$_search".'
                                        : docs.isEmpty
                                            ? 'No menu items yet.'
                                            : 'No items in "$_selectedCategory".',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          LayoutBuilder(builder: (context, constraints) {
                            final crossCount =
                                constraints.maxWidth > 800 ? 3 : 2;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.1,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (_, i) {
                                final doc = filtered[i];
                                final data = doc.data()
                                    as Map<String, dynamic>;
                                return _StaffDrinkCard(data: data);
                              },
                            );
                          }),
                      ],
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

// ── Read-only drink card ──────────────────────────────────────────────────────
class _StaffDrinkCard extends StatelessWidget {
  const _StaffDrinkCard({required this.data});
  final Map<String, dynamic> data;

  static const Color _brown = Color(0xFF8B5E3C);

  @override
  Widget build(BuildContext context) {
    final name = data['name'] as String? ?? '';
    final category = data['category'] as String? ?? '';
    final description = data['description'] as String? ?? '';
    final note = data['note'] as String? ?? '';

    // Actual Firestore price fields set by admin
    final hotPrice8oz = data['hot_price_8oz'];
    final hotPrice16oz = data['hot_price_16oz'];
    final icedPrice8oz = data['iced_price_8oz'];
    final icedPrice16oz = data['iced_price_16oz'];

    final hasAnyPrice = hotPrice8oz != null ||
        hotPrice16oz != null ||
        icedPrice8oz != null ||
        icedPrice16oz != null;

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
          // ── Coffee icon + category badge ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.coffee_outlined,
                  size: 18, color: Colors.black45),
              if (category.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _brown.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(category,
                      style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: _brown)),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // ── Name ─────────────────────────────────────────────────────
          Text(name,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),

          // ── Description ───────────────────────────────────────────────
          if (description.isNotEmpty)
            Text(description,
                style: const TextStyle(fontSize: 10, color: Colors.black45),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),

          const SizedBox(height: 8),

          // ── Prices ────────────────────────────────────────────────────
          if (hasAnyPrice) ...[
            if (hotPrice8oz != null)
              _StaffPriceRow(
                  icon: Icons.local_fire_department_outlined,
                  label: '8oz Hot',
                  price: hotPrice8oz),
            if (hotPrice16oz != null)
              _StaffPriceRow(
                  icon: Icons.local_fire_department_outlined,
                  label: '16oz Hot',
                  price: hotPrice16oz),
            if (icedPrice8oz != null)
              _StaffPriceRow(
                  icon: Icons.ac_unit_outlined,
                  label: '8oz Iced',
                  price: icedPrice8oz),
            if (icedPrice16oz != null)
              _StaffPriceRow(
                  icon: Icons.ac_unit_outlined,
                  label: '16oz Iced',
                  price: icedPrice16oz),
          ] else
            const Text('No price set',
                style: TextStyle(fontSize: 10, color: Colors.black38)),

          // ── Note ─────────────────────────────────────────────────────
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

// ── Price row ─────────────────────────────────────────────────────────────────
class _StaffPriceRow extends StatelessWidget {
  const _StaffPriceRow(
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
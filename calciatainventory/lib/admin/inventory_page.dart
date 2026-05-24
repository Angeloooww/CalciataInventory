import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'menu_page.dart';
import 'sales_page.dart';
import 'staff_page.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// InventoryPage
// ═══════════════════════════════════════════════════════════════════════════════
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  int _selectedNavIndex = 2;

  String get _currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@').first ?? 'Manager';
  }

  void _onNavSelect(int i) {
    setState(() => _selectedNavIndex = i);
    switch (i) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const DashboardPage()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MenuPage()));
        break;
      case 2:
        break; // Already here
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SalesPage()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StaffPage()));
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
              _InvSidebar(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
              Expanded(child: _InventoryContent(userName: _currentUser)),
            ])
          : Column(children: [
              Expanded(child: _InventoryContent(userName: _currentUser)),
              _InvBottomNav(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
            ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sidebar
// ═══════════════════════════════════════════════════════════════════════════════
class _InvSidebar extends StatelessWidget {
  const _InvSidebar({required this.selectedIndex, required this.onSelect});
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
class _InvBottomNav extends StatelessWidget {
  const _InvBottomNav({required this.selectedIndex, required this.onSelect});
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

// ── Top bar ───────────────────────────────────────────────────────────────────
class _InvTopBar extends StatelessWidget {
  const _InvTopBar({required this.userName});
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
                        style: TextStyle(
                            fontSize: 10, color: Colors.black38)),
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
// Inventory Content
// ═══════════════════════════════════════════════════════════════════════════════
class _InventoryContent extends StatefulWidget {
  const _InventoryContent({required this.userName});
  final String userName;

  @override
  State<_InventoryContent> createState() => _InventoryContentState();
}

class _InventoryContentState extends State<_InventoryContent> {
  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _red = Color(0xFFE53935);
  static const Color _orange = Color(0xFFF57C00);
  static const Color _green = Color(0xFF4CAF50);

  String _filter = 'All Items';
  String _search = '';
  bool _hasUnsavedChanges = false;
  final TextEditingController _searchController = TextEditingController();

  // Local quantity changes before saving
  final Map<String, int> _pendingChanges = {};

  CollectionReference get _inventoryRef =>
      FirebaseFirestore.instance.collection('inventory_items');

  // ── Status helpers ────────────────────────────────────────────────────────
  String _statusOf(Map<String, dynamic> data) {
    final qty = (data['quantity'] as num? ?? 0).toInt();
    final criticalAt = (data['critical_at'] as num? ?? 3).toInt();
    final lowAt = (data['low_at'] as num? ?? 6).toInt();
    if (qty <= criticalAt) return 'Critical';
    if (qty <= lowAt) return 'Low Stock';
    return 'OK';
  }

  Color _statusColor(String status) {
    if (status == 'Critical') return _red;
    if (status == 'Low Stock') return _orange;
    return _green;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Save all pending changes to Firestore ─────────────────────────────────
  Future<void> _saveChanges() async {
    final batch = FirebaseFirestore.instance.batch();
    _pendingChanges.forEach((docId, qty) {
      batch.update(_inventoryRef.doc(docId), {
        'quantity': qty,
        'updated_at': FieldValue.serverTimestamp(),
      });
    });
    await batch.commit();
    setState(() {
      _pendingChanges.clear();
      _hasUnsavedChanges = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(children: [
            Icon(Icons.check_circle, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Stock updated successfully'),
          ]),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // ── Open add/edit dialog ──────────────────────────────────────────────────
  void _openDialog({DocumentSnapshot? doc}) {
    showDialog(
      context: context,
      builder: (_) => _IngredientDialog(doc: doc),
    ).then((_) => setState(() {}));
  }

  // ── Delete item ───────────────────────────────────────────────────────────
  Future<void> _deleteItem(String docId) async {
    await _inventoryRef.doc(docId).delete();
    _pendingChanges.remove(docId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InvTopBar(userName: widget.userName),

        // ── Search + buttons row (OUTSIDE StreamBuilder so focus is kept) ──
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.search, size: 16, color: Colors.black38),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _search = v),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: 'Search ingredients or categories...',
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
                          onTap: () {
                            setState(() {
                              _search = '';
                              _searchController.clear();
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.close,
                                size: 15, color: Colors.black38),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => _openDialog(),
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('Add Ingredient',
                    style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _brown,
                  side: const BorderSide(color: Color(0xFF8B5E3C)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _hasUnsavedChanges ? _saveChanges : null,
                icon: const Icon(Icons.sync, size: 16),
                label: const Text('Update Stocks',
                    style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _green.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _inventoryRef.snapshots(),
            builder: (context, snap) {
              if (snap.hasError) {
                return Center(
                    child: Text('Error: ${snap.error}',
                        style: const TextStyle(color: Colors.red)));
              }
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allDocs = snap.data?.docs ?? [];

              // ── Helpers ────────────────────────────────────────────────
              int effectiveQty(QueryDocumentSnapshot d) {
                final data = d.data() as Map<String, dynamic>;
                return (_pendingChanges[d.id] ??
                        (data['quantity'] as num? ?? 0))
                    .toInt();
              }

              bool matchesSearch(QueryDocumentSnapshot d) {
                if (_search.isEmpty) return true;
                final data = d.data() as Map<String, dynamic>;
                final q = _search.toLowerCase();
                final name = (data['name'] as String? ?? '').toLowerCase();
                final cat = (data['category'] as String? ?? '').toLowerCase();
                final unit = (data['unit'] as String? ?? '').toLowerCase();
                return name.contains(q) || cat.contains(q) || unit.contains(q);
              }

              // ── Tab counts (always from full allDocs) ──────────────────
              final criticalDocsAll = allDocs.where((d) {
                final data = d.data() as Map<String, dynamic>;
                final criticalAt = (data['critical_at'] as num? ?? 3).toInt();
                return effectiveQty(d) <= criticalAt;
              }).toList();

              final lowDocsAll = allDocs.where((d) {
                final data = d.data() as Map<String, dynamic>;
                final criticalAt = (data['critical_at'] as num? ?? 3).toInt();
                final lowAt = (data['low_at'] as num? ?? 6).toInt();
                final qty = effectiveQty(d);
                return qty > criticalAt && qty <= lowAt;
              }).toList();

              // ── Apply tab filter first, then search within it ──────────
              List<QueryDocumentSnapshot> tabFiltered;
              if (_filter == 'Critical') {
                tabFiltered = criticalDocsAll;
              } else if (_filter == 'Low Stock') {
                tabFiltered = lowDocsAll;
              } else {
                tabFiltered = allDocs;
              }
              final filtered = tabFiltered.where(matchesSearch).toList();

              // ── Group filtered results by category ─────────────────────
              final Map<String, List<QueryDocumentSnapshot>> grouped = {};
              for (final d in filtered) {
                final data = d.data() as Map<String, dynamic>;
                final cat = data['category'] as String? ?? 'Other';
                grouped.putIfAbsent(cat, () => []).add(d);
              }
              final categories = grouped.keys.toList()..sort();

              // ── Critical names for the banner ──────────────────────────
              final criticalNames = criticalDocsAll.map((d) {
                return (d.data() as Map<String, dynamic>)['name']
                        as String? ??
                    '';
              }).where((n) => n.isNotEmpty).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Page title ──────────────────────────────────────
                    const Text('Inventory Management',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 16),

                    // ── Critical alert banner ───────────────────────────
                    if (criticalNames.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: _red.withOpacity(0.3), width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                  color: _red,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.warning_rounded,
                                  color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${criticalNames.length} Critical Item${criticalNames.length > 1 ? 's' : ''}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _red),
                                ),
                                Text(
                                  criticalNames.join(', '),
                                  style: TextStyle(
                                      fontSize: 12, color: _red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // ── Filter tabs row ─────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 8,
                          children: [
                            _FilterTab(
                              label: 'All Items',
                              count: allDocs.length,
                              selected: _filter == 'All Items',
                              color: _brown,
                              onTap: () =>
                                  setState(() => _filter = 'All Items'),
                            ),
                            _FilterTab(
                              label: 'Critical',
                              count: criticalDocsAll.length,
                              selected: _filter == 'Critical',
                              color: _red,
                              onTap: () =>
                                  setState(() => _filter = 'Critical'),
                            ),
                            _FilterTab(
                              label: 'Low Stock',
                              count: lowDocsAll.length,
                              selected: _filter == 'Low Stock',
                              color: _orange,
                              onTap: () =>
                                  setState(() => _filter = 'Low Stock'),
                            ),
                          ],
                        ),
                        // Unsaved / Up to date label
                        Row(
                          children: [
                            Icon(
                              _hasUnsavedChanges
                                  ? Icons.edit_note_outlined
                                  : Icons.check_circle_outline,
                              size: 14,
                              color: _hasUnsavedChanges
                                  ? _orange
                                  : _green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _hasUnsavedChanges
                                  ? 'Unsaved Changes'
                                  : 'Stock up to date',
                              style: TextStyle(
                                fontSize: 12,
                                color: _hasUnsavedChanges
                                    ? _orange
                                    : _green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Category groups ─────────────────────────────────
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
                                    : Icons.inventory_2_outlined,
                                size: 48,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _search.isNotEmpty
                                    ? 'No results for "$_search" in ${_filter == "All Items" ? "all items" : _filter.toLowerCase()}.'
                                    : allDocs.isEmpty
                                        ? 'No ingredients yet. Tap "Add Ingredient" to get started.'
                                        : 'No items match the "$_filter" filter.',
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
                      ...categories.map((cat) {
                        final items = grouped[cat]!;
                        return _CategoryGroup(
                          category: cat,
                          items: items,
                          pendingChanges: _pendingChanges,
                          onQuantityChange: (docId, newQty) {
                            setState(() {
                              _pendingChanges[docId] = newQty;
                              _hasUnsavedChanges = true;
                            });
                          },
                          onEdit: (doc) => _openDialog(doc: doc),
                          onDelete: (docId) => _deleteItem(docId),
                        );
                      }),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Filter Tab chip
// ═══════════════════════════════════════════════════════════════════════════════
class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.count,
    required this.selected,
    required this.color,
    required this.onTap,
  });
  final String label;
  final int count;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : Colors.white,
          border: Border.all(
              color: selected ? color : const Color(0xFFD9D9D9)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != 'All Items')
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  label == 'Critical'
                      ? Icons.warning_rounded
                      : Icons.trending_down,
                  size: 12,
                  color: selected ? color : Colors.black38,
                ),
              ),
            Text('$label ($count)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                    color: selected ? color : Colors.black54)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Category group section
// ═══════════════════════════════════════════════════════════════════════════════
class _CategoryGroup extends StatelessWidget {
  const _CategoryGroup({
    required this.category,
    required this.items,
    required this.pendingChanges,
    required this.onQuantityChange,
    required this.onEdit,
    required this.onDelete,
  });

  final String category;
  final List<QueryDocumentSnapshot> items;
  final Map<String, int> pendingChanges;
  final void Function(String docId, int newQty) onQuantityChange;
  final void Function(DocumentSnapshot doc) onEdit;
  final void Function(String docId) onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Row(
            children: [
              const Icon(Icons.category_outlined,
                  size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(category,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final baseQty =
                (data['quantity'] as num? ?? 0).toInt();
            final qty = pendingChanges[doc.id] ?? baseQty;
            final unit = data['unit'] as String? ?? '';
            final criticalAt =
                (data['critical_at'] as num? ?? 3).toInt();
            final lowAt = (data['low_at'] as num? ?? 6).toInt();
            final minQty = data['min_qty'] as num?;

            String status;
            if (qty <= criticalAt) {
              status = 'Critical';
            } else if (qty <= lowAt) {
              status = 'Low Stock';
            } else {
              status = 'OK';
            }

            final isCritical = status == 'Critical';
            final isLow = status == 'Low Stock';

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isCritical
                    ? const Color(0xFFFFF0F0)
                    : isLow
                        ? const Color(0xFFFFF8F0)
                        : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCritical
                      ? const Color(0xFFFFCDD2)
                      : isLow
                          ? const Color(0xFFFFE0B2)
                          : const Color(0xFFEEEEEE),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Name + badge
                      Expanded(
                        child: Row(
                          children: [
                            Text(data['name'] as String? ?? '',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                            if (status != 'OK') ...[
                              const SizedBox(width: 8),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isCritical
                                      ? const Color(0xFFFFCDD2)
                                      : const Color(0xFFFFE0B2),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(status,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: isCritical
                                            ? const Color(0xFFE53935)
                                            : const Color(
                                                0xFFF57C00))),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Qty controls
                      Row(
                        children: [
                          _QtyButton(
                            icon: Icons.remove,
                            onTap: qty > 0
                                ? () => onQuantityChange(
                                    doc.id, qty - 1)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text('$qty $unit',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                          const SizedBox(width: 8),
                          _QtyButton(
                            icon: Icons.add,
                            onTap: () =>
                                onQuantityChange(doc.id, qty + 1),
                          ),
                          const SizedBox(width: 8),
                          // Edit button
                          GestureDetector(
                            onTap: () => onEdit(doc),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: const Color(0xFFD9D9D9)),
                              ),
                              child: const Icon(
                                  Icons.edit_outlined,
                                  size: 14,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Progress bar + current qty label
                  Row(
                    children: [
                      Text('$qty $unit',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black45)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: minQty != null && minQty > 0
                                ? (qty / (minQty * 3)).clamp(0.0, 1.0)
                                : (qty / 20.0).clamp(0.0, 1.0),
                            minHeight: 5,
                            backgroundColor: Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCritical
                                  ? const Color(0xFFE53935)
                                  : isLow
                                      ? const Color(0xFFF57C00)
                                      : const Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      ),
                      if (minQty != null) ...[
                        const SizedBox(width: 8),
                        Text('Min: $minQty',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black45)),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Small qty +/- button ──────────────────────────────────────────────────────
class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: onTap != null ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        child: Icon(icon,
            size: 14,
            color: onTap != null ? Colors.black54 : Colors.black26),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Add / Edit Ingredient Dialog
// ═══════════════════════════════════════════════════════════════════════════════
class _IngredientDialog extends StatefulWidget {
  const _IngredientDialog({this.doc});
  final DocumentSnapshot? doc;

  @override
  State<_IngredientDialog> createState() => _IngredientDialogState();
}

class _IngredientDialogState extends State<_IngredientDialog> {
  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _borderGray = Color(0xFFD9D9D9);

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _minQtyCtrl = TextEditingController();
  final _criticalAtCtrl = TextEditingController(text: '3');
  final _lowAtCtrl = TextEditingController(text: '6');

  String _category = 'Dairy';
  String _unit = 'liters';
  bool _isSaving = false;

  bool get _isEditing => widget.doc != null;

  static const List<String> _categories = [
    'Dairy',
    'Powder',
    'Syrups',
    'Beans & Grounds',
    'Cups & Packaging',
    'Sweeteners',
    'Other',
  ];

  static const List<String> _units = [
    'liters',
    'ml',
    'kg',
    'g',
    'cans',
    'pcs',
    'packs',
    'bottles',
    'bags',
    'boxes',
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final data = widget.doc!.data() as Map<String, dynamic>;
      _nameCtrl.text = data['name'] ?? '';
      _qtyCtrl.text = (data['quantity'] ?? '').toString();
      _minQtyCtrl.text = (data['min_qty'] ?? '').toString();
      _criticalAtCtrl.text = (data['critical_at'] ?? 3).toString();
      _lowAtCtrl.text = (data['low_at'] ?? 6).toString();
      _category = data['category'] ?? 'Dairy';
      _unit = data['unit'] ?? 'liters';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _minQtyCtrl.dispose();
    _criticalAtCtrl.dispose();
    _lowAtCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final payload = {
      'name': _nameCtrl.text.trim(),
      'category': _category,
      'unit': _unit,
      'quantity': num.tryParse(_qtyCtrl.text) ?? 0,
      'min_qty': num.tryParse(_minQtyCtrl.text),
      'critical_at': num.tryParse(_criticalAtCtrl.text) ?? 3,
      'low_at': num.tryParse(_lowAtCtrl.text) ?? 6,
      'updated_at': FieldValue.serverTimestamp(),
    };

    final ref =
        FirebaseFirestore.instance.collection('inventory_items');
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
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title bar ───────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing
                              ? 'Edit Ingredient'
                              : 'Add Ingredient',
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
                      icon: const Icon(Icons.close,
                          size: 18, color: Colors.black45),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // ── Form ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      _label('Ingredient Name *'),
                      const SizedBox(height: 6),
                      _field(_nameCtrl, 'e.g. Oat Milk',
                          validator: (v) => v!.trim().isEmpty
                              ? 'Name is required'
                              : null),
                      const SizedBox(height: 14),

                      // Category + Unit row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _label('Category *'),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _category,
                                  decoration: _inputDec(''),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87),
                                  items: _categories
                                      .map((c) => DropdownMenuItem(
                                          value: c, child: Text(c)))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _category = v!),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _label('Unit *'),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _unit,
                                  decoration: _inputDec(''),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87),
                                  items: _units
                                      .map((u) => DropdownMenuItem(
                                          value: u, child: Text(u)))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _unit = v!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Current qty + min qty
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _label('Current Quantity *'),
                                const SizedBox(height: 6),
                                _field(_qtyCtrl, 'e.g. 10',
                                    keyboardType:
                                        TextInputType.number,
                                    validator: (v) =>
                                        v!.trim().isEmpty
                                            ? 'Required'
                                            : null),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _label('Minimum Quantity'),
                                const SizedBox(height: 6),
                                _field(_minQtyCtrl, 'e.g. 5',
                                    keyboardType:
                                        TextInputType.number),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Alert thresholds
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8F0),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFFFFE0B2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.notifications_outlined,
                                    size: 15,
                                    color: Color(0xFFF57C00)),
                                SizedBox(width: 6),
                                Text('Alert Thresholds',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFF57C00))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Set when to trigger Critical and Low Stock alerts',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black45),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration:
                                              const BoxDecoration(
                                            color: Color(0xFFE53935),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Text('Critical at',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w500,
                                                color:
                                                    Colors.black54)),
                                      ]),
                                      const SizedBox(height: 5),
                                      _field(_criticalAtCtrl, '3',
                                          keyboardType:
                                              TextInputType.number,
                                          validator: (v) =>
                                              v!.trim().isEmpty
                                                  ? 'Required'
                                                  : null),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration:
                                              const BoxDecoration(
                                            color: Color(0xFFF57C00),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Text('Low Stock at',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w500,
                                                color:
                                                    Colors.black54)),
                                      ]),
                                      const SizedBox(height: 5),
                                      _field(_lowAtCtrl, '6',
                                          keyboardType:
                                              TextInputType.number,
                                          validator: (v) =>
                                              v!.trim().isEmpty
                                                  ? 'Required'
                                                  : null),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Buttons
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
                                        child:
                                            CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white))
                                    : const Icon(Icons.check, size: 16),
                                label: Text(
                                  _isEditing
                                      ? 'Save Changes'
                                      : 'Add Ingredient',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _brown,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8)),
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
                                side: const BorderSide(
                                    color: _borderGray),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8)),
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
            const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
            borderSide:
                BorderSide(color: Colors.red.shade300)),
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
        style:
            const TextStyle(fontSize: 13, color: Colors.black87),
        decoration: _inputDec(hint),
        validator: validator,
      );
}
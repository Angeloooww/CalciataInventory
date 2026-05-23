import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_menu_page.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// StaffInventoryPage
// ═══════════════════════════════════════════════════════════════════════════════
class StaffInventoryPage extends StatefulWidget {
  const StaffInventoryPage({super.key});

  @override
  State<StaffInventoryPage> createState() => _StaffInventoryPageState();
}

class _StaffInventoryPageState extends State<StaffInventoryPage> {
  int _selectedNavIndex = 1; // 0 = Menu, 1 = Inventory

  String get _currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@').first ?? 'Staff';
  }

  void _onNavSelect(int i) {
    if (i == _selectedNavIndex) return;
    setState(() => _selectedNavIndex = i);
    if (i == 0) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const StaffMenuPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      backgroundColor: const Color(0xFFF2EDE8),
      body: isWide
          ? Row(children: [
              _StaffInvSidebar(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
              Expanded(child: _StaffInventoryContent(userName: _currentUser)),
            ])
          : Column(children: [
              Expanded(child: _StaffInventoryContent(userName: _currentUser)),
              _StaffInvBottomNav(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
            ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sidebar
// ═══════════════════════════════════════════════════════════════════════════════
class _StaffInvSidebar extends StatelessWidget {
  const _StaffInvSidebar(
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
class _StaffInvBottomNav extends StatelessWidget {
  const _StaffInvBottomNav(
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
class _StaffInvTopBar extends StatelessWidget {
  const _StaffInvTopBar({required this.userName});
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
// Inventory Content — read + update quantity only (no add/delete/edit item)
// ═══════════════════════════════════════════════════════════════════════════════
class _StaffInventoryContent extends StatefulWidget {
  const _StaffInventoryContent({required this.userName});
  final String userName;

  @override
  State<_StaffInventoryContent> createState() =>
      _StaffInventoryContentState();
}

class _StaffInventoryContentState extends State<_StaffInventoryContent> {
  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _red = Color(0xFFE53935);
  static const Color _orange = Color(0xFFF57C00);
  static const Color _green = Color(0xFF4CAF50);

  String _filter = 'All Items';
  String _search = '';
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, int> _pendingChanges = {};

  CollectionReference get _inventoryRef =>
      FirebaseFirestore.instance.collection('inventory_items');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text('Failed to save: $e')),
            ]),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StaffInvTopBar(userName: widget.userName),

        // ── Search + Update Stocks button ─────────────────────────────────
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
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: (_hasUnsavedChanges && !_isSaving) ? _saveChanges : null,
                icon: _isSaving
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.sync, size: 16),
                label: Text(_isSaving ? 'Saving...' : 'Update Stocks',
                    style: const TextStyle(fontSize: 13)),
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
                final name =
                    (data['name'] as String? ?? '').toLowerCase();
                final cat =
                    (data['category'] as String? ?? '').toLowerCase();
                return name.contains(q) || cat.contains(q);
              }

              final criticalDocsAll = allDocs.where((d) {
                final data = d.data() as Map<String, dynamic>;
                final criticalAt =
                    (data['critical_at'] as num? ?? 3).toInt();
                return effectiveQty(d) <= criticalAt;
              }).toList();

              final lowDocsAll = allDocs.where((d) {
                final data = d.data() as Map<String, dynamic>;
                final criticalAt =
                    (data['critical_at'] as num? ?? 3).toInt();
                final lowAt = (data['low_at'] as num? ?? 6).toInt();
                final qty = effectiveQty(d);
                return qty > criticalAt && qty <= lowAt;
              }).toList();

              List<QueryDocumentSnapshot> tabFiltered;
              if (_filter == 'Critical') {
                tabFiltered = criticalDocsAll;
              } else if (_filter == 'Low Stock') {
                tabFiltered = lowDocsAll;
              } else {
                tabFiltered = allDocs;
              }
              final filtered =
                  tabFiltered.where(matchesSearch).toList();

              final Map<String, List<QueryDocumentSnapshot>> grouped = {};
              for (final d in filtered) {
                final data = d.data() as Map<String, dynamic>;
                final cat = data['category'] as String? ?? 'Other';
                grouped.putIfAbsent(cat, () => []).add(d);
              }
              final categories = grouped.keys.toList()..sort();

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
                    const Text('Inventory',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 16),

                    // ── Critical alert banner ─────────────────────────
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
                                  color: _red, shape: BoxShape.circle),
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
                                Text(criticalNames.join(', '),
                                    style:
                                        TextStyle(fontSize: 12, color: _red)),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // ── Filter tabs ───────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 8,
                          children: [
                            _StaffFilterTab(
                              label: 'All Items',
                              count: allDocs.length,
                              selected: _filter == 'All Items',
                              color: _brown,
                              onTap: () =>
                                  setState(() => _filter = 'All Items'),
                            ),
                            _StaffFilterTab(
                              label: 'Critical',
                              count: criticalDocsAll.length,
                              selected: _filter == 'Critical',
                              color: _red,
                              onTap: () =>
                                  setState(() => _filter = 'Critical'),
                            ),
                            _StaffFilterTab(
                              label: 'Low Stock',
                              count: lowDocsAll.length,
                              selected: _filter == 'Low Stock',
                              color: _orange,
                              onTap: () =>
                                  setState(() => _filter = 'Low Stock'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              _hasUnsavedChanges
                                  ? Icons.edit_note_outlined
                                  : Icons.check_circle_outline,
                              size: 14,
                              color: _hasUnsavedChanges ? _orange : _green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _hasUnsavedChanges
                                  ? 'Unsaved Changes'
                                  : 'Stock up to date',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    _hasUnsavedChanges ? _orange : _green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Category groups ───────────────────────────────
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
                                    ? 'No results for "$_search".'
                                    : allDocs.isEmpty
                                        ? 'No inventory items yet.'
                                        : 'No items match "$_filter".',
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
                        return _StaffCategoryGroup(
                          category: cat,
                          items: items,
                          pendingChanges: _pendingChanges,
                          onQuantityChange: (docId, newQty) {
                            setState(() {
                              _pendingChanges[docId] = newQty;
                              _hasUnsavedChanges = true;
                            });
                          },
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

// ── Filter tab chip ───────────────────────────────────────────────────────────
class _StaffFilterTab extends StatelessWidget {
  const _StaffFilterTab({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

// ── Category group — staff can only +/- quantity ──────────────────────────────
class _StaffCategoryGroup extends StatelessWidget {
  const _StaffCategoryGroup({
    required this.category,
    required this.items,
    required this.pendingChanges,
    required this.onQuantityChange,
  });

  final String category;
  final List<QueryDocumentSnapshot> items;
  final Map<String, int> pendingChanges;
  final void Function(String docId, int newQty) onQuantityChange;

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
            final baseQty = (data['quantity'] as num? ?? 0).toInt();
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
                                padding: const EdgeInsets.symmetric(
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
                                            : const Color(0xFFF57C00))),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Qty +/- controls
                      Row(
                        children: [
                          _StaffQtyButton(
                            icon: Icons.remove,
                            onTap: qty > 0
                                ? () => onQuantityChange(doc.id, qty - 1)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text('$qty $unit',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                          const SizedBox(width: 8),
                          _StaffQtyButton(
                            icon: Icons.add,
                            onTap: () =>
                                onQuantityChange(doc.id, qty + 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
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

// ── Qty button ────────────────────────────────────────────────────────────────
class _StaffQtyButton extends StatelessWidget {
  const _StaffQtyButton({required this.icon, this.onTap});
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
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';
import 'menu_page.dart';
import 'inventory_page.dart';
import 'sales_page.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// StaffPage
// ═══════════════════════════════════════════════════════════════════════════════
class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  int _selectedNavIndex = 4;

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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const SalesPage()));
        break;
      case 4:
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
              _StaffSidebar(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
              Expanded(child: _StaffContent(userName: _currentUser)),
            ])
          : Column(children: [
              Expanded(child: _StaffContent(userName: _currentUser)),
              _StaffBottomNav(
                  selectedIndex: _selectedNavIndex, onSelect: _onNavSelect),
            ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sidebar
// ═══════════════════════════════════════════════════════════════════════════════
class _StaffSidebar extends StatelessWidget {
  const _StaffSidebar({required this.selectedIndex, required this.onSelect});
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
                            color: selected ? Colors.white : Colors.black54,
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
class _StaffBottomNav extends StatelessWidget {
  const _StaffBottomNav(
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
      ],
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
class _StaffTopBar extends StatelessWidget {
  const _StaffTopBar({required this.userName});
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
// Staff Content
// ═══════════════════════════════════════════════════════════════════════════════
class _StaffContent extends StatefulWidget {
  const _StaffContent({required this.userName});
  final String userName;

  @override
  State<_StaffContent> createState() => _StaffContentState();
}

class _StaffContentState extends State<_StaffContent> {
  static const Color _brown = Color(0xFF8B5E3C);

  final TextEditingController _searchController = TextEditingController();
  String _search = '';
  String _filterRole = 'All';

  static const List<String> _roles = [
    'All', 'Barista', 'Cashier', 'Supervisor', 'Part-time', 'Other'
  ];

  CollectionReference get _staffRef =>
      FirebaseFirestore.instance.collection('staff');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDialog({DocumentSnapshot? doc}) {
    showDialog(
      context: context,
      builder: (_) => _StaffDialog(doc: doc),
    );
  }

  Future<void> _deleteStaff(String docId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        title: const Text('Remove Staff',
            style:
                TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Text(
            'Are you sure you want to remove $name from the staff list?',
            style: const TextStyle(fontSize: 13)),
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
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _staffRef.doc(docId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StaffTopBar(userName: widget.userName),

        // ── Search + Add button (outside StreamBuilder) ───────────────
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
                    border:
                        Border.all(color: const Color(0xFFD9D9D9)),
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
                          onChanged: (v) =>
                              setState(() => _search = v),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: 'Search staff by name, role...',
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
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () => _openDialog(),
                icon: const Icon(Icons.person_add_outlined, size: 16),
                label: const Text('Add Staff',
                    style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brown,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _staffRef.snapshots(),
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

              // Filter by role tab
              final roleFiltered = _filterRole == 'All'
                  ? allDocs
                  : allDocs.where((d) {
                      final data = d.data() as Map<String, dynamic>;
                      return (data['role'] as String? ?? '') ==
                          _filterRole;
                    }).toList();

              // Filter by search
              final filtered = roleFiltered.where((d) {
                if (_search.isEmpty) return true;
                final data = d.data() as Map<String, dynamic>;
                final q = _search.toLowerCase();
                final name =
                    (data['full_name'] as String? ?? '').toLowerCase();
                final role =
                    (data['role'] as String? ?? '').toLowerCase();
                final phone =
                    (data['phone'] as String? ?? '').toLowerCase();
                final email =
                    (data['email'] as String? ?? '').toLowerCase();
                return name.contains(q) ||
                    role.contains(q) ||
                    phone.contains(q) ||
                    email.contains(q);
              }).toList()
                ..sort((a, b) {
                  final aName = ((a.data()
                              as Map<String, dynamic>)['full_name']
                          as String? ??
                      '');
                  final bName = ((b.data()
                              as Map<String, dynamic>)['full_name']
                          as String? ??
                      '');
                  return aName
                      .toLowerCase()
                      .compareTo(bName.toLowerCase());
                });

              // Role counts
              Map<String, int> roleCounts = {'All': allDocs.length};
              for (final d in allDocs) {
                final data = d.data() as Map<String, dynamic>;
                final role = data['role'] as String? ?? 'Other';
                roleCounts[role] = (roleCounts[role] ?? 0) + 1;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Page header ────────────────────────────────────
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text('Staff Management',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            const SizedBox(height: 2),
                            Text(
                              '${allDocs.length} staff member${allDocs.length == 1 ? '' : 's'} total',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Stat cards ─────────────────────────────────────
                    _StaffStatRow(docs: allDocs),
                    const SizedBox(height: 16),

                    // ── Role filter tabs ───────────────────────────────
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _roles.map((role) {
                          final count = roleCounts[role] ?? 0;
                          final selected = _filterRole == role;
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _filterRole = role),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? _brown.withOpacity(0.12)
                                      : Colors.white,
                                  border: Border.all(
                                      color: selected
                                          ? _brown
                                          : const Color(0xFFD9D9D9)),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(
                                  role == 'All'
                                      ? 'All ($count)'
                                      : '$role ($count)',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: selected
                                          ? _brown
                                          : Colors.black54),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Staff list ─────────────────────────────────────
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
                                    : Icons.people_outline,
                                size: 48,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _search.isNotEmpty
                                    ? 'No staff found for "$_search".'
                                    : allDocs.isEmpty
                                        ? 'No staff added yet.\nTap "Add Staff" to get started.'
                                        : 'No staff in the "$_filterRole" role.',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade400),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              color: Color(0xFFF0EBE5),
                              indent: 72),
                          itemBuilder: (context, i) {
                            final doc = filtered[i];
                            final data =
                                doc.data() as Map<String, dynamic>;
                            return _StaffListTile(
                              doc: doc,
                              data: data,
                              onEdit: () => _openDialog(doc: doc),
                              onDelete: () => _deleteStaff(
                                  doc.id,
                                  data['full_name'] as String? ??
                                      'this staff'),
                            );
                          },
                        ),
                      ),
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

// ── Stat row ──────────────────────────────────────────────────────────────────
class _StaffStatRow extends StatelessWidget {
  const _StaffStatRow({required this.docs});
  final List<QueryDocumentSnapshot> docs;

  @override
  Widget build(BuildContext context) {
    final total = docs.length;
    final active = docs.where((d) {
      final data = d.data() as Map<String, dynamic>;
      return (data['status'] as String? ?? 'Active') == 'Active';
    }).length;
    final onLeave = docs.where((d) {
      final data = d.data() as Map<String, dynamic>;
      return (data['status'] as String? ?? '') == 'On Leave';
    }).length;

    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 500 ? 3 : 1;
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: cols == 3 ? 3.0 : 4.0,
        children: [
          _MiniStatCard(
              icon: Icons.people_rounded,
              label: 'Total Staff',
              value: '$total',
              color: const Color(0xFF8B5E3C)),
          _MiniStatCard(
              icon: Icons.check_circle_outline,
              label: 'Active',
              value: '$active',
              color: const Color(0xFF4CAF50)),
          _MiniStatCard(
              icon: Icons.beach_access_outlined,
              label: 'On Leave',
              value: '$onLeave',
              color: const Color(0xFFF57C00)),
        ],
      );
    });
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.black45)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Staff list tile ───────────────────────────────────────────────────────────
class _StaffListTile extends StatelessWidget {
  const _StaffListTile({
    required this.doc,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final QueryDocumentSnapshot doc;
  final Map<String, dynamic> data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF4CAF50);
      case 'On Leave':
        return const Color(0xFFF57C00);
      case 'Inactive':
        return Colors.grey;
      default:
        return const Color(0xFF4CAF50);
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final name = data['full_name'] as String? ?? '';
    final role = data['role'] as String? ?? '';
    final phone = data['phone'] as String? ?? '';
    final email = data['email'] as String? ?? '';
    final address = data['address'] as String? ?? '';
    final status = data['status'] as String? ?? 'Active';
    final startDate = data['start_date'] as String? ?? '';
    final emergencyContact =
        data['emergency_contact'] as String? ?? '';
    final emergencyPhone =
        data['emergency_phone'] as String? ?? '';
    final notes = data['notes'] as String? ?? '';

    final statusColor = _statusColor(status);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF8B5E3C).withOpacity(0.15),
            child: Text(
              _initials(name),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5E3C)),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + status badge
                Row(
                  children: [
                    Expanded(
                      child: Text(name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(status,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: statusColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // Role
                Text(role,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B5E3C),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),

                // Contact details
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    if (phone.isNotEmpty)
                      _InfoChip(
                          icon: Icons.phone_outlined, text: phone),
                    if (email.isNotEmpty)
                      _InfoChip(
                          icon: Icons.email_outlined, text: email),
                    if (address.isNotEmpty)
                      _InfoChip(
                          icon: Icons.location_on_outlined,
                          text: address),
                    if (startDate.isNotEmpty)
                      _InfoChip(
                          icon: Icons.calendar_today_outlined,
                          text: 'Since $startDate'),
                  ],
                ),

                // Emergency contact
                if (emergencyContact.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.emergency_outlined,
                        size: 12, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      'Emergency: $emergencyContact${emergencyPhone.isNotEmpty ? ' · $emergencyPhone' : ''}',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.black45),
                    ),
                  ]),
                ],

                // Notes
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(notes,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black38,
                          fontStyle: FontStyle.italic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Action buttons
          Column(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0EB),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: const Color(0xFFE0D8D0)),
                  ),
                  child: const Icon(Icons.edit_outlined,
                      size: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: Colors.red.shade100),
                  ),
                  child: Icon(Icons.person_remove_outlined,
                      size: 14, color: Colors.red.shade400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.black38),
        const SizedBox(width: 3),
        Text(text,
            style: const TextStyle(
                fontSize: 11, color: Colors.black54)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Add / Edit Staff Dialog
// ═══════════════════════════════════════════════════════════════════════════════
class _StaffDialog extends StatefulWidget {
  const _StaffDialog({this.doc});
  final DocumentSnapshot? doc;

  @override
  State<_StaffDialog> createState() => _StaffDialogState();
}

class _StaffDialogState extends State<_StaffDialog> {
  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _borderGray = Color(0xFFD9D9D9);

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _emergencyContactCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _role = 'Barista';
  String _status = 'Active';
  bool _isSaving = false;

  bool get _isEditing => widget.doc != null;

  static const List<String> _roles = [
    'Barista', 'Cashier', 'Supervisor', 'Part-time', 'Other'
  ];
  static const List<String> _statuses = [
    'Active', 'On Leave', 'Inactive'
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final data = widget.doc!.data() as Map<String, dynamic>;
      _nameCtrl.text = data['full_name'] ?? '';
      _phoneCtrl.text = data['phone'] ?? '';
      _emailCtrl.text = data['email'] ?? '';
      _addressCtrl.text = data['address'] ?? '';
      _startDateCtrl.text = data['start_date'] ?? '';
      _emergencyContactCtrl.text = data['emergency_contact'] ?? '';
      _emergencyPhoneCtrl.text = data['emergency_phone'] ?? '';
      _notesCtrl.text = data['notes'] ?? '';
      _role = data['role'] ?? 'Barista';
      _status = data['status'] ?? 'Active';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _startDateCtrl.dispose();
    _emergencyContactCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final payload = {
      'full_name': _nameCtrl.text.trim(),
      'role': _role,
      'status': _status,
      'phone': _phoneCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
      'start_date': _startDateCtrl.text.trim(),
      'emergency_contact': _emergencyContactCtrl.text.trim(),
      'emergency_phone': _emergencyPhoneCtrl.text.trim(),
      'notes': _notesCtrl.text.trim(),
      'updated_at': FieldValue.serverTimestamp(),
    };

    final ref = FirebaseFirestore.instance.collection('staff');
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
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title bar ─────────────────────────────────────────────
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
                          _isEditing ? 'Edit Staff' : 'Add Staff Member',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        if (_isEditing && _nameCtrl.text.isNotEmpty)
                          Text(_nameCtrl.text,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8B5E3C),
                                  fontWeight: FontWeight.w500)),
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

              // ── Form ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section: Personal Info
                      _sectionLabel('Personal Information'),
                      const SizedBox(height: 10),

                      // Full name
                      _label('Full Name *'),
                      const SizedBox(height: 6),
                      _field(_nameCtrl, 'e.g. Juan Dela Cruz',
                          validator: (v) => v!.trim().isEmpty
                              ? 'Name is required'
                              : null),
                      const SizedBox(height: 12),

                      // Role + Status
                      Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _label('Role *'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _role,
                                decoration: _inputDec(''),
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87),
                                items: _roles
                                    .map((r) => DropdownMenuItem(
                                        value: r, child: Text(r)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _role = v!),
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
                              _label('Status *'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _status,
                                decoration: _inputDec(''),
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87),
                                items: _statuses
                                    .map((s) => DropdownMenuItem(
                                        value: s, child: Text(s)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _status = v!),
                              ),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),

                      // Start date
                      _label('Start Date'),
                      const SizedBox(height: 6),
                      _field(_startDateCtrl, 'e.g. Jan 15, 2024'),
                      const SizedBox(height: 18),

                      // Section: Contact
                      _sectionLabel('Contact Details'),
                      const SizedBox(height: 10),

                      Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _label('Phone Number'),
                              const SizedBox(height: 6),
                              _field(_phoneCtrl, 'e.g. 09XX XXX XXXX',
                                  keyboardType: TextInputType.phone),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _label('Email Address'),
                              const SizedBox(height: 6),
                              _field(
                                  _emailCtrl, 'e.g. juan@email.com',
                                  keyboardType:
                                      TextInputType.emailAddress),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),

                      _label('Home Address'),
                      const SizedBox(height: 6),
                      _field(_addressCtrl,
                          'e.g. 123 Mango St, Cebu City'),
                      const SizedBox(height: 18),

                      // Section: Emergency Contact
                      _sectionLabel('Emergency Contact'),
                      const SizedBox(height: 10),

                      Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _label('Contact Name'),
                              const SizedBox(height: 6),
                              _field(_emergencyContactCtrl,
                                  'e.g. Maria Dela Cruz'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _label('Contact Phone'),
                              const SizedBox(height: 6),
                              _field(_emergencyPhoneCtrl,
                                  'e.g. 09XX XXX XXXX',
                                  keyboardType: TextInputType.phone),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 18),

                      // Section: Notes
                      _sectionLabel('Additional Notes'),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87),
                        decoration: _inputDec(
                            'e.g. Available on weekends, specialty in latte art...'),
                      ),
                      const SizedBox(height: 24),

                      // Buttons
                      Row(children: [
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
                                  : const Icon(Icons.check, size: 16),
                              label: Text(
                                _isEditing
                                    ? 'Save Changes'
                                    : 'Add Staff Member',
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
                      ]),
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

  Widget _sectionLabel(String text) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0EB),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B5E3C),
                letterSpacing: 0.3)),
      );

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
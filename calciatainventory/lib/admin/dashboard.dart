import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'menu_page.dart';
import 'dart:math' as math;
import 'inventory_page.dart';
import 'sales_page.dart';
import 'staff_page.dart';
import '../login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  static const Color _brown = Color(0xFF8B5E3C);

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@').first ?? 'Manager';
  }

  void _onNavSelect(int i) {
    setState(() => _selectedIndex = i);
    switch (i) {
      case 0:
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
              _Sidebar(selectedIndex: _selectedIndex, onSelect: _onNavSelect),
              Expanded(
                  child: _DashboardContent(
                      greeting: _greeting(), userName: _currentUser)),
            ])
          : Column(children: [
              Expanded(
                  child: _DashboardContent(
                      greeting: _greeting(), userName: _currentUser)),
              _BottomNav(selectedIndex: _selectedIndex, onSelect: _onNavSelect),
            ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sidebar
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
    _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
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
            return GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? _brown : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(_items[i].icon,
                        size: 18,
                        color: selected ? Colors.white : Colors.black54),
                    const SizedBox(width: 10),
                    Text(_items[i].label,
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

// ── Bottom nav ────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.selectedIndex, required this.onSelect});
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
class _TopBar extends StatelessWidget {
  const _TopBar({required this.userName, required this.criticalCount});
  final String userName;
  final int criticalCount;

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
          // Notification bell — shows real critical inventory count
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined,
                  size: 22, color: Colors.black54),
              if (criticalCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: Color(0xFFE53935), shape: BoxShape.circle),
                    child: Center(
                        child: Text('$criticalCount',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 9))),
                  ),
                ),
            ],
          ),
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
// Dashboard Content — all sections driven by Firestore
// ═══════════════════════════════════════════════════════════════════════════════
class _DashboardContent extends StatelessWidget {
  const _DashboardContent(
      {required this.greeting, required this.userName});
  final String greeting;
  final String userName;

  @override
  Widget build(BuildContext context) {
    // Pull all streams at once with a single outer StreamBuilder for inventory
    // (to pass criticalCount to top bar)
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('inventory_items')
          .snapshots(),
      builder: (context, invSnap) {
        final invDocs = invSnap.data?.docs ?? [];
        final criticalCount = invDocs.where((d) {
          final data = d.data() as Map<String, dynamic>;
          final qty = (data['quantity'] as num? ?? 0).toInt();
          final critAt = (data['critical_at'] as num? ?? 3).toInt();
          return qty <= critAt;
        }).length;

        return Column(
          children: [
            _TopBar(userName: userName, criticalCount: criticalCount),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Greeting ─────────────────────────────────────────
                    Row(
                      children: [
                        Text(
                          '$greeting, $userName ',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const Text('✳️', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Here's what's happening at your coffee shop today.",
                      style:
                          TextStyle(fontSize: 13, color: Colors.black45),
                    ),
                    const SizedBox(height: 20),

                    // ── 4 KPI stat cards ──────────────────────────────────
                    _KpiCards(invDocs: invDocs),
                    const SizedBox(height: 20),

                    // ── Critical inventory alert ──────────────────────────
                    if (criticalCount > 0)
                      _CriticalBanner(invDocs: invDocs),

                    // ── Two-column row: Sales chart + Inventory overview ──
                    LayoutBuilder(builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 640;
                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3,
                                child: _SalesChartCard()),
                            const SizedBox(width: 16),
                            Expanded(
                                flex: 2,
                                child: _InventoryStatusCard(
                                    invDocs: invDocs)),
                          ],
                        );
                      }
                      return Column(children: [
                        _SalesChartCard(),
                        const SizedBox(height: 16),
                        _InventoryStatusCard(invDocs: invDocs),
                      ]);
                    }),
                    const SizedBox(height: 16),

                    // ── Two-column row: Recent Sales + Menu overview ──────
                    LayoutBuilder(builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 640;
                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _RecentSalesCard()),
                            const SizedBox(width: 16),
                            Expanded(child: _MenuOverviewCard()),
                          ],
                        );
                      }
                      return Column(children: [
                        _RecentSalesCard(),
                        const SizedBox(height: 16),
                        _MenuOverviewCard(),
                      ]);
                    }),
                    const SizedBox(height: 16),

                    // ── Staff overview (full width) ───────────────────────
                    _StaffOverviewCard(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// KPI cards — live from Firestore
// ═══════════════════════════════════════════════════════════════════════════════
class _KpiCards extends StatelessWidget {
  const _KpiCards({required this.invDocs});
  final List<QueryDocumentSnapshot> invDocs;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('daily_sales')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, salesSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('menu_items')
              .snapshots(),
          builder: (context, menuSnap) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('staff')
                  .snapshots(),
              builder: (context, staffSnap) {
                final salesDocs = salesSnap.data?.docs ?? [];
                final menuDocs = menuSnap.data?.docs ?? [];
                final staffDocs = staffSnap.data?.docs ?? [];

                // Today's sales
                final today = DateTime.now();
                final todayDocs = salesDocs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final ts = data['date'];
                  if (ts is! Timestamp) return false;
                  final date = ts.toDate();
                  return date.year == today.year &&
                      date.month == today.month &&
                      date.day == today.day;
                }).toList();

                double todaySales = 0;
                for (final d in todayDocs) {
                  final data = d.data() as Map<String, dynamic>;
                  todaySales += (data['amount'] as num? ?? 0).toDouble();
                }

                // Yesterday for comparison
                final yesterday =
                    today.subtract(const Duration(days: 1));
                double yesterdaySales = 0;
                for (final d in salesDocs) {
                  final data = d.data() as Map<String, dynamic>;
                  final ts = data['date'];
                  if (ts is! Timestamp) continue;
                  final date = ts.toDate();
                  if (date.year == yesterday.year &&
                      date.month == yesterday.month &&
                      date.day == yesterday.day) {
                    yesterdaySales +=
                        (data['amount'] as num? ?? 0).toDouble();
                  }
                }

                String salesBadge;
                Color salesBadgeColor;
                if (yesterdaySales > 0) {
                  final pct =
                      ((todaySales - yesterdaySales) / yesterdaySales) *
                          100;
                  salesBadge =
                      '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(1)}%';
                  salesBadgeColor = pct >= 0
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE53935);
                } else {
                  salesBadge = todaySales > 0 ? 'New' : 'No data';
                  salesBadgeColor = Colors.black45;
                }

                // Inventory: critical items count
                final criticalItems = invDocs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final qty = (data['quantity'] as num? ?? 0).toInt();
                  final critAt =
                      (data['critical_at'] as num? ?? 3).toInt();
                  return qty <= critAt;
                }).length;

                // Active staff
                final activeStaff = staffDocs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  return (data['status'] as String? ?? 'Active') ==
                      'Active';
                }).length;

                return LayoutBuilder(builder: (context, constraints) {
                  final cols = constraints.maxWidth > 600 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: cols,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio:
                        constraints.maxWidth > 600 ? 1.6 : 1.45,
                    children: [
                      _KpiCard(
                        icon: Icons.attach_money,
                        iconColor: const Color(0xFF8B5E3C),
                        value: todaySales > 0
                            ? '₱${todaySales.toStringAsFixed(0)}'
                            : '—',
                        label: "Today's Sales",
                        sub: 'vs yesterday',
                        badge: salesBadge,
                        badgeColor: salesBadgeColor,
                      ),
                      _KpiCard(
                        icon: Icons.restaurant_menu_rounded,
                        iconColor: const Color(0xFF1976D2),
                        value: '${menuDocs.length}',
                        label: 'Menu Items',
                        sub: 'active drinks',
                        badge: menuDocs.isEmpty ? 'Empty' : 'Listed',
                        badgeColor: menuDocs.isEmpty
                            ? Colors.orange
                            : const Color(0xFF4CAF50),
                      ),
                      _KpiCard(
                        icon: Icons.inventory_2_rounded,
                        iconColor: criticalItems > 0
                            ? const Color(0xFFE53935)
                            : const Color(0xFF4CAF50),
                        value: '${invDocs.length}',
                        label: 'Ingredients',
                        sub: '$criticalItems critical',
                        badge: criticalItems > 0
                            ? '$criticalItems Critical'
                            : 'All OK',
                        badgeColor: criticalItems > 0
                            ? const Color(0xFFE53935)
                            : const Color(0xFF4CAF50),
                      ),
                      _KpiCard(
                        icon: Icons.people_rounded,
                        iconColor: const Color(0xFF7B1FA2),
                        value: '${staffDocs.length}',
                        label: 'Total Staff',
                        sub: '$activeStaff active',
                        badge: '$activeStaff Active',
                        badgeColor: activeStaff > 0
                            ? const Color(0xFF4CAF50)
                            : Colors.black45,
                      ),
                    ],
                  );
                });
              },
            );
          },
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.sub,
    required this.badge,
    required this.badgeColor,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String sub;
  final String badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 17, color: iconColor),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(badge,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: badgeColor)),
              ),
            ],
          ),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              maxLines: 1),
          Text(sub,
              style: const TextStyle(fontSize: 10, color: Colors.black38)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Critical inventory banner
// ═══════════════════════════════════════════════════════════════════════════════
class _CriticalBanner extends StatelessWidget {
  const _CriticalBanner({required this.invDocs});
  final List<QueryDocumentSnapshot> invDocs;

  @override
  Widget build(BuildContext context) {
    final criticalItems = invDocs.where((d) {
      final data = d.data() as Map<String, dynamic>;
      final qty = (data['quantity'] as num? ?? 0).toInt();
      final critAt = (data['critical_at'] as num? ?? 3).toInt();
      return qty <= critAt;
    }).toList();

    if (criticalItems.isEmpty) return const SizedBox.shrink();

    final names = criticalItems
        .map((d) =>
            (d.data() as Map<String, dynamic>)['name'] as String? ?? '')
        .where((n) => n.isNotEmpty)
        .toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: const Color(0xFFE53935).withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                color: Color(0xFFE53935), shape: BoxShape.circle),
            child: const Icon(Icons.warning_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${criticalItems.length} Critical Ingredient${criticalItems.length > 1 ? 's' : ''} — Restock Needed',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53935)),
                ),
                Text(names.join(' · '),
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFFE53935))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sales chart card — real daily_sales data
// ═══════════════════════════════════════════════════════════════════════════════
class _SalesChartCard extends StatelessWidget {
  const _SalesChartCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('daily_sales')
          .orderBy('date', descending: false)
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        // Build last 7 data points
        final List<Map<String, dynamic>> chartData = [];
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

        if (docs.isEmpty) {
          // Show placeholder bars if no data
          for (int i = 0; i < 7; i++) {
            chartData.add({'day': days[i], 'value': 0.0});
          }
        } else {
          // Use last 7 entries
          final recent = docs.length > 7
              ? docs.sublist(docs.length - 7)
              : docs;
          for (final d in recent) {
            final data = d.data() as Map<String, dynamic>;
            final ts = data['date'];
            String label = '—';
            if (ts is Timestamp) {
              final dt = ts.toDate();
              label = days[dt.weekday - 1];
            }
            chartData.add({
              'day': label,
              'value': (data['amount'] as num? ?? 0).toDouble(),
            });
          }
        }

        // Totals
        double total = chartData.fold(0.0, (s, e) => s + (e['value'] as double));
        final avg = chartData.isEmpty ? 0.0 : total / chartData.length;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sales Trend',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5E3C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Last 7 entries',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8B5E3C),
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Total: ₱${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black45),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Avg: ₱${avg.toStringAsFixed(0)}/day',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: docs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart_outlined,
                                size: 40,
                                color: Colors.grey.shade300),
                            const SizedBox(height: 8),
                            Text('No sales recorded yet.',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400)),
                          ],
                        ),
                      )
                    : _BarChart(data: chartData),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Bar chart painter ─────────────────────────────────────────────────────────
class _BarChart extends StatelessWidget {
  const _BarChart({required this.data});
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return CustomPaint(
        size: Size(constraints.maxWidth, constraints.maxHeight),
        painter: _BarChartPainter(data: data),
      );
    });
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({required this.data});
  final List<Map<String, dynamic>> data;

  static const Color _barColor = Color(0xFF8B5E3C);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    const double leftPad = 52;
    const double bottomPad = 28;
    const double topPad = 10;
    final double chartW = size.width - leftPad - 8;
    final double chartH = size.height - bottomPad - topPad;

    final values = data.map((e) => e['value'] as double).toList();
    final maxVal = values.reduce(math.max);
    final effectiveMax = maxVal == 0 ? 1.0 : maxVal * 1.15;

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..strokeWidth = 1;
    const gridLines = 4;
    final labelStyle =
        const TextStyle(fontSize: 10, color: Colors.black38);

    for (int i = 0; i <= gridLines; i++) {
      final y = topPad + chartH - (chartH / gridLines) * i;
      canvas.drawLine(
          Offset(leftPad, y), Offset(size.width - 8, y), gridPaint);
      final val = (effectiveMax / gridLines) * i;
      final label = val >= 1000
          ? '₱${(val / 1000).toStringAsFixed(0)}K'
          : '₱${val.toStringAsFixed(0)}';
      _drawText(canvas, label, Offset(0, y - 6), labelStyle, leftPad - 4);
    }

    // Bars
    final n = data.length;
    final barW = (chartW / n) * 0.55;
    final gap = (chartW / n) * 0.45;

    for (int i = 0; i < n; i++) {
      final val = values[i];
      final barH = (val / effectiveMax) * chartH;
      final x = leftPad + (chartW / n) * i + gap / 2;
      final y = topPad + chartH - barH;

      final isMax = val == maxVal && maxVal > 0;
      final paint = Paint()
        ..color = isMax ? _barColor : _barColor.withOpacity(0.45)
        ..style = PaintingStyle.fill;

      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barW, barH),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);

      // Value label above bar
      if (val > 0) {
        final vLabel = val >= 1000
            ? '₱${(val / 1000).toStringAsFixed(1)}K'
            : '₱${val.toStringAsFixed(0)}';
        _drawText(canvas, vLabel, Offset(x - 4, y - 14),
            const TextStyle(fontSize: 9, color: Colors.black54), 52);
      }

      // X label
      _drawText(
          canvas,
          data[i]['day'] as String,
          Offset(x + barW / 2 - 8,
              size.height - bottomPad + 6),
          labelStyle,
          30);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style,
      double maxWidth) {
    final tp = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: maxWidth);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Inventory status card
// ═══════════════════════════════════════════════════════════════════════════════
class _InventoryStatusCard extends StatelessWidget {
  const _InventoryStatusCard({required this.invDocs});
  final List<QueryDocumentSnapshot> invDocs;

  @override
  Widget build(BuildContext context) {
    final critical = <Map<String, dynamic>>[];
    final low = <Map<String, dynamic>>[];
    final ok = <Map<String, dynamic>>[];

    for (final d in invDocs) {
      final data = d.data() as Map<String, dynamic>;
      final qty = (data['quantity'] as num? ?? 0).toInt();
      final critAt = (data['critical_at'] as num? ?? 3).toInt();
      final lowAt = (data['low_at'] as num? ?? 6).toInt();
      if (qty <= critAt) {
        critical.add(data);
      } else if (qty <= lowAt) {
        low.add(data);
      } else {
        ok.add(data);
      }
    }

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
          const Text('Inventory Overview',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 4),
          Text('${invDocs.length} ingredients tracked',
              style:
                  const TextStyle(fontSize: 12, color: Colors.black45)),
          const SizedBox(height: 16),

          // Summary counts
          Row(
            children: [
              _InvBadge(
                  label: 'Critical',
                  count: critical.length,
                  color: const Color(0xFFE53935)),
              const SizedBox(width: 8),
              _InvBadge(
                  label: 'Low',
                  count: low.length,
                  color: const Color(0xFFF57C00)),
              const SizedBox(width: 8),
              _InvBadge(
                  label: 'OK',
                  count: ok.length,
                  color: const Color(0xFF4CAF50)),
            ],
          ),
          const SizedBox(height: 16),

          // Stock bar chart (horizontal)
          if (invDocs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('No ingredients added yet.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade400)),
              ),
            )
          else
            ...invDocs.take(6).map((d) {
              final data = d.data() as Map<String, dynamic>;
              final name = data['name'] as String? ?? '';
              final qty = (data['quantity'] as num? ?? 0).toInt();
              final unit = data['unit'] as String? ?? '';
              final critAt = (data['critical_at'] as num? ?? 3).toInt();
              final lowAt = (data['low_at'] as num? ?? 6).toInt();
              final minQty = data['min_qty'] as num?;

              Color barColor;
              if (qty <= critAt) {
                barColor = const Color(0xFFE53935);
              } else if (qty <= lowAt) {
                barColor = const Color(0xFFF57C00);
              } else {
                barColor = const Color(0xFF4CAF50);
              }

              final progress = minQty != null && minQty > 0
                  ? (qty / (minQty * 3)).clamp(0.0, 1.0)
                  : (qty / 20.0).clamp(0.0, 1.0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text('$qty $unit',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: barColor)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: Colors.black.withOpacity(0.06),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(barColor),
                      ),
                    ),
                  ],
                ),
              );
            }),
          if (invDocs.length > 6)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '+ ${invDocs.length - 6} more items',
                style: const TextStyle(
                    fontSize: 11, color: Colors.black38),
              ),
            ),
        ],
      ),
    );
  }
}

class _InvBadge extends StatelessWidget {
  const _InvBadge(
      {required this.label,
      required this.count,
      required this.color});
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text('$count',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: color)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Recent sales card
// ═══════════════════════════════════════════════════════════════════════════════
class _RecentSalesCard extends StatelessWidget {
  const _RecentSalesCard();

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('daily_sales')
          .orderBy('date', descending: true)
          .limit(6)
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Sales',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const Icon(Icons.receipt_long_outlined,
                      size: 18, color: Colors.black38),
                ],
              ),
              const SizedBox(height: 16),
              if (snap.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator())
              else if (docs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 40, color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Text('No sales recorded yet.',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400)),
                      ],
                    ),
                  ),
                )
              else
                ...docs.map((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final ts = data['date'];
                  DateTime? date;
                  if (ts is Timestamp) date = ts.toDate();
                  final amount =
                      (data['amount'] as num? ?? 0).toDouble();
                  final notes = data['notes'] as String? ?? '';
                  final createdBy =
                      data['created_by'] as String? ?? '';

                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5E3C)
                                .withOpacity(0.08),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: const Icon(
                              Icons.attach_money,
                              size: 16,
                              color: Color(0xFF8B5E3C)),
                        ),
                        const SizedBox(width: 12),
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
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.black87),
                              ),
                              if (notes.isNotEmpty)
                                Text(notes,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black38),
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow.ellipsis),
                              if (createdBy.isNotEmpty)
                                Text('by $createdBy',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black38)),
                            ],
                          ),
                        ),
                        Text(
                          '₱${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Menu overview card
// ═══════════════════════════════════════════════════════════════════════════════
class _MenuOverviewCard extends StatelessWidget {
  const _MenuOverviewCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('menu_items')
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        // Group by category
        final Map<String, int> catCounts = {};
        for (final d in docs) {
          final data = d.data() as Map<String, dynamic>;
          final cat = data['category'] as String? ?? 'Other';
          catCounts[cat] = (catCounts[cat] ?? 0) + 1;
        }
        final cats = catCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        // Most and least expensive using actual price fields
        QueryDocumentSnapshot? mostExpensive;
        QueryDocumentSnapshot? leastExpensive;
        double maxPrice = -1;
        double minPrice = double.infinity;

        for (final d in docs) {
          final data = d.data() as Map<String, dynamic>;
          final prices = [
            data['hot_price_8oz'],
            data['hot_price_16oz'],
            data['iced_price_8oz'],
            data['iced_price_16oz'],
          ]
              .whereType<num>()
              .map((e) => e.toDouble())
              .toList();
          if (prices.isEmpty) continue;
          final highest = prices.reduce(math.max);
          final lowest = prices.reduce(math.min);
          if (highest > maxPrice) {
            maxPrice = highest;
            mostExpensive = d;
          }
          if (lowest < minPrice) {
            minPrice = lowest;
            leastExpensive = d;
          }
        }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Menu Overview',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const Icon(Icons.restaurant_menu_outlined,
                      size: 18, color: Colors.black38),
                ],
              ),
              const SizedBox(height: 4),
              Text('${docs.length} item${docs.length == 1 ? '' : 's'} total',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black45)),
              const SizedBox(height: 16),

              if (docs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(Icons.coffee_outlined,
                            size: 40,
                            color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Text('No menu items yet.',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400)),
                      ],
                    ),
                  ),
                )
              else ...[
                // Category breakdown
                const Text('By Category',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54)),
                const SizedBox(height: 8),
                ...cats.take(5).map((e) {
                  final pct = docs.isEmpty
                      ? 0.0
                      : e.value / docs.length;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(e.key,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87),
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 80,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 5,
                              backgroundColor:
                                  Colors.black.withOpacity(0.06),
                              valueColor:
                                  const AlwaysStoppedAnimation(
                                      Color(0xFF8B5E3C)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 20,
                          child: Text('${e.value}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54)),
                        ),
                      ],
                    ),
                  );
                }),

                const Divider(height: 20, color: Color(0xFFF0EBE5)),

                // Price highlights
                if (mostExpensive != null)
                  _MenuPriceRow(
                    label: 'Highest price',
                    name: (mostExpensive!.data()
                            as Map<String, dynamic>)['name'] as String? ??
                        '',
                    price: '₱${maxPrice.toStringAsFixed(0)}',
                    color: const Color(0xFF8B5E3C),
                  ),
                if (leastExpensive != null)
                  _MenuPriceRow(
                    label: 'Lowest price',
                    name: (leastExpensive!.data()
                            as Map<String, dynamic>)['name'] as String? ??
                        '',
                    price: '₱${minPrice.toStringAsFixed(0)}',
                    color: const Color(0xFF4CAF50),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MenuPriceRow extends StatelessWidget {
  const _MenuPriceRow(
      {required this.label,
      required this.name,
      required this.price,
      required this.color});
  final String label;
  final String name;
  final String price;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10, color: Colors.black38)),
                Text(name,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(price,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Staff overview card
// ═══════════════════════════════════════════════════════════════════════════════
class _StaffOverviewCard extends StatelessWidget {
  const _StaffOverviewCard();

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF4CAF50);
      case 'On Leave':
        return const Color(0xFFF57C00);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('staff')
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        final active = docs
            .where((d) =>
                ((d.data() as Map<String, dynamic>)['status'] as String? ??
                    'Active') ==
                'Active')
            .length;
        final onLeave = docs
            .where((d) =>
                ((d.data() as Map<String, dynamic>)['status'] as String? ??
                    '') ==
                'On Leave')
            .length;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Staff Overview',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  Row(
                    children: [
                      _StaffStatChip(
                          label: 'Active',
                          count: active,
                          color: const Color(0xFF4CAF50)),
                      const SizedBox(width: 8),
                      _StaffStatChip(
                          label: 'On Leave',
                          count: onLeave,
                          color: const Color(0xFFF57C00)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (docs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(Icons.people_outline,
                            size: 40,
                            color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Text('No staff added yet.',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400)),
                      ],
                    ),
                  ),
                )
              else
                // Horizontal scroll of staff cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: docs.map((d) {
                      final data =
                          d.data() as Map<String, dynamic>;
                      final name =
                          data['full_name'] as String? ?? '';
                      final role =
                          data['role'] as String? ?? '';
                      final status =
                          data['status'] as String? ?? 'Active';
                      final phone =
                          data['phone'] as String? ?? '';
                      final statusColor = _statusColor(status);

                      return Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F6F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFEDE8E0)),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(
                                          0xFF8B5E3C)
                                      .withOpacity(0.15),
                                  child: Text(
                                    _initials(name),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.bold,
                                        color:
                                            Color(0xFF8B5E3C)),
                                  ),
                                ),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(name,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(role,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF8B5E3C),
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Text(status,
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor)),
                            ),
                            if (phone.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(children: [
                                const Icon(Icons.phone_outlined,
                                    size: 10,
                                    color: Colors.black38),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(phone,
                                      style: const TextStyle(
                                          fontSize: 9,
                                          color: Colors.black38),
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis),
                                ),
                              ]),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StaffStatChip extends StatelessWidget {
  const _StaffStatChip(
      {required this.label,
      required this.count,
      required this.color});
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text('$count $label',
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color)),
    );
  }
}
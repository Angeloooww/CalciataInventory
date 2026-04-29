import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'menu_page.dart';
import 'dart:math' as math;
import 'inventory_page.dart';
import 'sales_page.dart';
import 'staff_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  static const Color _brown = Color(0xFF8B5E3C);
  static const Color _lightBrown = Color(0xFFF5F0EB);
  static const Color _cardBg = Colors.white;
  static const Color _sidebarBg = Color(0xFFF7F3EF);
  static const Color _green = Color(0xFF4CAF50);

  final List<Map<String, dynamic>> _salesData = [
    {'day': 'Mon', 'value': 8000.0},
    {'day': 'Tue', 'value': 9500.0},
    {'day': 'Wed', 'value': 8200.0},
    {'day': 'Thu', 'value': 9000.0},
    {'day': 'Fri', 'value': 11000.0},
    {'day': 'Sat', 'value': 13500.0},
    {'day': 'Sun', 'value': 11800.0},
  ];

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF2EDE8),
      body: isWide ? _wideLayout() : _narrowLayout(),
    );
  }

  // ── Wide layout (sidebar + content) ──────────────────────────────────────────
  // Navigation handler
  void _onNavSelect(int i) {
    setState(() => _selectedIndex = i);
    switch (i) {
      case 0:
        break; // Already on Dashboard
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MenuPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryPage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SalesPage()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffPage()));
        break;
      case 5:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
        break;
    }
  }

  Widget _wideLayout() {
    return Row(
      children: [
        _Sidebar(
          selectedIndex: _selectedIndex,
          onSelect: _onNavSelect,
        ),
        Expanded(child: _MainContent(greeting: _greeting(), userName: _currentUser, salesData: _salesData)),
      ],
    );
  }

  // ── Narrow layout (bottom nav) ────────────────────────────────────────────────
  Widget _narrowLayout() {
    return Column(
      children: [
        Expanded(child: _MainContent(greeting: _greeting(), userName: _currentUser, salesData: _salesData)),
        _BottomNav(
          selectedIndex: _selectedIndex,
          onSelect: _onNavSelect,
        ),
      ],
    );
  }
}

// ── Sidebar ───────────────────────────────────────────────────────────────────
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
          // ── Brand header ──────────────────────────────────────────────────
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

          // ── Nav items ─────────────────────────────────────────────────────
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

          // ── System status ─────────────────────────────────────────────────
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

  static const Color _brown = Color(0xFF8B5E3C);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _brown : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(item.icon,
                size: 18,
                color: selected ? Colors.white : Colors.black54),
            const SizedBox(width: 10),
            Text(item.label,
                style: TextStyle(
                    fontSize: 13,
                    color: selected ? Colors.white : Colors.black54,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
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
      BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_rounded), label: 'Menu'),
      BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), label: 'Inventory'),
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Sales'),
      BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Staff'),
      BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
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

// ── Main content area ─────────────────────────────────────────────────────────
class _MainContent extends StatelessWidget {
  const _MainContent({
    required this.greeting,
    required this.userName,
    required this.salesData,
  });
  final String greeting;
  final String userName;
  final List<Map<String, dynamic>> salesData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBar(userName: userName),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Greeting ──────────────────────────────────────────────
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
                  style: TextStyle(fontSize: 13, color: Colors.black45),
                ),
                const SizedBox(height: 20),

                // ── Stat cards ────────────────────────────────────────────
                _StatCards(),
                const SizedBox(height: 24),

                // ── Sales trends chart ────────────────────────────────────
                _SalesTrendsCard(salesData: salesData),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({required this.userName});
  final String userName;

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Auth state listener in main.dart will navigate back to LoginPage.
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
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('2',
                        style:
                            TextStyle(color: Colors.white, fontSize: 8)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // User avatar + name + sign out
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

// ── Stat cards row ────────────────────────────────────────────────────────────
class _StatCards extends StatelessWidget {
  const _StatCards();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossCount = width > 600 ? 4 : 2;
      return GridView.count(
        crossAxisCount: crossCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: width > 600 ? 1.55 : 1.4,
        children: const [
          _StatCard(
            icon: Icons.attach_money,
            value: '₱12,340',
            label: 'Total Sales Today',
            sub: 'vs yesterday',
            badge: '+12.5%',
            badgeColor: Color(0xFF4CAF50),
          ),
          _StatCard(
            icon: Icons.coffee_outlined,
            value: '158',
            label: 'Total Cups',
            sub: 'vs yesterday',
            badge: '+8.2%',
            badgeColor: Color(0xFF4CAF50),
          ),
          _StatCard(
            icon: Icons.local_cafe_outlined,
            value: 'Iced Latte',
            label: 'Top-Selling Item',
            sub: 'today',
            badge: '32 sold',
            badgeColor: Colors.black54,
          ),
          _StatCard(
            icon: Icons.person_outline,
            value: '3',
            label: 'Total Staff',
            sub: 'current shift',
            badge: 'All present',
            badgeColor: Color(0xFF4CAF50),
          ),
        ],
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.sub,
    required this.badge,
    required this.badgeColor,
  });

  final IconData icon;
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
              Icon(icon, size: 20, color: Colors.black54),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(badge,
                    style: TextStyle(
                        fontSize: 10,
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
              style:
                  const TextStyle(fontSize: 11, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 1),
          Text(sub,
              style:
                  const TextStyle(fontSize: 10, color: Colors.black38)),
        ],
      ),
    );
  }
}

// ── Sales Trends Card ─────────────────────────────────────────────────────────
class _SalesTrendsCard extends StatefulWidget {
  const _SalesTrendsCard({required this.salesData});
  final List<Map<String, dynamic>> salesData;

  @override
  State<_SalesTrendsCard> createState() => _SalesTrendsCardState();
}

class _SalesTrendsCardState extends State<_SalesTrendsCard> {
  String _period = 'Weekly';

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sales Trends',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5E3C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_period,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: 200,
            child: _LineChart(data: widget.salesData),
          ),
        ],
      ),
    );
  }
}

// ── Custom line chart ─────────────────────────────────────────────────────────
class _LineChart extends StatelessWidget {
  const _LineChart({required this.data});
  final List<Map<String, dynamic>> data;

  static const Color _lineColor = Color(0xFF8B5E3C);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _LineChartPainter(data: data, lineColor: _lineColor),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.data, required this.lineColor});
  final List<Map<String, dynamic>> data;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double leftPad = 48;
    const double bottomPad = 28;
    const double topPad = 10;
    final double chartW = size.width - leftPad;
    final double chartH = size.height - bottomPad - topPad;

    final values = data.map((e) => e['value'] as double).toList();
    final minVal = values.reduce(math.min);
    final maxVal = values.reduce(math.max);
    final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;

    // Y-axis grid lines & labels
    final gridPaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..strokeWidth = 1;
    final labelStyle = const TextStyle(fontSize: 10, color: Colors.black38);

    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = topPad + chartH - (chartH / gridLines) * i;
      canvas.drawLine(
          Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final val = minVal + (range / gridLines) * i;
      final label = val >= 1000
          ? '₱${(val / 1000).toStringAsFixed(0)}K'
          : '₱${val.toStringAsFixed(0)}';
      _drawText(canvas, label, Offset(0, y - 6), labelStyle, leftPad - 4);
    }

    // Compute points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = leftPad + (chartW / (data.length - 1)) * i;
      final val = (data[i]['value'] as double);
      final normalised = (val - minVal) / range;
      final y = topPad + chartH - normalised * chartH;
      points.add(Offset(x, y));
    }

    // Gradient fill under line
    final fillPath = Path()..moveTo(points.first.dx, topPad + chartH);
    for (final p in points) fillPath.lineTo(p.dx, p.dy);
    fillPath.lineTo(points.last.dx, topPad + chartH);
    fillPath.close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withOpacity(0.18),
          lineColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, topPad, size.width, chartH));
    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final cp1 = Offset((prev.dx + curr.dx) / 2, prev.dy);
      final cp2 = Offset((prev.dx + curr.dx) / 2, curr.dy);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Dots
    final dotFill = Paint()..color = Colors.white;
    final dotBorder = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (final p in points) {
      canvas.drawCircle(p, 4, dotFill);
      canvas.drawCircle(p, 4, dotBorder);
    }

    // X labels
    for (int i = 0; i < data.length; i++) {
      _drawText(
          canvas,
          data[i]['day'] as String,
          Offset(points[i].dx - 12, size.height - bottomPad + 6),
          labelStyle,
          30);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset,
      TextStyle style, double maxWidth) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
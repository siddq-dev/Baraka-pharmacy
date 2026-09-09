import 'package:flutter/material.dart';

import '../theme/admin_colors.dart';

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),

          const SizedBox(height: 24),

          _buildStatsGrid(),

          const SizedBox(height: 24),

          _buildMainAnalyticsRow(),

          const SizedBox(height: 24),

          _buildBottomRow(),

          const SizedBox(height: 24),

          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Super Admin',
                style: TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 6),

              Text(
                'Here is what is happening with Barakaa Pharmacy today.',
                style: TextStyle(
                  color: AdminColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        OutlinedButton.icon(
          onPressed: null,
          icon: Icon(Icons.calendar_today_outlined, size: 17),
          label: Text('Today'),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        int columns;

        if (width >= 1200) {
          columns = 4;
        } else if (width >= 800) {
          columns = 2;
        } else {
          columns = 1;
        }

        const double spacing = 16;

        final double cardWidth = (width - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                title: 'Total Customers',
                value: '2,486',
                change: '+12.5%',
                subtitle: 'vs last month',
                icon: Icons.people_outline,
                iconColor: AdminColors.info,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                title: 'Total Products',
                value: '1,284',
                change: '+4.8%',
                subtitle: 'vs last month',
                icon: Icons.inventory_2_outlined,
                iconColor: AdminColors.primary,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                title: 'Total Orders',
                value: '8,642',
                change: '+18.2%',
                subtitle: 'vs last month',
                icon: Icons.shopping_bag_outlined,
                iconColor: AdminColors.warning,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                title: 'Total Revenue',
                value: '₹8.42L',
                change: '+21.4%',
                subtitle: 'vs last month',
                icon: Icons.currency_rupee,
                iconColor: AdminColors.success,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String change,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 21),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AdminColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    change,
                    style: const TextStyle(
                      color: AdminColors.success,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              title,
              style: const TextStyle(
                color: AdminColors.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              value,
              style: const TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              style: const TextStyle(
                color: AdminColors.textSecondary,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainAnalyticsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 850) {
          return Column(
            children: [
              _buildSalesOverview(),
              const SizedBox(height: 20),
              _buildOrderStatus(),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildSalesOverview()),

            const SizedBox(width: 20),

            Expanded(child: _buildOrderStatus()),
          ],
        );
      },
    );
  }

  Widget _buildSalesOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales Overview',
                        style: TextStyle(
                          color: AdminColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Revenue performance',
                        style: TextStyle(
                          color: AdminColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildDropdown('This Week'),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '₹2,84,650',
                  style: TextStyle(
                    color: AdminColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AdminColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    '+14.8%',
                    style: TextStyle(
                      color: AdminColors.success,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(height: 190, child: _buildSalesChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    const List<double> values = [0.42, 0.58, 0.48, 0.76, 0.64, 0.88, 0.72];

    const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: values[index],
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: index == 5
                              ? AdminColors.primary
                              : AdminColors.primary.withValues(alpha: 0.20),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  days[index],
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOrderStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Status',
              style: TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Current order distribution',
              style: TextStyle(color: AdminColors.textSecondary, fontSize: 11),
            ),

            const SizedBox(height: 20),

            _buildOrderStatusItem(
              label: 'Delivered',
              value: '4,820',
              percentage: '56%',
              color: AdminColors.success,
              progress: 0.56,
            ),

            _buildOrderStatusItem(
              label: 'Processing',
              value: '1,420',
              percentage: '16%',
              color: AdminColors.primary,
              progress: 0.16,
            ),

            _buildOrderStatusItem(
              label: 'Shipping',
              value: '1,060',
              percentage: '12%',
              color: AdminColors.info,
              progress: 0.12,
            ),

            _buildOrderStatusItem(
              label: 'Out for Delivery',
              value: '840',
              percentage: '10%',
              color: AdminColors.warning,
              progress: 0.10,
            ),

            _buildOrderStatusItem(
              label: 'Returned / Cancelled',
              value: '502',
              percentage: '6%',
              color: AdminColors.danger,
              progress: 0.06,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusItem({
    required String label,
    required String value,
    required String percentage,
    required Color color,
    required double progress,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ),

              Text(
                value,
                style: const TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 8),

              SizedBox(
                width: 34,
                child: Text(
                  percentage,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: color,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AdminColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            children: [
              _buildRecentOrders(),
              const SizedBox(height: 20),
              _buildInventoryAlerts(),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildRecentOrders()),

            const SizedBox(width: 20),

            Expanded(child: _buildInventoryAlerts()),
          ],
        );
      },
    );
  }

  Widget _buildRecentOrders() {
    final orders = [
      {
        'id': '#BK1048',
        'customer': 'Abual',
        'items': 'Paracetamol + Vitamin C',
        'amount': '₹205',
        'status': 'Out for Delivery',
      },
      {
        'id': '#BK1047',
        'customer': 'Mohammed Ali',
        'items': 'First Aid Kit',
        'amount': '₹299',
        'status': 'Processing',
      },
      {
        'id': '#BK1046',
        'customer': 'Aisha Khan',
        'items': 'Vitamin C + Zinc',
        'amount': '₹420',
        'status': 'Delivered',
      },
      {
        'id': '#BK1045',
        'customer': 'Rahul Kumar',
        'items': 'Diabetes Care Pack',
        'amount': '₹685',
        'status': 'Shipping',
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Recent Orders',
                    style: TextStyle(
                      color: AdminColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                TextButton(onPressed: null, child: const Text('View All')),
              ],
            ),

            const SizedBox(height: 10),

            ...orders.map((order) {
              return _buildRecentOrderItem(order);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrderItem(Map<String, String> order) {
    final String status = order['status'] ?? '';

    final Color statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AdminColors.background,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AdminColors.primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['id'] ?? '',
                  style: const TextStyle(
                    color: AdminColors.textPrimary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  order['customer'] ?? '',
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 10.5,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  order['items'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                order['amount'] ?? '',
                style: const TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryAlerts() {
    final products = [
      {'name': 'Paracetamol 500mg', 'stock': '8 left', 'status': 'Low Stock'},
      {'name': 'Vitamin C 1000mg', 'stock': '3 left', 'status': 'Low Stock'},
      {
        'name': 'Digital Thermometer',
        'stock': '0 left',
        'status': 'Out of Stock',
      },
      {'name': 'First Aid Kit', 'stock': '12 left', 'status': 'Low Stock'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Inventory Alerts',
                    style: TextStyle(
                      color: AdminColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AdminColors.danger.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    '4 Alerts',
                    style: TextStyle(
                      color: AdminColors.danger,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ...products.map((product) {
              final bool outOfStock = product['status'] == 'Out of Stock';

              return _buildInventoryItem(
                name: product['name'] ?? '',
                stock: product['stock'] ?? '',
                outOfStock: outOfStock,
              );
            }),

            const SizedBox(height: 6),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: null,
                child: const Text('View Inventory'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem({
    required String name,
    required String stock,
    required bool outOfStock,
  }) {
    final Color color = outOfStock ? AdminColors.danger : AdminColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              outOfStock ? Icons.error_outline : Icons.warning_amber_outlined,
              color: color,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Text(
            stock,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickAction(
                  icon: Icons.person_add_outlined,
                  title: 'Add Admin',
                ),
                _buildQuickAction(
                  icon: Icons.add_box_outlined,
                  title: 'Add Product',
                ),
                _buildQuickAction(
                  icon: Icons.medical_services_outlined,
                  title: 'Add Doctor',
                ),
                _buildQuickAction(
                  icon: Icons.local_shipping_outlined,
                  title: 'Add Delivery Partner',
                ),
                _buildQuickAction(
                  icon: Icons.inventory_outlined,
                  title: 'Stock Adjustment',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({required IconData icon, required String title}) {
    return OutlinedButton.icon(
      onPressed: null,
      icon: Icon(icon, size: 17),
      label: Text(title),
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: AdminColors.border),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AdminColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 5),

          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: AdminColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return AdminColors.success;

      case 'Processing':
        return AdminColors.primary;

      case 'Shipping':
        return AdminColors.info;

      case 'Out for Delivery':
        return AdminColors.warning;

      default:
        return AdminColors.danger;
    }
  }
}

import 'package:flutter/material.dart';

import '../theme/admin_colors.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'All';
  String _selectedPaymentStatus = 'All';

  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#BK1004',
      'customer': 'Abual',
      'phone': '+91 98765 43210',
      'date': '07 Sep 2026, 10:25 AM',
      'items': 'Paracetamol + Vitamin C',
      'itemCount': 2,
      'amount': 205.0,
      'orderStatus': 'Out for Delivery',
      'paymentStatus': 'Paid',
      'paymentMethod': 'UPI',
      'prescriptionRequired': false,
      'deliveryPartner': 'Rahul Kumar',
    },
    {
      'id': '#BK1005',
      'customer': 'Mohammed Rahman',
      'phone': '+91 98765 12345',
      'date': '06 Sep 2026, 03:40 PM',
      'items': 'First Aid Kit',
      'itemCount': 1,
      'amount': 299.0,
      'orderStatus': 'In Shipping',
      'paymentStatus': 'Paid',
      'paymentMethod': 'Card',
      'prescriptionRequired': false,
      'deliveryPartner': 'Amit Singh',
    },
    {
      'id': '#BK1006',
      'customer': 'Aisha Khan',
      'phone': '+91 91234 56789',
      'date': '05 Sep 2026, 11:15 AM',
      'items': 'Vitamin C',
      'itemCount': 1,
      'amount': 180.0,
      'orderStatus': 'Processing',
      'paymentStatus': 'Paid',
      'paymentMethod': 'UPI',
      'prescriptionRequired': false,
      'deliveryPartner': null,
    },
    {
      'id': '#BK1007',
      'customer': 'Rahul Kumar',
      'phone': '+91 99887 66554',
      'date': '04 Sep 2026, 05:20 PM',
      'items': 'Amoxicillin 500mg',
      'itemCount': 1,
      'amount': 145.0,
      'orderStatus': 'Pending Prescription',
      'paymentStatus': 'Paid',
      'paymentMethod': 'UPI',
      'prescriptionRequired': true,
      'deliveryPartner': null,
    },
    {
      'id': '#BK1008',
      'customer': 'Fatima Ali',
      'phone': '+91 90000 11223',
      'date': '03 Sep 2026, 01:05 PM',
      'items': 'Cough Syrup + Paracetamol',
      'itemCount': 2,
      'amount': 120.0,
      'orderStatus': 'Delivered',
      'paymentStatus': 'Paid',
      'paymentMethod': 'Cash on Delivery',
      'prescriptionRequired': false,
      'deliveryPartner': 'Suresh Kumar',
    },
    {
      'id': '#BK1009',
      'customer': 'Sara Ahmed',
      'phone': '+91 91111 22334',
      'date': '02 Sep 2026, 09:45 AM',
      'items': 'Baby Lotion',
      'itemCount': 1,
      'amount': 220.0,
      'orderStatus': 'Cancelled',
      'paymentStatus': 'Refunded',
      'paymentMethod': 'Card',
      'prescriptionRequired': false,
      'deliveryPartner': null,
    },
    {
      'id': '#BK1010',
      'customer': 'Omar Ali',
      'phone': '+91 95555 66778',
      'date': '01 Sep 2026, 04:30 PM',
      'items': 'Vitamin C + First Aid Kit',
      'itemCount': 2,
      'amount': 479.0,
      'orderStatus': 'Returned',
      'paymentStatus': 'Refund Pending',
      'paymentMethod': 'UPI',
      'prescriptionRequired': false,
      'deliveryPartner': 'Amit Singh',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _countStatus(String status) {
    return _orders.where((order) => order['orderStatus'] == status).length;
  }

  double get _totalRevenue {
    return _orders
        .where(
          (order) =>
              order['orderStatus'] != 'Cancelled' &&
              order['orderStatus'] != 'Returned',
        )
        .fold<double>(0, (total, order) => total + (order['amount'] as double));
  }

  int get _pendingOrders {
    return _orders.where((order) {
      final status = order['orderStatus'];
      return status == 'Processing' ||
          status == 'Pending Prescription' ||
          status == 'In Shipping';
    }).length;
  }

  int get _prescriptionOrders {
    return _orders
        .where((order) => order['prescriptionRequired'] == true)
        .length;
  }

  List<Map<String, dynamic>> get _filteredOrders {
    final query = _searchController.text.trim().toLowerCase();

    return _orders.where((order) {
      final matchesSearch =
          query.isEmpty ||
          order['id'].toString().toLowerCase().contains(query) ||
          order['customer'].toString().toLowerCase().contains(query) ||
          order['phone'].toString().toLowerCase().contains(query) ||
          order['items'].toString().toLowerCase().contains(query);

      final matchesStatus =
          _selectedStatus == 'All' || order['orderStatus'] == _selectedStatus;

      final matchesPayment =
          _selectedPaymentStatus == 'All' ||
          order['paymentStatus'] == _selectedPaymentStatus;

      return matchesSearch && matchesStatus && matchesPayment;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 24),
                  _buildSummaryCards(isMobile),
                  const SizedBox(height: 24),
                  _buildOrdersSection(isMobile),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orders',
          style: TextStyle(
            fontSize: isMobile ? 24 : 30,
            fontWeight: FontWeight.w700,
            color: AdminColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Monitor orders, payments, prescriptions and delivery status.',
          style: TextStyle(fontSize: 14, color: AdminColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(bool isMobile) {
    final cards = [
      _summaryCard(
        title: 'Total Orders',
        value: '${_orders.length}',
        icon: Icons.shopping_bag_outlined,
        iconColor: AdminColors.info,
      ),
      _summaryCard(
        title: 'Pending Orders',
        value: '$_pendingOrders',
        icon: Icons.pending_actions_outlined,
        iconColor: AdminColors.warning,
      ),
      _summaryCard(
        title: 'Prescription Orders',
        value: '$_prescriptionOrders',
        icon: Icons.description_outlined,
        iconColor: AdminColors.primary,
      ),
      _summaryCard(
        title: 'Revenue',
        value: '₹${_totalRevenue.toStringAsFixed(0)}',
        icon: Icons.currency_rupee,
        iconColor: AdminColors.success,
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 12),
              Expanded(child: cards[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: cards[2]),
              const SizedBox(width: 12),
              Expanded(child: cards[3]),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 16),
        Expanded(child: cards[1]),
        const SizedBox(width: 16),
        Expanded(child: cards[2]),
        const SizedBox(width: 16),
        Expanded(child: cards[3]),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersSection(bool isMobile) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 14 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              const Text(
                'Order List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AdminColors.textPrimary,
                ),
              ),
            if (!isMobile) const SizedBox(height: 18),
            _buildFilters(isMobile),
            const SizedBox(height: 18),
            if (isMobile) _buildMobileOrders() else _buildDesktopOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search orders...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _statusDropdown()),
              const SizedBox(width: 10),
              Expanded(child: _paymentDropdown()),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search by order ID, customer, phone or product...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 14),
        SizedBox(width: 190, child: _statusDropdown()),
        const SizedBox(width: 14),
        SizedBox(width: 170, child: _paymentDropdown()),
      ],
    );
  }

  Widget _statusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedStatus,
      decoration: const InputDecoration(labelText: 'Order Status'),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Orders')),
        DropdownMenuItem(value: 'Processing', child: Text('Processing')),
        DropdownMenuItem(
          value: 'Pending Prescription',
          child: Text('Pending Prescription'),
        ),
        DropdownMenuItem(value: 'In Shipping', child: Text('In Shipping')),
        DropdownMenuItem(
          value: 'Out for Delivery',
          child: Text('Out for Delivery'),
        ),
        DropdownMenuItem(value: 'Delivered', child: Text('Delivered')),
        DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
        DropdownMenuItem(value: 'Returned', child: Text('Returned')),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedStatus = value;
        });
      },
    );
  }

  Widget _paymentDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedPaymentStatus,
      decoration: const InputDecoration(labelText: 'Payment'),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Payments')),
        DropdownMenuItem(value: 'Paid', child: Text('Paid')),
        DropdownMenuItem(value: 'Pending', child: Text('Pending')),
        DropdownMenuItem(value: 'Refunded', child: Text('Refunded')),
        DropdownMenuItem(
          value: 'Refund Pending',
          child: Text('Refund Pending'),
        ),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedPaymentStatus = value;
        });
      },
    );
  }

  Widget _buildDesktopOrders() {
    final orders = _filteredOrders;

    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1250,
        child: DataTable(
          columnSpacing: 18,
          headingRowHeight: 48,
          dataRowMinHeight: 70,
          dataRowMaxHeight: 82,
          columns: const [
            DataColumn(label: Text('Order')),
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Items')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Order Status')),
            DataColumn(label: Text('Payment')),
            DataColumn(label: Text('Prescription')),
            DataColumn(label: Text('Actions')),
          ],
          rows: orders.map((order) {
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['id'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          order['date'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['customer'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          order['phone'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 160,
                    child: Text(
                      '${order['items']} (${order['itemCount']})',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${(order['amount'] as double).toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                DataCell(_orderStatusBadge(order['orderStatus'])),
                DataCell(_paymentBadge(order['paymentStatus'])),
                DataCell(
                  _prescriptionBadge(order['prescriptionRequired'] as bool),
                ),
                DataCell(_actionMenu(order)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileOrders() {
    final orders = _filteredOrders;

    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: orders.map((order) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AdminColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['id'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order['customer'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _orderStatusBadge(order['orderStatus']),
                  _actionMenu(order),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                order['items'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AdminColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _mobileInfo(
                      'Amount',
                      '₹${(order['amount'] as double).toStringAsFixed(0)}',
                    ),
                  ),
                  Expanded(
                    child: _mobileInfo('Payment', order['paymentStatus']),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _mobileInfo(
                      'Payment Method',
                      order['paymentMethod'],
                    ),
                  ),
                  Expanded(
                    child: _mobileInfo(
                      'Prescription',
                      order['prescriptionRequired']
                          ? 'Required'
                          : 'Not Required',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                order['date'],
                style: const TextStyle(
                  fontSize: 11,
                  color: AdminColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _mobileInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AdminColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AdminColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _orderStatusBadge(String status) {
    Color color;

    switch (status) {
      case 'Delivered':
        color = AdminColors.success;
        break;
      case 'Cancelled':
        color = AdminColors.danger;
        break;
      case 'Returned':
        color = AdminColors.danger;
        break;
      case 'Out for Delivery':
        color = AdminColors.info;
        break;
      case 'In Shipping':
        color = AdminColors.primary;
        break;
      case 'Pending Prescription':
        color = AdminColors.warning;
        break;
      default:
        color = AdminColors.warning;
    }

    return _badge(text: status, color: color);
  }

  Widget _paymentBadge(String status) {
    Color color;

    switch (status) {
      case 'Paid':
        color = AdminColors.success;
        break;
      case 'Refunded':
        color = AdminColors.info;
        break;
      case 'Refund Pending':
        color = AdminColors.warning;
        break;
      default:
        color = AdminColors.danger;
    }

    return _badge(text: status, color: color);
  }

  Widget _prescriptionBadge(bool required) {
    return _badge(
      text: required ? 'Required' : 'No',
      color: required ? AdminColors.warning : AdminColors.textSecondary,
    );
  }

  Widget _badge({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _actionMenu(Map<String, dynamic> order) {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showOrderDetails(order);
            break;
          case 'status':
            _showStatusDialog(order);
            break;
          case 'prescription':
            _showPrescriptionInfo(order);
            break;
          case 'cancel':
            _cancelOrder(order);
            break;
        }
      },
      itemBuilder: (context) {
        final canCancel =
            order['orderStatus'] != 'Delivered' &&
            order['orderStatus'] != 'Cancelled' &&
            order['orderStatus'] != 'Returned';

        return [
          const PopupMenuItem(
            value: 'view',
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.visibility_outlined),
              title: Text('View Order'),
            ),
          ),
          const PopupMenuItem(
            value: 'status',
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.sync_outlined),
              title: Text('Update Status'),
            ),
          ),
          if (order['prescriptionRequired'] == true)
            const PopupMenuItem(
              value: 'prescription',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.description_outlined),
                title: Text('Prescription'),
              ),
            ),
          if (canCancel)
            const PopupMenuItem(
              value: 'cancel',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.cancel_outlined, color: AdminColors.danger),
                title: Text(
                  'Cancel Order',
                  style: TextStyle(color: AdminColors.danger),
                ),
              ),
            ),
        ];
      },
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 54,
              color: AdminColors.textLight,
            ),
            const SizedBox(height: 12),
            const Text(
              'No orders found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AdminColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Try changing your search or filters.',
              style: TextStyle(color: AdminColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order ${order['id']}'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Customer', order['customer']),
                  _detailRow('Phone', order['phone']),
                  _detailRow('Order Date', order['date']),
                  _detailRow('Items', order['items']),
                  _detailRow('Item Count', '${order['itemCount']}'),
                  _detailRow(
                    'Amount',
                    '₹${(order['amount'] as double).toStringAsFixed(0)}',
                  ),
                  _detailRow('Order Status', order['orderStatus']),
                  _detailRow('Payment Status', order['paymentStatus']),
                  _detailRow('Payment Method', order['paymentMethod']),
                  _detailRow(
                    'Prescription',
                    order['prescriptionRequired'] ? 'Required' : 'Not Required',
                  ),
                  _detailRow(
                    'Delivery Partner',
                    order['deliveryPartner'] ?? 'Not Assigned',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showStatusDialog(order);
              },
              child: const Text('Update Status'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AdminColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AdminColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(Map<String, dynamic> order) {
    String selectedStatus = order['orderStatus'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Update ${order['id']}'),
              content: SizedBox(
                width: 400,
                child: DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Order Status'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Processing',
                      child: Text('Processing'),
                    ),
                    DropdownMenuItem(
                      value: 'Pending Prescription',
                      child: Text('Pending Prescription'),
                    ),
                    DropdownMenuItem(
                      value: 'In Shipping',
                      child: Text('In Shipping'),
                    ),
                    DropdownMenuItem(
                      value: 'Out for Delivery',
                      child: Text('Out for Delivery'),
                    ),
                    DropdownMenuItem(
                      value: 'Delivered',
                      child: Text('Delivered'),
                    ),
                    DropdownMenuItem(
                      value: 'Cancelled',
                      child: Text('Cancelled'),
                    ),
                    DropdownMenuItem(
                      value: 'Returned',
                      child: Text('Returned'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedStatus = value;
                      });
                    }
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      order['orderStatus'] = selectedStatus;

                      if (selectedStatus == 'Cancelled') {
                        order['paymentStatus'] = 'Refund Pending';
                      }
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Order status updated successfully.'),
                      ),
                    );
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPrescriptionInfo(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prescription Information'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Order', order['id']),
                _detailRow('Customer', order['customer']),
                _detailRow('Medicine', order['items']),
                _detailRow('Status', 'Pending Verification'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AdminColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AdminColors.warning.withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: AdminColors.warning),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Prescription verification will later be handled through the Doctor Management and prescription verification workflow.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Prescription verification will be connected later.',
                    ),
                  ),
                );
              },
              child: const Text('Review'),
            ),
          ],
        );
      },
    );
  }

  void _cancelOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: Text('Are you sure you want to cancel ${order['id']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Order'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.danger,
              ),
              onPressed: () {
                setState(() {
                  order['orderStatus'] = 'Cancelled';
                  order['paymentStatus'] = 'Refund Pending';
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Order cancelled successfully.'),
                  ),
                );
              },
              child: const Text('Cancel Order'),
            ),
          ],
        );
      },
    );
  }
}

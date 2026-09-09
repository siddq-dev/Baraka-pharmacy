import 'package:flutter/material.dart';

import '../theme/admin_colors.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'CUS001',
      'name': 'Abual',
      'email': 'abual@example.com',
      'phone': '+91 98765 43210',
      'orders': 12,
      'spent': 2450.00,
      'status': 'Active',
      'joined': '12 Aug 2026',
      'lastOrder': '07 Sep 2026',
    },
    {
      'id': 'CUS002',
      'name': 'Mohammed Rahman',
      'email': 'mohammed@example.com',
      'phone': '+91 98765 12345',
      'orders': 8,
      'spent': 1890.00,
      'status': 'Active',
      'joined': '05 Jul 2026',
      'lastOrder': '06 Sep 2026',
    },
    {
      'id': 'CUS003',
      'name': 'Aisha Khan',
      'email': 'aisha@example.com',
      'phone': '+91 91234 56789',
      'orders': 15,
      'spent': 3675.00,
      'status': 'Active',
      'joined': '20 Jun 2026',
      'lastOrder': '05 Sep 2026',
    },
    {
      'id': 'CUS004',
      'name': 'Rahul Kumar',
      'email': 'rahul@example.com',
      'phone': '+91 99887 66554',
      'orders': 4,
      'spent': 780.00,
      'status': 'Inactive',
      'joined': '15 May 2026',
      'lastOrder': '04 Sep 2026',
    },
    {
      'id': 'CUS005',
      'name': 'Fatima Ali',
      'email': 'fatima@example.com',
      'phone': '+91 90000 11223',
      'orders': 21,
      'spent': 5240.00,
      'status': 'Active',
      'joined': '02 Apr 2026',
      'lastOrder': '03 Sep 2026',
    },
    {
      'id': 'CUS006',
      'name': 'Sara Ahmed',
      'email': 'sara@example.com',
      'phone': '+91 91111 22334',
      'orders': 7,
      'spent': 1420.00,
      'status': 'Blocked',
      'joined': '18 Mar 2026',
      'lastOrder': '02 Sep 2026',
    },
    {
      'id': 'CUS007',
      'name': 'Omar Ali',
      'email': 'omar@example.com',
      'phone': '+91 95555 66778',
      'orders': 10,
      'spent': 2860.00,
      'status': 'Active',
      'joined': '10 Feb 2026',
      'lastOrder': '01 Sep 2026',
    },
  ];

  String _statusFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCustomers {
    final query = _searchController.text.trim().toLowerCase();

    return _customers.where((customer) {
      final matchesSearch =
          query.isEmpty ||
          customer['id'].toString().toLowerCase().contains(query) ||
          customer['name'].toString().toLowerCase().contains(query) ||
          customer['email'].toString().toLowerCase().contains(query) ||
          customer['phone'].toString().toLowerCase().contains(query);

      final matchesStatus =
          _statusFilter == 'All' ||
          customer['status'].toString() == _statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  int get _totalCustomers => _customers.length;

  int get _activeCustomers =>
      _customers.where((customer) => customer['status'] == 'Active').length;

  int get _inactiveCustomers =>
      _customers.where((customer) => customer['status'] == 'Inactive').length;

  int get _blockedCustomers =>
      _customers.where((customer) => customer['status'] == 'Blocked').length;

  double get _totalSpent => _customers.fold(
    0,
    (sum, customer) => sum + (customer['spent'] as double),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 24),
                  _buildSummaryCards(isMobile),
                  const SizedBox(height: 24),
                  _buildFilters(isMobile),
                  const SizedBox(height: 16),
                  if (isMobile) _buildMobileList() else _buildDesktopTable(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customers',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.w700,
                  color: AdminColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manage customer accounts, activity and order history.',
                style: TextStyle(
                  fontSize: 14,
                  color: AdminColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile)
          OutlinedButton.icon(
            onPressed: _showExportPlaceholder,
            icon: const Icon(Icons.download_outlined),
            label: const Text('Export'),
          ),
      ],
    );
  }

  Widget _buildSummaryCards(bool isMobile) {
    final cards = [
      {
        'title': 'Total Customers',
        'value': _totalCustomers.toString(),
        'icon': Icons.people_outline,
        'color': AdminColors.primary,
      },
      {
        'title': 'Active Customers',
        'value': _activeCustomers.toString(),
        'icon': Icons.person_outline,
        'color': AdminColors.success,
      },
      {
        'title': 'Inactive',
        'value': _inactiveCustomers.toString(),
        'icon': Icons.person_off_outlined,
        'color': AdminColors.warning,
      },
      {
        'title': 'Blocked',
        'value': _blockedCustomers.toString(),
        'icon': Icons.block_outlined,
        'color': AdminColors.danger,
      },
      {
        'title': 'Total Customer Spend',
        'value': '₹${_totalSpent.toStringAsFixed(0)}',
        'icon': Icons.currency_rupee,
        'color': AdminColors.info,
      },
    ];

    if (isMobile) {
      return Column(
        children: cards
            .map(
              (card) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _summaryCard(card),
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: cards
          .map(
            (card) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _summaryCard(card),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _summaryCard(Map<String, dynamic> card) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (card['color'] as Color).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                card['icon'] as IconData,
                color: card['color'] as Color,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['title'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    card['value'] as String,
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

  Widget _buildFilters(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _searchField(),
          const SizedBox(height: 12),
          _statusDropdown(),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _searchField()),
        const SizedBox(width: 12),
        SizedBox(width: 190, child: _statusDropdown()),
      ],
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: const InputDecoration(
        hintText: 'Search by customer, email, phone or ID...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _statusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _statusFilter,
      decoration: const InputDecoration(labelText: 'Status'),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Statuses')),
        DropdownMenuItem(value: 'Active', child: Text('Active')),
        DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
        DropdownMenuItem(value: 'Blocked', child: Text('Blocked')),
      ],
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _statusFilter = value;
        });
      },
    );
  }

  Widget _buildDesktopTable() {
    final customers = _filteredCustomers;

    return Card(
      child: customers.isEmpty
          ? _emptyState()
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                headingRowHeight: 54,
                dataRowMinHeight: 68,
                dataRowMaxHeight: 76,
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AdminColors.textPrimary,
                ),
                columns: const [
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Contact')),
                  DataColumn(label: Text('Orders')),
                  DataColumn(label: Text('Total Spent')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Last Order')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: customers
                    .map(
                      (customer) => DataRow(
                        cells: [
                          DataCell(_customerIdentity(customer)),
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer['email'],
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  customer['phone'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AdminColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              customer['orders'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '₹${(customer['spent'] as double).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(_statusBadge(customer['status'])),
                          DataCell(
                            Text(
                              customer['lastOrder'],
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          DataCell(_actionMenu(customer)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }

  Widget _buildMobileList() {
    final customers = _filteredCustomers;

    if (customers.isEmpty) {
      return Card(child: _emptyState());
    }

    return Column(
      children: customers
          .map(
            (customer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _avatar(customer['name']),
                          const SizedBox(width: 12),
                          Expanded(child: _customerIdentity(customer)),
                          _statusBadge(customer['status']),
                        ],
                      ),
                      const Divider(height: 28),
                      _infoRow(Icons.email_outlined, customer['email']),
                      const SizedBox(height: 8),
                      _infoRow(Icons.phone_outlined, customer['phone']),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _mobileMetric(
                              'Orders',
                              customer['orders'].toString(),
                            ),
                          ),
                          Expanded(
                            child: _mobileMetric(
                              'Spent',
                              '₹${(customer['spent'] as double).toStringAsFixed(0)}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Last order: ${customer['lastOrder']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AdminColors.textSecondary,
                              ),
                            ),
                          ),
                          _actionMenu(customer),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _customerIdentity(Map<String, dynamic> customer) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _avatar(customer['name']),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer['name'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AdminColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                customer['id'],
                style: const TextStyle(
                  fontSize: 11,
                  color: AdminColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatar(String name) {
    final initials = name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: 20,
      backgroundColor: AdminColors.primary.withValues(alpha: 0.10),
      child: Text(
        initials,
        style: const TextStyle(
          color: AdminColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'Active':
        color = AdminColors.success;
        break;
      case 'Inactive':
        color = AdminColors.warning;
        break;
      case 'Blocked':
        color = AdminColors.danger;
        break;
      default:
        color = AdminColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _actionMenu(Map<String, dynamic> customer) {
    return PopupMenuButton<String>(
      tooltip: 'Customer actions',
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showCustomerDetails(customer);
            break;
          case 'orders':
            _showOrdersPlaceholder(customer);
            break;
          case 'toggle':
            _toggleCustomerStatus(customer);
            break;
          case 'delete':
            _confirmDelete(customer);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.visibility_outlined),
            title: Text('View Details'),
          ),
        ),
        const PopupMenuItem(
          value: 'orders',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.receipt_long_outlined),
            title: Text('View Orders'),
          ),
        ),
        PopupMenuItem(
          value: 'toggle',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_off_outlined),
            title: Text(
              customer['status'] == 'Active' ? 'Deactivate' : 'Activate',
            ),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline, color: AdminColors.danger),
            title: Text(
              'Delete Customer',
              style: TextStyle(color: AdminColors.danger),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        const SizedBox(width: 2),
        Icon(icon, size: 17, color: AdminColors.textSecondary),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AdminColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mobileMetric(String label, String value) {
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
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AdminColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 48, color: AdminColors.textLight),
            const SizedBox(height: 12),
            const Text(
              'No customers found',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AdminColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Try changing your search or filters.',
              style: TextStyle(fontSize: 13, color: AdminColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomerDetails(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              _avatar(customer['name']),
              const SizedBox(width: 12),
              Expanded(child: Text(customer['name'])),
            ],
          ),
          content: SizedBox(
            width: 430,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _detailRow('Customer ID', customer['id']),
                _detailRow('Email', customer['email']),
                _detailRow('Phone', customer['phone']),
                _detailRow('Orders', customer['orders'].toString()),
                _detailRow(
                  'Total Spent',
                  '₹${(customer['spent'] as double).toStringAsFixed(0)}',
                ),
                _detailRow('Status', customer['status']),
                _detailRow('Joined', customer['joined']),
                _detailRow('Last Order', customer['lastOrder']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AdminColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AdminColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrdersPlaceholder(Map<String, dynamic> customer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Customer order history for ${customer['name']} will be connected to Firebase later.',
        ),
      ),
    );
  }

  void _showExportPlaceholder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer export will be connected later.')),
    );
  }

  void _toggleCustomerStatus(Map<String, dynamic> customer) {
    setState(() {
      if (customer['status'] == 'Active') {
        customer['status'] = 'Inactive';
      } else {
        customer['status'] = 'Active';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${customer['name']} is now ${customer['status']}.'),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Customer'),
          content: Text(
            'Are you sure you want to delete ${customer['name']}? '
            'This action will later remove the customer from Firebase.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AdminColors.danger,
              ),
              onPressed: () {
                setState(() {
                  _customers.remove(customer);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Customer deleted successfully.'),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

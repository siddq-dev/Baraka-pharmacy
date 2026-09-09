import 'package:flutter/material.dart';

import '../theme/admin_colors.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _selectedStockStatus = 'All';

  final List<Map<String, dynamic>> _inventory = [
    {
      'id': 'INV001',
      'productId': 'PRD001',
      'product': 'Paracetamol 500mg',
      'category': 'Medicines',
      'stock': 120,
      'minStock': 20,
      'unit': 'strips',
      'status': 'Active',
      'lastUpdated': 'Today, 10:30 AM',
    },
    {
      'id': 'INV002',
      'productId': 'PRD002',
      'product': 'Vitamin C 500mg',
      'category': 'Vitamins',
      'stock': 85,
      'minStock': 20,
      'unit': 'bottles',
      'status': 'Active',
      'lastUpdated': 'Today, 09:15 AM',
    },
    {
      'id': 'INV003',
      'productId': 'PRD003',
      'product': 'First Aid Kit',
      'category': 'Personal Care',
      'stock': 42,
      'minStock': 10,
      'unit': 'kits',
      'status': 'Active',
      'lastUpdated': 'Yesterday, 06:20 PM',
    },
    {
      'id': 'INV004',
      'productId': 'PRD004',
      'product': 'Amoxicillin 500mg',
      'category': 'Antibiotics',
      'stock': 18,
      'minStock': 25,
      'unit': 'strips',
      'status': 'Active',
      'lastUpdated': 'Today, 08:45 AM',
    },
    {
      'id': 'INV005',
      'productId': 'PRD005',
      'product': 'Cough Syrup',
      'category': 'Medicines',
      'stock': 7,
      'minStock': 15,
      'unit': 'bottles',
      'status': 'Active',
      'lastUpdated': 'Today, 07:30 AM',
    },
    {
      'id': 'INV006',
      'productId': 'PRD006',
      'product': 'Baby Lotion',
      'category': 'Baby Care',
      'stock': 0,
      'minStock': 10,
      'unit': 'bottles',
      'status': 'Inactive',
      'lastUpdated': '05 Sep 2026',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _totalUnits {
    return _inventory.fold(0, (total, item) => total + (item['stock'] as int));
  }

  int get _lowStockCount {
    return _inventory.where((item) {
      final stock = item['stock'] as int;
      final minimum = item['minStock'] as int;
      return stock > 0 && stock <= minimum;
    }).length;
  }

  int get _outOfStockCount {
    return _inventory.where((item) => item['stock'] == 0).length;
  }

  int get _activeItems {
    return _inventory.where((item) => item['status'] == 'Active').length;
  }

  List<Map<String, dynamic>> get _filteredInventory {
    final query = _searchController.text.trim().toLowerCase();

    return _inventory.where((item) {
      final stock = item['stock'] as int;
      final minimum = item['minStock'] as int;

      final matchesSearch =
          query.isEmpty ||
          item['product'].toString().toLowerCase().contains(query) ||
          item['productId'].toString().toLowerCase().contains(query) ||
          item['category'].toString().toLowerCase().contains(query);

      final matchesCategory =
          _selectedCategory == 'All' || item['category'] == _selectedCategory;

      bool matchesStockStatus = true;

      switch (_selectedStockStatus) {
        case 'In Stock':
          matchesStockStatus = stock > minimum;
          break;
        case 'Low Stock':
          matchesStockStatus = stock > 0 && stock <= minimum;
          break;
        case 'Out of Stock':
          matchesStockStatus = stock == 0;
          break;
      }

      return matchesSearch && matchesCategory && matchesStockStatus;
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
                  _buildInventorySection(isMobile),
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
          'Inventory',
          style: TextStyle(
            fontSize: isMobile ? 24 : 30,
            fontWeight: FontWeight.w700,
            color: AdminColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Monitor stock levels, adjust inventory and manage stock alerts.',
          style: TextStyle(fontSize: 14, color: AdminColors.textSecondary),
        ),
        const SizedBox(height: 18),
        Align(
          alignment: isMobile ? Alignment.centerLeft : Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _showStockAdjustmentDialog,
            icon: const Icon(Icons.add_box_outlined),
            label: const Text('Adjust Stock'),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(bool isMobile) {
    final cards = [
      _summaryCard(
        title: 'Total Products',
        value: '${_inventory.length}',
        icon: Icons.inventory_2_outlined,
        iconColor: AdminColors.info,
      ),
      _summaryCard(
        title: 'Total Units',
        value: '$_totalUnits',
        icon: Icons.layers_outlined,
        iconColor: AdminColors.primary,
      ),
      _summaryCard(
        title: 'Low Stock',
        value: '$_lowStockCount',
        icon: Icons.warning_amber_outlined,
        iconColor: AdminColors.warning,
      ),
      _summaryCard(
        title: 'Out of Stock',
        value: '$_outOfStockCount',
        icon: Icons.remove_shopping_cart_outlined,
        iconColor: AdminColors.danger,
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
                      fontSize: 22,
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

  Widget _buildInventorySection(bool isMobile) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 14 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              const Text(
                'Inventory Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AdminColors.textPrimary,
                ),
              ),
            if (!isMobile) const SizedBox(height: 18),
            _buildFilters(isMobile),
            const SizedBox(height: 18),
            if (isMobile)
              _buildMobileInventoryList()
            else
              _buildDesktopInventoryTable(),
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
              hintText: 'Search inventory...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _categoryDropdown()),
              const SizedBox(width: 10),
              Expanded(child: _stockStatusDropdown()),
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
              hintText: 'Search by product name, ID or category...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 14),
        SizedBox(width: 180, child: _categoryDropdown()),
        const SizedBox(width: 14),
        SizedBox(width: 170, child: _stockStatusDropdown()),
      ],
    );
  }

  Widget _categoryDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      decoration: const InputDecoration(labelText: 'Category'),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Categories')),
        DropdownMenuItem(value: 'Medicines', child: Text('Medicines')),
        DropdownMenuItem(value: 'Vitamins', child: Text('Vitamins')),
        DropdownMenuItem(value: 'Personal Care', child: Text('Personal Care')),
        DropdownMenuItem(value: 'Antibiotics', child: Text('Antibiotics')),
        DropdownMenuItem(value: 'Baby Care', child: Text('Baby Care')),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }

  Widget _stockStatusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedStockStatus,
      decoration: const InputDecoration(labelText: 'Stock Status'),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Stock')),
        DropdownMenuItem(value: 'In Stock', child: Text('In Stock')),
        DropdownMenuItem(value: 'Low Stock', child: Text('Low Stock')),
        DropdownMenuItem(value: 'Out of Stock', child: Text('Out of Stock')),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedStockStatus = value;
        });
      },
    );
  }

  Widget _buildDesktopInventoryTable() {
    final items = _filteredInventory;

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1050,
        child: DataTable(
          columnSpacing: 20,
          headingRowHeight: 48,
          dataRowMinHeight: 68,
          dataRowMaxHeight: 76,
          columns: const [
            DataColumn(label: Text('Product')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Minimum')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Last Updated')),
            DataColumn(label: Text('Actions')),
          ],
          rows: items.map((item) {
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 190,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['product'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item['productId'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(Text(item['category'])),
                DataCell(
                  _stockBadge(item['stock'], item['minStock'], item['unit']),
                ),
                DataCell(Text('${item['minStock']} ${item['unit']}')),
                DataCell(_statusBadge(item['status'])),
                DataCell(
                  Text(
                    item['lastUpdated'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                ),
                DataCell(_actionMenu(item)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileInventoryList() {
    final items = _filteredInventory;

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: items.map((item) {
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
                          item['product'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item['productId']} • ${item['category']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(item['status']),
                  _actionMenu(item),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _mobileInfo(
                      'Current Stock',
                      '${item['stock']} ${item['unit']}',
                    ),
                  ),
                  Expanded(
                    child: _mobileInfo(
                      'Minimum',
                      '${item['minStock']} ${item['unit']}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _mobileInfo('Last Updated', item['lastUpdated']),
                  ),
                  Expanded(child: _stockLabel(item['stock'], item['minStock'])),
                ],
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

  Widget _stockLabel(int stock, int minimum) {
    Color color;
    String text;

    if (stock == 0) {
      color = AdminColors.danger;
      text = 'Out of stock';
    } else if (stock <= minimum) {
      color = AdminColors.warning;
      text = 'Low stock';
    } else {
      color = AdminColors.success;
      text = 'Healthy stock';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stock Level',
          style: TextStyle(fontSize: 11, color: AdminColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _stockBadge(int stock, int minimum, String unit) {
    late Color color;
    late String text;

    if (stock == 0) {
      color = AdminColors.danger;
      text = 'Out of stock';
    } else if (stock <= minimum) {
      color = AdminColors.warning;
      text = 'Low: $stock';
    } else {
      color = AdminColors.success;
      text = '$stock $unit';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isActive = status == 'Active';
    final color = isActive ? AdminColors.success : AdminColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _actionMenu(Map<String, dynamic> item) {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showInventoryDetails(item);
            break;
          case 'adjust':
            _showStockAdjustmentDialog(item: item);
            break;
          case 'history':
            _showStockHistory(item);
            break;
          case 'toggle':
            _toggleStatus(item);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.visibility_outlined),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'adjust',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.add_box_outlined),
            title: Text('Adjust Stock'),
          ),
        ),
        const PopupMenuItem(
          value: 'history',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.history),
            title: Text('Stock History'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'toggle',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.power_settings_new),
            title: Text('Activate / Deactivate'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 54,
              color: AdminColors.textLight,
            ),
            const SizedBox(height: 12),
            const Text(
              'No inventory items found',
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

  void _showInventoryDetails(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Inventory Details'),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Inventory ID', item['id']),
                _detailRow('Product ID', item['productId']),
                _detailRow('Product', item['product']),
                _detailRow('Category', item['category']),
                _detailRow('Current Stock', '${item['stock']} ${item['unit']}'),
                _detailRow(
                  'Minimum Stock',
                  '${item['minStock']} ${item['unit']}',
                ),
                _detailRow('Status', item['status']),
                _detailRow('Last Updated', item['lastUpdated']),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
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

  void _showStockAdjustmentDialog({Map<String, dynamic>? item}) {
    final quantityController = TextEditingController();

    String? selectedProduct = item?['productId']?.toString();

    String adjustmentType = 'Add Stock';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                item == null
                    ? 'Adjust Stock'
                    : 'Adjust Stock • ${item['product']}',
              ),
              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item == null)
                      DropdownButtonFormField<String>(
                        initialValue: selectedProduct,
                        decoration: const InputDecoration(labelText: 'Product'),
                        items: _inventory.map((inventoryItem) {
                          return DropdownMenuItem<String>(
                            value: inventoryItem['productId'],
                            child: Text(
                              inventoryItem['product'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedProduct = value;
                          });
                        },
                      ),
                    if (item == null) const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: adjustmentType,
                      decoration: const InputDecoration(
                        labelText: 'Adjustment Type',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Add Stock',
                          child: Text('Add Stock'),
                        ),
                        DropdownMenuItem(
                          value: 'Remove Stock',
                          child: Text('Remove Stock'),
                        ),
                        DropdownMenuItem(
                          value: 'Set Stock',
                          child: Text('Set Exact Stock'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            adjustmentType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        hintText: 'Enter quantity',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final quantity = int.tryParse(
                      quantityController.text.trim(),
                    );

                    if (quantity == null || quantity < 0) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid quantity.'),
                        ),
                      );
                      return;
                    }

                    Map<String, dynamic>? targetItem = item;

                    if (targetItem == null && selectedProduct != null) {
                      for (final inventoryItem in _inventory) {
                        if (inventoryItem['productId'] == selectedProduct) {
                          targetItem = inventoryItem;
                          break;
                        }
                      }
                    }

                    if (targetItem == null) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a product.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      final currentStock = targetItem!['stock'] as int;

                      if (adjustmentType == 'Add Stock') {
                        targetItem['stock'] = currentStock + quantity;
                      } else if (adjustmentType == 'Remove Stock') {
                        targetItem['stock'] = (currentStock - quantity).clamp(
                          0,
                          999999,
                        );
                      } else {
                        targetItem['stock'] = quantity;
                      }

                      targetItem['lastUpdated'] = 'Just now';
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Stock updated successfully.'),
                      ),
                    );
                  },
                  child: const Text('Update Stock'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showStockHistory(Map<String, dynamic> item) {
    final history = [
      {
        'type': 'Stock Added',
        'quantity': '+50',
        'date': 'Today, 10:30 AM',
        'user': 'Super Admin',
      },
      {
        'type': 'Order Deduction',
        'quantity': '-12',
        'date': 'Today, 09:20 AM',
        'user': 'System',
      },
      {
        'type': 'Stock Added',
        'quantity': '+30',
        'date': 'Yesterday, 05:10 PM',
        'user': 'Inventory Manager',
      },
      {
        'type': 'Stock Adjustment',
        'quantity': '+10',
        'date': '05 Sep 2026',
        'user': 'Super Admin',
      },
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Stock History • ${item['product']}'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: history.map((entry) {
                final isPositive = entry['quantity'].toString().startsWith('+');

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        (isPositive ? AdminColors.success : AdminColors.warning)
                            .withValues(alpha: 0.10),
                    child: Icon(
                      isPositive ? Icons.add : Icons.remove,
                      size: 18,
                      color: isPositive
                          ? AdminColors.success
                          : AdminColors.warning,
                    ),
                  ),
                  title: Text(
                    entry['type'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${entry['date']} • ${entry['user']}'),
                  trailing: Text(
                    entry['quantity'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isPositive
                          ? AdminColors.success
                          : AdminColors.warning,
                    ),
                  ),
                );
              }).toList(),
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

  void _toggleStatus(Map<String, dynamic> item) {
    final isActive = item['status'] == 'Active';

    setState(() {
      item['status'] = isActive ? 'Inactive' : 'Active';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isActive
              ? '${item['product']} deactivated.'
              : '${item['product']} activated.',
        ),
      ),
    );
  }
}

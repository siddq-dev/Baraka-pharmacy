import 'package:flutter/material.dart';

import '../theme/admin_colors.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  final List<Map<String, dynamic>> _products = [
    {
      'id': 'PRD001',
      'name': 'Paracetamol 500mg',
      'category': 'Medicines',
      'price': 25.0,
      'stock': 120,
      'status': 'Active',
      'prescriptionRequired': false,
    },
    {
      'id': 'PRD002',
      'name': 'Vitamin C 500mg',
      'category': 'Vitamins',
      'price': 180.0,
      'stock': 85,
      'status': 'Active',
      'prescriptionRequired': false,
    },
    {
      'id': 'PRD003',
      'name': 'First Aid Kit',
      'category': 'Personal Care',
      'price': 299.0,
      'stock': 42,
      'status': 'Active',
      'prescriptionRequired': false,
    },
    {
      'id': 'PRD004',
      'name': 'Amoxicillin 500mg',
      'category': 'Antibiotics',
      'price': 145.0,
      'stock': 18,
      'status': 'Active',
      'prescriptionRequired': true,
    },
    {
      'id': 'PRD005',
      'name': 'Cough Syrup',
      'category': 'Medicines',
      'price': 95.0,
      'stock': 7,
      'status': 'Active',
      'prescriptionRequired': false,
    },
    {
      'id': 'PRD006',
      'name': 'Baby Lotion',
      'category': 'Baby Care',
      'price': 220.0,
      'stock': 0,
      'status': 'Inactive',
      'prescriptionRequired': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();

    return _products.where((product) {
      final matchesSearch =
          query.isEmpty ||
          product['name'].toString().toLowerCase().contains(query) ||
          product['id'].toString().toLowerCase().contains(query) ||
          product['category'].toString().toLowerCase().contains(query);

      final matchesCategory =
          _selectedCategory == 'All' ||
          product['category'] == _selectedCategory;

      final matchesStatus =
          _selectedStatus == 'All' || product['status'] == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  int get _activeProducts =>
      _products.where((product) => product['status'] == 'Active').length;

  int get _inactiveProducts =>
      _products.where((product) => product['status'] == 'Inactive').length;

  int get _lowStockProducts => _products
      .where((product) => product['stock'] > 0 && product['stock'] <= 10)
      .length;

  int get _outOfStockProducts =>
      _products.where((product) => product['stock'] == 0).length;

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
                  _buildProductSection(isMobile),
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
          'Product Management',
          style: TextStyle(
            fontSize: isMobile ? 24 : 30,
            fontWeight: FontWeight.w700,
            color: AdminColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Manage pharmacy products, categories, pricing and availability.',
          style: TextStyle(fontSize: 14, color: AdminColors.textSecondary),
        ),
        const SizedBox(height: 18),
        Align(
          alignment: isMobile ? Alignment.centerLeft : Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _showAddProductDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(bool isMobile) {
    final cards = [
      _summaryCard(
        title: 'Total Products',
        value: '${_products.length}',
        icon: Icons.inventory_2_outlined,
        iconColor: AdminColors.info,
      ),
      _summaryCard(
        title: 'Active Products',
        value: '$_activeProducts',
        icon: Icons.check_circle_outline,
        iconColor: AdminColors.success,
      ),
      _summaryCard(
        title: 'Low Stock',
        value: '$_lowStockProducts',
        icon: Icons.warning_amber_outlined,
        iconColor: AdminColors.warning,
      ),
      _summaryCard(
        title: 'Out of Stock',
        value: '$_outOfStockProducts',
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

  Widget _buildProductSection(bool isMobile) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 14 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              const Text(
                'Products',
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
              _buildMobileProductList()
            else
              _buildDesktopProductTable(),
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
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _categoryDropdown()),
              const SizedBox(width: 10),
              Expanded(child: _statusDropdown()),
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
        SizedBox(width: 160, child: _statusDropdown()),
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

  Widget _statusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedStatus,
      decoration: const InputDecoration(labelText: 'Status'),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Status')),
        DropdownMenuItem(value: 'Active', child: Text('Active')),
        DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
      ],
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _selectedStatus = value;
        });
      },
    );
  }

  Widget _buildDesktopProductTable() {
    final products = _filteredProducts;

    if (products.isEmpty) {
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
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Prescription')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: products.map((product) {
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
                          product['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          product['id'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(Text(product['category'])),
                DataCell(
                  Text(
                    '₹${product['price'].toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(_stockBadge(product['stock'])),
                DataCell(
                  _prescriptionBadge(product['prescriptionRequired'] as bool),
                ),
                DataCell(_statusBadge(product['status'])),
                DataCell(_actionMenu(product)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileProductList() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: products.map((product) {
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
                          product['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product['id']} • ${product['category']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(product['status']),
                  _actionMenu(product),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _mobileInfo(
                      'Price',
                      '₹${product['price'].toStringAsFixed(0)}',
                    ),
                  ),
                  Expanded(
                    child: _mobileInfo('Stock', '${product['stock']} units'),
                  ),
                  Expanded(
                    child: _mobileInfo(
                      'Prescription',
                      product['prescriptionRequired'] ? 'Required' : 'No',
                    ),
                  ),
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

  Widget _stockBadge(int stock) {
    late Color color;
    late String text;

    if (stock == 0) {
      color = AdminColors.danger;
      text = 'Out of stock';
    } else if (stock <= 10) {
      color = AdminColors.warning;
      text = 'Low: $stock';
    } else {
      color = AdminColors.success;
      text = '$stock units';
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

  Widget _prescriptionBadge(bool required) {
    return Text(
      required ? 'Required' : 'Not Required',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: required ? AdminColors.warning : AdminColors.textSecondary,
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

  Widget _actionMenu(Map<String, dynamic> product) {
    final isActive = product['status'] == 'Active';

    return PopupMenuButton<String>(
      tooltip: 'Actions',
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showProductDetails(product);
            break;
          case 'edit':
            _showEditProductDialog(product);
            break;
          case 'toggle':
            _toggleProductStatus(product);
            break;
          case 'delete':
            _deleteProduct(product);
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
          value: 'edit',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem(
          value: 'toggle',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
            ),
            title: Text(isActive ? 'Deactivate' : 'Activate'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline, color: AdminColors.danger),
            title: Text('Delete', style: TextStyle(color: AdminColors.danger)),
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
            Icon(
              Icons.inventory_2_outlined,
              size: 54,
              color: AdminColors.textLight,
            ),
            const SizedBox(height: 12),
            const Text(
              'No products found',
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

  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Product Details'),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Product ID', product['id']),
                _detailRow('Product Name', product['name']),
                _detailRow('Category', product['category']),
                _detailRow('Price', '₹${product['price'].toStringAsFixed(0)}'),
                _detailRow('Stock', '${product['stock']} units'),
                _detailRow('Status', product['status']),
                _detailRow(
                  'Prescription',
                  product['prescriptionRequired'] ? 'Required' : 'Not Required',
                ),
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

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    String category = 'Medicines';
    bool prescriptionRequired = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Product'),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Medicines',
                            child: Text('Medicines'),
                          ),
                          DropdownMenuItem(
                            value: 'Vitamins',
                            child: Text('Vitamins'),
                          ),
                          DropdownMenuItem(
                            value: 'Personal Care',
                            child: Text('Personal Care'),
                          ),
                          DropdownMenuItem(
                            value: 'Antibiotics',
                            child: Text('Antibiotics'),
                          ),
                          DropdownMenuItem(
                            value: 'Baby Care',
                            child: Text('Baby Care'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              category = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          prefixText: '₹ ',
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Initial Stock',
                        ),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Prescription Required'),
                        value: prescriptionRequired,
                        onChanged: (value) {
                          setDialogState(() {
                            prescriptionRequired = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price = double.tryParse(priceController.text.trim());
                    final stock = int.tryParse(stockController.text.trim());

                    if (name.isEmpty || price == null || stock == null) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter valid product details.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _products.add({
                        'id':
                            'PRD${(_products.length + 1).toString().padLeft(3, '0')}',
                        'name': name,
                        'category': category,
                        'price': price,
                        'stock': stock,
                        'status': 'Active',
                        'prescriptionRequired': prescriptionRequired,
                      });
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Product added successfully.'),
                      ),
                    );
                  },
                  child: const Text('Add Product'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditProductDialog(Map<String, dynamic> product) {
    final nameController = TextEditingController(
      text: product['name'].toString(),
    );
    final priceController = TextEditingController(
      text: product['price'].toString(),
    );
    final stockController = TextEditingController(
      text: product['stock'].toString(),
    );

    String category = product['category'];
    bool prescriptionRequired = product['prescriptionRequired'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Product'),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Medicines',
                            child: Text('Medicines'),
                          ),
                          DropdownMenuItem(
                            value: 'Vitamins',
                            child: Text('Vitamins'),
                          ),
                          DropdownMenuItem(
                            value: 'Personal Care',
                            child: Text('Personal Care'),
                          ),
                          DropdownMenuItem(
                            value: 'Antibiotics',
                            child: Text('Antibiotics'),
                          ),
                          DropdownMenuItem(
                            value: 'Baby Care',
                            child: Text('Baby Care'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              category = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          prefixText: '₹ ',
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Stock'),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Prescription Required'),
                        value: prescriptionRequired,
                        onChanged: (value) {
                          setDialogState(() {
                            prescriptionRequired = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price = double.tryParse(priceController.text.trim());
                    final stock = int.tryParse(stockController.text.trim());

                    if (name.isEmpty || price == null || stock == null) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter valid product details.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      product['name'] = name;
                      product['category'] = category;
                      product['price'] = price;
                      product['stock'] = stock;
                      product['prescriptionRequired'] = prescriptionRequired;
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Product updated successfully.'),
                      ),
                    );
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleProductStatus(Map<String, dynamic> product) {
    final isActive = product['status'] == 'Active';

    setState(() {
      product['status'] = isActive ? 'Inactive' : 'Active';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isActive ? 'Product deactivated.' : 'Product activated.'),
      ),
    );
  }

  void _deleteProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete "${product['name']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.danger,
              ),
              onPressed: () {
                setState(() {
                  _products.remove(product);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Product deleted successfully.'),
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

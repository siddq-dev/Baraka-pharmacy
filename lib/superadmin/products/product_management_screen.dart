import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/admin_colors.dart';
import '../../routes/app_routes.dart';

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

  // [Firestore Integration]: Hardcoded _products list removed in favor of live Firestore streaming.

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // [Firestore Integration]: Filter live products mapped from Firestore QueryDocumentSnapshots
  List<Map<String, dynamic>> _getFilteredProducts(
    List<Map<String, dynamic>> products,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    return products.where((product) {
      final matchesSearch =
          query.isEmpty ||
          product['name'].toString().toLowerCase().contains(query) ||
          product['id'].toString().toLowerCase().contains(query) ||
          (product['productId']?.toString().toLowerCase().contains(query) ??
              false) ||
          product['category'].toString().toLowerCase().contains(query);

      final matchesCategory =
          _selectedCategory == 'All' ||
          product['category'] == _selectedCategory;

      final matchesStatus =
          _selectedStatus == 'All' || product['status'] == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  // [Firestore Integration]: Derive active count from live product stock
  int _getActiveProducts(List<Map<String, dynamic>> products) =>
      products.where((product) => product['status'] == 'Active').length;

  // [Firestore Integration]: Calculate low stock count (1..10) from live product quantity
  int _getLowStockProducts(List<Map<String, dynamic>> products) => products
      .where((product) => product['stock'] > 0 && product['stock'] <= 10)
      .length;

  // [Firestore Integration]: Calculate out of stock count (0) from live product quantity
  int _getOutOfStockProducts(List<Map<String, dynamic>> products) =>
      products.where((product) => product['stock'] == 0).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: SafeArea(
        // [Firestore Integration]: Real-time StreamBuilder listening to the 'products' collection
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            // [Firestore Integration]: Explicitly handle loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // [Firestore Integration]: Explicitly handle error state using _buildEmptyState container
            if (snapshot.hasError) {
              return Center(
                child: _buildEmptyState(
                  title: 'Error loading products',
                  subtitle: snapshot.error.toString(),
                ),
              );
            }

            // [Firestore Integration]: Map Firestore docs to the Map shape expected by the UI
            final List<Map<String, dynamic>> products =
                (snapshot.data?.docs ?? []).map((doc) {
                  final data = doc.data();
                  final int quantity =
                      (data['quantity'] as num?)?.toInt() ?? 0;
                  final double price =
                      (data['price'] as num?)?.toDouble() ?? 0.0;
                  final double salePrice =
                      (data['salePrice'] as num?)?.toDouble() ?? 0.0;
                  final String medicineName =
                      data['medicineName'] as String? ?? '';
                  final String type = data['type'] as String? ?? '';
                  final String productId = data['productId'] as String? ?? '';

                  return <String, dynamic>{
                    'id': doc.id,
                    'productId': productId,
                    'name': medicineName,
                    'category': type, // Mapped from 'type'
                    'price': price,
                    'salePrice': salePrice,
                    'stock': quantity, // Mapped from 'quantity'
                    'status': quantity > 0 ? 'Active' : 'Inactive', // Derived status
                    'prescriptionRequired': false, // Defaulted to false
                    'brandName': data['brandName'] as String? ?? '',
                    'chemicalName': data['chemicalName'] as String? ?? '',
                    'description': data['description'] as String? ?? '',
                    'location': data['location'] as String? ?? '',
                    'imageUrls': _extractImageUrls(
                      data['imageUrls'] ?? data['imageUrl'],
                    ),
                  };
                }).toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 800;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(isMobile),
                      const SizedBox(height: 24),
                      _buildSummaryCards(isMobile, products),
                      const SizedBox(height: 24),
                      _buildProductSection(isMobile, products),
                    ],
                  ),
                );
              },
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
            onPressed: () {
              context.push(AppRoutes.addproduct);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(
    bool isMobile,
    List<Map<String, dynamic>> products,
  ) {
    final cards = [
      _summaryCard(
        title: 'Total Products',
        value: '${products.length}',
        icon: Icons.inventory_2_outlined,
        iconColor: AdminColors.info,
      ),
      _summaryCard(
        title: 'Active Products',
        value: '${_getActiveProducts(products)}',
        icon: Icons.check_circle_outline,
        iconColor: AdminColors.success,
      ),
      _summaryCard(
        title: 'Low Stock',
        value: '${_getLowStockProducts(products)}',
        icon: Icons.warning_amber_outlined,
        iconColor: AdminColors.warning,
      ),
      _summaryCard(
        title: 'Out of Stock',
        value: '${_getOutOfStockProducts(products)}',
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

  Widget _buildProductSection(
    bool isMobile,
    List<Map<String, dynamic>> products,
  ) {
    final filtered = _getFilteredProducts(products);

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
            _buildFilters(isMobile, products),
            const SizedBox(height: 18),
            if (isMobile)
              _buildMobileProductList(filtered)
            else
              _buildDesktopProductTable(filtered),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(bool isMobile, List<Map<String, dynamic>> products) {
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
              Expanded(child: _categoryDropdown(products)),
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
        SizedBox(width: 180, child: _categoryDropdown(products)),
        const SizedBox(width: 14),
        SizedBox(width: 160, child: _statusDropdown()),
      ],
    );
  }

  // [Firestore Integration]: Category dropdown built dynamically from distinct 'type' values in live snapshot
  Widget _categoryDropdown(List<Map<String, dynamic>> products) {
    final Set<String> distinctCategories = products
        .map((p) => (p['category'] ?? '').toString().trim())
        .where((cat) => cat.isNotEmpty)
        .toSet();

    final List<String> categories = [
      'All',
      ...distinctCategories.toList()..sort(),
    ];
    final String selectedValue =
        categories.contains(_selectedCategory) ? _selectedCategory : 'All';

    return DropdownButtonFormField<String>(
      key: ValueKey('category_$selectedValue'),
      initialValue: selectedValue,
      decoration: const InputDecoration(labelText: 'Category'),
      items: categories.map((cat) {
        return DropdownMenuItem<String>(
          value: cat,
          child: Text(cat == 'All' ? 'All Categories' : cat),
        );
      }).toList(),
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
      key: ValueKey('status_$_selectedStatus'),
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

  Widget _buildDesktopProductTable(List<Map<String, dynamic>> products) {
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
            // Display custom productId if present, else fallback to Firestore document id
            final String displayId =
                (product['productId'] as String? ?? '').isNotEmpty
                    ? product['productId'] as String
                    : product['id'] as String;

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
                          displayId,
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
                    '₹${(product['price'] as double).toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(_stockBadge(product['stock'] as int)),
                DataCell(
                  _prescriptionBadge(product['prescriptionRequired'] as bool),
                ),
                DataCell(_statusBadge(product['status'] as String)),
                DataCell(_actionMenu(product)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileProductList(List<Map<String, dynamic>> products) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: products.map((product) {
        // Display custom productId if present, else fallback to Firestore document id
        final String displayId =
            (product['productId'] as String? ?? '').isNotEmpty
                ? product['productId'] as String
                : product['id'] as String;

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
                          '$displayId • ${product['category']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(product['status'] as String),
                  _actionMenu(product),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _mobileInfo(
                      'Price',
                      '₹${(product['price'] as double).toStringAsFixed(0)}',
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

  Widget _buildEmptyState({
    String title = 'No products found',
    String subtitle = 'Try changing your search or filters.',
  }) {
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AdminColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(color: AdminColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _extractImageUrls(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .map((url) => url?.toString().trim() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      return [value.trim()];
    }
    return [];
  }

  void _showProductDetails(Map<String, dynamic> product) {
    final String productId = product['productId'] as String? ?? '';
    final List<String> imageUrls = _extractImageUrls(product['imageUrls']);
    final String? coverImageUrl =
        imageUrls.isNotEmpty ? imageUrls.first : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Product Details'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // [UI Enhancement]: Product Cover Image with loading indicator and fallback placeholder
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AdminColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AdminColors.border),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: coverImageUrl != null
                            ? Image.network(
                                coverImageUrl,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint(
                                    'Image loading failed for $productId: $error | URL: $coverImageUrl',
                                  );
                                  return const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 38,
                                      color: AdminColors.textLight,
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 38,
                                  color: AdminColors.textLight,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // [Display Update]: Firestore internal document.id row removed; human-readable custom productId retained
                  if (productId.isNotEmpty)
                    _detailRow('Product ID', productId),
                  _detailRow('Product Name', product['name']),
                  _detailRow('Category', product['category']),
                  _detailRow(
                    'Price',
                    '₹${(product['price'] as double).toStringAsFixed(0)}',
                  ),
                  _detailRow('Stock', '${product['stock']} units'),
                  _detailRow('Status', product['status']),
                  _detailRow(
                    'Prescription',
                    product['prescriptionRequired']
                        ? 'Required'
                        : 'Not Required',
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

  // [Firestore Integration]: Updated Edit Dialog to persist changes to the Firestore document matching document.id
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

    String category = product['category'].toString();
    bool prescriptionRequired =
        product['prescriptionRequired'] as bool? ?? false;

    final Set<String> defaultCategories = {
      'Medicines',
      'Vitamins',
      'Personal Care',
      'Antibiotics',
      'Baby Care',
      if (category.trim().isNotEmpty) category.trim(),
    };
    final List<String> editCategories = defaultCategories.toList()..sort();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogInnerContext, setDialogState) {
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
                        initialValue:
                            editCategories.contains(category)
                                ? category
                                : editCategories.first,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items:
                            editCategories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
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
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final price = double.tryParse(priceController.text.trim());
                    final stock = int.tryParse(stockController.text.trim());

                    if (name.isEmpty || price == null || stock == null) {
                      ScaffoldMessenger.of(dialogInnerContext).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter valid product details.'),
                        ),
                      );
                      return;
                    }

                    // [Firestore Integration]: Write back using exact Firestore field names (medicineName, type, price, quantity)
                    try {
                      Navigator.pop(dialogContext);
                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(product['id'] as String)
                          .update({
                            'medicineName': name,
                            'type': category,
                            'price': price,
                            'quantity': stock,
                            'updatedAt': FieldValue.serverTimestamp(),
                          });

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product updated successfully.'),
                          ),
                        );
                      }
                    } catch (error) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update product: $error'),
                          ),
                        );
                      }
                    }
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

  // # TODO: A real "status" field should be added later if manual activate/deactivate independent of stock is required.
  // [Firestore Integration]: Derive status flip by adjusting quantity in Firestore without writing nonexistent status field
  Future<void> _toggleProductStatus(Map<String, dynamic> product) async {
    final isActive = product['status'] == 'Active';
    final int newQuantity = isActive ? 0 : 1;

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product['id'] as String)
          .update({
            'quantity': newQuantity,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isActive ? 'Product deactivated.' : 'Product activated.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $error')),
        );
      }
    }
  }

  // [Firestore Integration]: Real Firestore delete operation matching document.id
  void _deleteProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete "${product['name']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.danger,
              ),
              onPressed: () async {
                try {
                  Navigator.pop(dialogContext);
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(product['id'] as String)
                      .delete();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product deleted successfully.'),
                      ),
                    );
                  }
                } catch (error) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete product: $error'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

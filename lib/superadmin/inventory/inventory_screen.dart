import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/admin_colors.dart';

// # TODO: minStock should become a real editable per-product field in a future task.
const int kDefaultMinStock = 10;

// # TODO: unit should become a real per-product field later.
const String kDefaultUnit = 'units';

// Pure date formatting helper for consistent relative & readable dates without external packages
String _formatDate(dynamic timestampValue) {
  if (timestampValue == null) return 'N/A';
  DateTime date;
  if (timestampValue is Timestamp) {
    date = timestampValue.toDate();
  } else if (timestampValue is DateTime) {
    date = timestampValue;
  } else {
    return timestampValue.toString();
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final itemDate = DateTime(date.year, date.month, date.day);
  final differenceInDays = today.difference(itemDate).inDays;

  final hour = date.hour;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = hour >= 12 ? 'PM' : 'AM';
  final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  final timeStr = '${hour12.toString().padLeft(2, '0')}:$minute $period';

  if (differenceInDays == 0) {
    return 'Today, $timeStr';
  } else if (differenceInDays == 1) {
    return 'Yesterday, $timeStr';
  } else {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dayStr = date.day.toString().padLeft(2, '0');
    final monthStr = months[date.month - 1];
    return '$dayStr $monthStr ${date.year}';
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _selectedStockStatus = 'All';

  // [Firestore Integration]: Hardcoded _inventory list removed in favor of live Firestore streaming.

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _getTotalUnits(List<Map<String, dynamic>> inventory) {
    return inventory.fold(0, (total, item) => total + (item['stock'] as int));
  }

  int _getLowStockCount(List<Map<String, dynamic>> inventory) {
    return inventory.where((item) {
      final stock = item['stock'] as int;
      final minimum = item['minStock'] as int;
      return stock > 0 && stock <= minimum;
    }).length;
  }

  int _getOutOfStockCount(List<Map<String, dynamic>> inventory) {
    return inventory.where((item) => item['stock'] == 0).length;
  }

  List<Map<String, dynamic>> _getFilteredInventory(
    List<Map<String, dynamic>> inventory,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    return inventory.where((item) {
      final stock = item['stock'] as int;
      final minimum = item['minStock'] as int;

      final matchesSearch =
          query.isEmpty ||
          item['product'].toString().toLowerCase().contains(query) ||
          item['productId'].toString().toLowerCase().contains(query) ||
          item['id'].toString().toLowerCase().contains(query) ||
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
        // [Firestore Integration]: Real-time StreamBuilder listening to the 'products' collection
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            // [Firestore Integration]: Explicitly handle loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // [Firestore Integration]: Explicitly handle error state using _buildEmptyState container
            if (snapshot.hasError) {
              return Center(
                child: _buildEmptyState(
                  title: 'Error loading inventory',
                  subtitle: snapshot.error.toString(),
                ),
              );
            }

            // [Firestore Integration]: Map Firestore docs to the Map shape expected by the UI
            final List<Map<String, dynamic>> inventory =
    (snapshot.data?.docs ?? []).map((doc) {
  final data = doc.data();

  final int quantity =
      (data['quantity'] as num?)?.toInt() ?? 0;

  final String medicineName =
      data['medicineName']?.toString() ?? '';

  final String type =
      data['type']?.toString() ?? '';

  final String productId =
      data['productId']?.toString() ?? '';

  final dynamic lastTimestamp =
      data['updatedAt'] ?? data['createdAt'];

  // Read imageUrls from Firestore safely.
  final List<String> imageUrls =
      _extractImageUrls(data['imageUrls']);

  debugPrint(
    'Product: $productId | Image URLs: $imageUrls',
  );

  return <String, dynamic>{
    // Firestore document ID.
    'id': doc.id,

    // Product fields from Firestore.
    'productId': productId,
    'product': medicineName,
    'medicineName': medicineName,
    'brandName': data['brandName']?.toString() ?? '',
    'chemicalName': data['chemicalName']?.toString() ?? '',
    'description': data['description']?.toString() ?? '',
    'category': type,
    'type': type,
    'location': data['location']?.toString() ?? '',

    // Stock fields.
    'stock': quantity,
    'quantity': quantity,
    'minStock': kDefaultMinStock,
    'unit': kDefaultUnit,
    'status': quantity > 0 ? 'Active' : 'Inactive',

    // Price fields.
    'price': (data['price'] as num?)?.toDouble() ?? 0.0,
    'salePrice': (data['salePrice'] as num?)?.toDouble() ?? 0.0,

    // Date field.
    'lastUpdated': _formatDate(lastTimestamp),

    // Product images from Firestore.
    'imageUrls': imageUrls,
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
                      _buildHeader(isMobile, inventory),
                      const SizedBox(height: 24),
                      _buildSummaryCards(isMobile, inventory),
                      const SizedBox(height: 24),
                      _buildInventorySection(isMobile, inventory),
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

  Widget _buildHeader(bool isMobile, List<Map<String, dynamic>> inventory) {
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
            onPressed: () => _showStockAdjustmentDialog(allProducts: inventory),
            icon: const Icon(Icons.add_box_outlined),
            label: const Text('Adjust Stock'),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(
    bool isMobile,
    List<Map<String, dynamic>> inventory,
  ) {
    final cards = [
      _summaryCard(
        title: 'Total Products',
        value: '${inventory.length}',
        icon: Icons.inventory_2_outlined,
        iconColor: AdminColors.info,
      ),
      _summaryCard(
        title: 'Total Units',
        value: '${_getTotalUnits(inventory)}',
        icon: Icons.layers_outlined,
        iconColor: AdminColors.primary,
      ),
      _summaryCard(
        title: 'Low Stock',
        value: '${_getLowStockCount(inventory)}',
        icon: Icons.warning_amber_outlined,
        iconColor: AdminColors.warning,
      ),
      _summaryCard(
        title: 'Out of Stock',
        value: '${_getOutOfStockCount(inventory)}',
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

  Widget _buildInventorySection(
    bool isMobile,
    List<Map<String, dynamic>> inventory,
  ) {
    final filtered = _getFilteredInventory(inventory);

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
            _buildFilters(isMobile, inventory),
            const SizedBox(height: 18),
            if (isMobile)
              _buildMobileInventoryList(filtered, inventory)
            else
              _buildDesktopInventoryTable(filtered, inventory),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(bool isMobile, List<Map<String, dynamic>> inventory) {
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
              Expanded(child: _categoryDropdown(inventory)),
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
        SizedBox(width: 180, child: _categoryDropdown(inventory)),
        const SizedBox(width: 14),
        SizedBox(width: 170, child: _stockStatusDropdown()),
      ],
    );
  }

  // [Firestore Integration]: Dynamic category dropdown items from distinct 'type' values in live snapshot
  Widget _categoryDropdown(List<Map<String, dynamic>> inventory) {
    final Set<String> distinctCategories = inventory
        .map((p) => (p['category'] ?? '').toString().trim())
        .where((cat) => cat.isNotEmpty)
        .toSet();

    final List<String> categories = [
      'All',
      ...distinctCategories.toList()..sort(),
    ];
    final String selectedValue = categories.contains(_selectedCategory)
        ? _selectedCategory
        : 'All';

    return DropdownButtonFormField<String>(
      key: ValueKey('inv_cat_$selectedValue'),
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

  Widget _stockStatusDropdown() {
    return DropdownButtonFormField<String>(
      key: ValueKey('inv_status_$_selectedStockStatus'),
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

  Widget _buildDesktopInventoryTable(
    List<Map<String, dynamic>> items,
    List<Map<String, dynamic>> allInventory,
  ) {
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
            final String displayId =
                (item['productId'] as String? ?? '').isNotEmpty
                ? item['productId'] as String
                : item['id'] as String;

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
                DataCell(Text(item['category'])),
                DataCell(
                  _stockBadge(
                    item['stock'] as int,
                    item['minStock'] as int,
                    item['unit'] as String,
                  ),
                ),
                DataCell(Text('${item['minStock']} ${item['unit']}')),
                DataCell(_statusBadge(item['status'] as String)),
                DataCell(
                  Text(
                    item['lastUpdated'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                ),
                DataCell(_actionMenu(item, allInventory)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileInventoryList(
    List<Map<String, dynamic>> items,
    List<Map<String, dynamic>> allInventory,
  ) {
    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: items.map((item) {
        final String displayId = (item['productId'] as String? ?? '').isNotEmpty
            ? item['productId'] as String
            : item['id'] as String;

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
                          '$displayId • ${item['category']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(item['status'] as String),
                  _actionMenu(item, allInventory),
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
                  Expanded(
                    child: _stockLabel(
                      item['stock'] as int,
                      item['minStock'] as int,
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

  Widget _actionMenu(
    Map<String, dynamic> item,
    List<Map<String, dynamic>> allInventory,
  ) {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showInventoryDetails(item);
            break;
          case 'adjust':
            _showStockAdjustmentDialog(item: item, allProducts: allInventory);
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
        PopupMenuItem(
          value: 'toggle',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.power_settings_new),
            title: Text(item['status'] == 'Active' ? 'Deactivate' : 'Activate'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    String title = 'No inventory items found',
    String subtitle = 'Try changing your search or filters.',
  }) {
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

  void _showInventoryDetails(Map<String, dynamic> item) {
  final String productId =
      item['productId']?.toString() ?? '';

  final String productName =
      item['medicineName']?.toString().trim().isNotEmpty == true
          ? item['medicineName'].toString()
          : item['product']?.toString() ?? 'Unknown Product';

  final String category =
      item['type']?.toString().trim().isNotEmpty == true
          ? item['type'].toString()
          : item['category']?.toString() ?? 'Not specified';

  final String stock =
      item['quantity']?.toString() ??
      item['stock']?.toString() ??
      '0';

  final String unit =
      item['unit']?.toString() ?? 'units';

  final String minimumStock =
      item['minStock']?.toString() ?? '0';

  final String status =
      item['status']?.toString() ?? 'Active';

  final String lastUpdated =
      item['lastUpdated']?.toString() ?? 'Not available';

  final List<String> imageUrls =
      _extractImageUrls(item['imageUrls']);

  final String? coverImageUrl =
      imageUrls.isNotEmpty ? imageUrls.first : null;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Inventory Details'),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AdminColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AdminColors.border,
                      ),
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
                                if (loadingProgress == null) {
                                  return child;
                                }

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
                              errorBuilder:
                                  (context, error, stackTrace) {
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

                if (productId.isNotEmpty)
                  _detailRow('Product ID', productId),

                _detailRow('Product', productName),
                _detailRow('Category', category),
                _detailRow('Current Stock', '$stock $unit'),
                _detailRow(
                  'Minimum Stock',
                  '$minimumStock $unit',
                ),
                _detailRow('Status', status),
                _detailRow('Last Updated', lastUpdated),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
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

  // [Firestore Integration]: Stock Adjustment Dialog with read-only Product ID and atomic WriteBatch
  void _showStockAdjustmentDialog({
    Map<String, dynamic>? item,
    List<Map<String, dynamic>> allProducts = const [],
  }) {
    final quantityController = TextEditingController();

    String? selectedDocId = item?['id']?.toString();
    String adjustmentType = 'Add Stock';

    Map<String, dynamic>? currentResolvedProduct =
        item ??
        (selectedDocId != null
            ? allProducts.cast<Map<String, dynamic>?>().firstWhere(
                (p) => p?['id'] == selectedDocId,
                orElse: () => null,
              )
            : (allProducts.isNotEmpty ? allProducts.first : null));

    if (item == null && currentResolvedProduct != null) {
      selectedDocId = currentResolvedProduct['id']?.toString();
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogInnerContext, setDialogState) {
            final String resolvedProductId =
                currentResolvedProduct?['productId']?.toString() ??
                currentResolvedProduct?['id']?.toString() ??
                '';

            return AlertDialog(
              title: Text(
                item == null
                    ? 'Adjust Stock'
                    : 'Adjust Stock • ${item['product']}',
              ),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Clearly visible, READ-ONLY Product ID display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AdminColors.background,
                          border: Border.all(color: AdminColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Product ID: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AdminColors.textSecondary,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                resolvedProductId.isNotEmpty
                                    ? resolvedProductId
                                    : 'None Selected',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AdminColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item == null)
                        DropdownButtonFormField<String>(
                          initialValue: selectedDocId,
                          decoration: const InputDecoration(
                            labelText: 'Product',
                          ),
                          items: allProducts.map((inventoryItem) {
                            return DropdownMenuItem<String>(
                              value: inventoryItem['id'] as String,
                              child: Text(
                                inventoryItem['product'] as String,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedDocId = value;
                              currentResolvedProduct = allProducts
                                  .cast<Map<String, dynamic>?>()
                                  .firstWhere(
                                    (p) => p?['id'] == value,
                                    orElse: () => null,
                                  );
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
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final quantity = int.tryParse(
                      quantityController.text.trim(),
                    );

                    if (quantity == null || quantity < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid quantity.'),
                        ),
                      );
                      return;
                    }

                    final Map<String, dynamic>? targetItem =
                        item ?? currentResolvedProduct;

                    if (targetItem == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a product.'),
                        ),
                      );
                      return;
                    }

                    final currentStock = targetItem['stock'] as int;
                    late int newStock;
                    late int quantityChange;
                    late String historyType;

                    if (adjustmentType == 'Add Stock') {
                      newStock = currentStock + quantity;
                      quantityChange = quantity;
                      historyType = 'Stock Added';
                    } else if (adjustmentType == 'Remove Stock') {
                      newStock = (currentStock - quantity).clamp(0, 999999999);
                      quantityChange = -(currentStock - newStock);
                      historyType = 'Stock Removed';
                    } else {
                      newStock = quantity;
                      quantityChange = newStock - currentStock;
                      historyType = 'Stock Set';
                    }

                    // [Firestore Integration]: Atomic WriteBatch updating quantity and recording per-product stockHistory
                    try {
                      Navigator.pop(dialogContext);

                      final docRef = FirebaseFirestore.instance
                          .collection('products')
                          .doc(targetItem['id'] as String);
                      final historyRef = docRef
                          .collection('stockHistory')
                          .doc();

                      final batch = FirebaseFirestore.instance.batch();

                      batch.update(docRef, {
                        'quantity': newStock,
                        'updatedAt': FieldValue.serverTimestamp(),
                      });

                      final user = FirebaseAuth.instance.currentUser;
                      final updatedBy = user?.email ?? user?.uid ?? 'Unknown';

                      batch.set(historyRef, {
                        'type': historyType,
                        'quantityChange': quantityChange,
                        'previousQuantity': currentStock,
                        'newQuantity': newStock,
                        'updatedAt': FieldValue.serverTimestamp(),
                        'updatedBy': updatedBy,
                      });

                      await batch.commit();

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Stock updated successfully.'),
                          ),
                        );
                      }
                    } catch (error) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update stock: $error'),
                          ),
                        );
                      }
                    }
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

  // [Firestore Integration]: Real per-product stockHistory subcollection stream
  void _showStockHistory(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Stock History • ${item['product']}'),
          content: SizedBox(
            width: 520,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .doc(item['id'] as String)
                  .collection('stockHistory')
                  .orderBy('updatedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SizedBox(
                    height: 180,
                    child: Center(
                      child: Text(
                        'Error loading history: ${snapshot.error}',
                        style: const TextStyle(color: AdminColors.danger),
                      ),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No stock history yet',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AdminColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: docs.map((doc) {
                      final data = doc.data();
                      final String type =
                          data['type'] as String? ?? 'Stock Adjustment';
                      final int change =
                          (data['quantityChange'] as num?)?.toInt() ?? 0;
                      final String changeStr = change >= 0
                          ? '+$change'
                          : '$change';
                      final bool isPositive = change >= 0;
                      final String dateStr = _formatDate(data['updatedAt']);
                      final String userStr =
                          data['updatedBy'] as String? ?? 'Unknown';

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              (isPositive
                                      ? AdminColors.success
                                      : AdminColors.warning)
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
                          type,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('$dateStr • $userStr'),
                        trailing: Text(
                          changeStr,
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
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // # TODO: A real "status" field should be added later if manual activate/deactivate independent of stock is required.
  // [Firestore Integration]: Toggle status by updating quantity in Firestore without writing nonexistent status field
  Future<void> _toggleStatus(Map<String, dynamic> item) async {
    final isActive = item['status'] == 'Active';

    if (isActive) {
      // Prompt confirmation before zeroing stock
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Deactivate Product'),
            content: Text(
              'Deactivating "${item['product']}" will set its stock to 0. Are you sure you want to proceed?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.danger,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Deactivate'),
              ),
            ],
          );
        },
      );

      if (confirm != true) return;
    }

    final int newQuantity = isActive ? 0 : 10;

    try {
      final docRef = FirebaseFirestore.instance
          .collection('products')
          .doc(item['id'] as String);
      final historyRef = docRef.collection('stockHistory').doc();

      final batch = FirebaseFirestore.instance.batch();
      batch.update(docRef, {
        'quantity': newQuantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final user = FirebaseAuth.instance.currentUser;
      final updatedBy = user?.email ?? user?.uid ?? 'Unknown';

      batch.set(historyRef, {
        'type': isActive ? 'Stock Removed' : 'Stock Added',
        'quantityChange': isActive ? -(item['stock'] as int) : newQuantity,
        'previousQuantity': item['stock'] as int,
        'newQuantity': newQuantity,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': updatedBy,
      });

      await batch.commit();

      if (mounted) {
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
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $error')),
        );
      }
    }
  }
}

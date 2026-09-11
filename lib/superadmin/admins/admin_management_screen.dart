import 'package:flutter/material.dart';

import '../theme/admin_colors.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _statusFilter = 'All';
  String _roleFilter = 'All';

  final List<Map<String, dynamic>> _admins = [
    {
      'id': 'ADM001',
      'name': 'Super Admin',
      'email': 'admin@barakaapharmacy.com',
      'phone': '+91 98765 43210',
      'role': 'Super Admin',
      'status': 'Active',
      'lastActive': 'Just now',
      'initials': 'SA',
    },
    {
      'id': 'ADM002',
      'name': 'Mohammed Rahman',
      'email': 'mohammed@barakaapharmacy.com',
      'phone': '+91 98765 12345',
      'role': 'Admin',
      'status': 'Active',
      'lastActive': '10 min ago',
      'initials': 'MR',
    },
    {
      'id': 'ADM003',
      'name': 'Aisha Khan',
      'email': 'aisha@barakaapharmacy.com',
      'phone': '+91 91234 56789',
      'role': 'Inventory Manager',
      'status': 'Active',
      'lastActive': '1 hour ago',
      'initials': 'AK',
    },
    {
      'id': 'ADM004',
      'name': 'Rahul Kumar',
      'email': 'rahul@barakaapharmacy.com',
      'phone': '+91 99887 66554',
      'role': 'Order Manager',
      'status': 'Inactive',
      'lastActive': '2 days ago',
      'initials': 'RK',
    },
    {
      'id': 'ADM005',
      'name': 'Fatima Ali',
      'email': 'fatima@barakaapharmacy.com',
      'phone': '+91 90000 11223',
      'role': 'Support Manager',
      'status': 'Active',
      'lastActive': '30 min ago',
      'initials': 'FA',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAdmins {
    return _admins.where((admin) {
      final String search = _searchQuery.toLowerCase().trim();

      final bool matchesSearch =
          search.isEmpty ||
          admin['name'].toString().toLowerCase().contains(search) ||
          admin['email'].toString().toLowerCase().contains(search) ||
          admin['id'].toString().toLowerCase().contains(search);

      final bool matchesStatus =
          _statusFilter == 'All' || admin['status'] == _statusFilter;

      final bool matchesRole =
          _roleFilter == 'All' || admin['role'] == _roleFilter;

      return matchesSearch && matchesStatus && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(),

          const SizedBox(height: 24),

          _buildSummaryCards(),

          const SizedBox(height: 24),

          _buildAdminTableCard(),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Management',
                style: TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Manage administrators, roles and access permissions.',
                style: TextStyle(
                  color: AdminColors.textSecondary,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          width: 140,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: _showAddAdminDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Admin'),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final int total = _admins.length;

    final int active = _admins
        .where((admin) => admin['status'] == 'Active')
        .length;

    final int inactive = _admins
        .where((admin) => admin['status'] == 'Inactive')
        .length;

    final int superAdmins = _admins
        .where((admin) => admin['role'] == 'Super Admin')
        .length;

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;

        if (constraints.maxWidth >= 1100) {
          columns = 4;
        } else if (constraints.maxWidth >= 700) {
          columns = 2;
        } else {
          columns = 1;
        }

        const double spacing = 16;

        final double cardWidth =
            (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: _buildSummaryCard(
                title: 'Total Admins',
                value: total.toString(),
                icon: Icons.admin_panel_settings_outlined,
                color: AdminColors.primary,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildSummaryCard(
                title: 'Active Admins',
                value: active.toString(),
                icon: Icons.check_circle_outline,
                color: AdminColors.success,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildSummaryCard(
                title: 'Inactive Admins',
                value: inactive.toString(),
                icon: Icons.pause_circle_outline,
                color: AdminColors.warning,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildSummaryCard(
                title: 'Super Admins',
                value: superAdmins.toString(),
                icon: Icons.shield_outlined,
                color: AdminColors.info,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
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
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),

            const SizedBox(width: 13),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AdminColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminTableCard() {
    final admins = _filteredAdmins;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTableToolbar(),

            const SizedBox(height: 18),

            if (admins.isEmpty)
              _buildEmptyState()
            else
              _buildAdminTable(admins),
          ],
        ),
      ),
    );
  }

  Widget _buildTableToolbar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown(
                      value: _statusFilter,
                      items: const ['All', 'Active', 'Inactive'],
                      onChanged: (value) {
                        setState(() {
                          _statusFilter = value ?? 'All';
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildFilterDropdown(
                      value: _roleFilter,
                      items: const [
                        'All',
                        'Super Admin',
                        'Admin',
                        'Inventory Manager',
                        'Order Manager',
                        'Support Manager',
                      ],
                      onChanged: (value) {
                        setState(() {
                          _roleFilter = value ?? 'All';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: _buildSearchField()),

            const SizedBox(width: 12),

            SizedBox(
              width: 150,
              child: _buildFilterDropdown(
                value: _statusFilter,
                items: const ['All', 'Active', 'Inactive'],
                onChanged: (value) {
                  setState(() {
                    _statusFilter = value ?? 'All';
                  });
                },
              ),
            ),

            const SizedBox(width: 12),

            SizedBox(
              width: 190,
              child: _buildFilterDropdown(
                value: _roleFilter,
                items: const [
                  'All',
                  'Super Admin',
                  'Admin',
                  'Inventory Manager',
                  'Order Manager',
                  'Support Manager',
                ],
                onChanged: (value) {
                  setState(() {
                    _roleFilter = value ?? 'All';
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: const InputDecoration(
        hintText: 'Search admins...',
        prefixIcon: Icon(Icons.search, size: 20),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildAdminTable(List<Map<String, dynamic>> admins) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return _buildMobileAdminList(admins);
        }

        return _buildDesktopAdminTable(admins);
      },
    );
  }

  Widget _buildDesktopAdminTable(List<Map<String, dynamic>> admins) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AdminColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              SizedBox(width: 70, child: Text('ID', style: _headerStyle)),

              Expanded(flex: 2, child: Text('ADMIN', style: _headerStyle)),

              Expanded(flex: 2, child: Text('CONTACT', style: _headerStyle)),

              Expanded(child: Text('ROLE', style: _headerStyle)),

              SizedBox(width: 90, child: Text('STATUS', style: _headerStyle)),

              SizedBox(
                width: 100,
                child: Text('LAST ACTIVE', style: _headerStyle),
              ),

              SizedBox(width: 110, child: Text('ACTION', style: _headerStyle)),
            ],
          ),
        ),

        ...admins.map((admin) => _buildDesktopAdminRow(admin)),
      ],
    );
  }

  Widget _buildDesktopAdminRow(Map<String, dynamic> admin) {
    final String status = admin['status'].toString();

    final Color statusColor = status == 'Active'
        ? AdminColors.success
        : AdminColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              admin['id'].toString(),
              style: const TextStyle(
                color: AdminColors.textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Expanded(flex: 2, child: _buildAdminIdentity(admin)),

          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  admin['email'].toString(),
                  style: const TextStyle(
                    color: AdminColors.textPrimary,
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  admin['phone'].toString(),
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Text(
              admin['role'].toString(),
              style: const TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(width: 90, child: _buildStatusBadge(status, statusColor)),

          SizedBox(
            width: 100,
            child: Text(
              admin['lastActive'].toString(),
              style: const TextStyle(
                color: AdminColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),

          SizedBox(
            width: 110,
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.visibility_outlined,
                  tooltip: 'View',
                  onPressed: () {
                    _showAdminDetails(admin);
                  },
                ),

                _buildActionButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'Edit',
                  onPressed: () {
                    _showEditAdminDialog(admin);
                  },
                ),

                PopupMenuButton<String>(
                  tooltip: 'More',
                  icon: const Icon(
                    Icons.more_vert,
                    size: 19,
                    color: AdminColors.textSecondary,
                  ),
                  onSelected: (value) {
                    _handleAdminAction(value, admin);
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(
                          status == 'Active' ? 'Deactivate' : 'Activate',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAdminList(List<Map<String, dynamic>> admins) {
    return Column(
      children: admins.map((admin) {
        final String status = admin['status'].toString();

        final Color statusColor = status == 'Active'
            ? AdminColors.success
            : AdminColors.warning;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: AdminColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildAvatar(admin['initials'].toString()),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          admin['name'].toString(),
                          style: const TextStyle(
                            color: AdminColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          admin['email'].toString(),
                          style: const TextStyle(
                            color: AdminColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildStatusBadge(status, statusColor),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildMobileDetail('Role', admin['role'].toString()),
                  ),
                  Expanded(
                    child: _buildMobileDetail(
                      'Last Active',
                      admin['lastActive'].toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _showAdminDetails(admin);
                    },
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('View'),
                  ),

                  TextButton.icon(
                    onPressed: () {
                      _showEditAdminDialog(admin);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                  ),

                  PopupMenuButton<String>(
                    onSelected: (value) {
                      _handleAdminAction(value, admin);
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(
                            status == 'Active' ? 'Deactivate' : 'Activate',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AdminColors.textSecondary,
            fontSize: 9.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: AdminColors.textPrimary,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAdminIdentity(Map<String, dynamic> admin) {
    return Row(
      children: [
        _buildAvatar(admin['initials'].toString()),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                admin['name'].toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                admin['id'].toString(),
                style: const TextStyle(
                  color: AdminColors.textSecondary,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String initials) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AdminColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: AdminColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      icon: Icon(icon, size: 17, color: AdminColors.textSecondary),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AdminColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search_off_outlined,
              color: AdminColors.textSecondary,
              size: 28,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'No admins found',
            style: TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Try changing your search or filters.',
            style: TextStyle(color: AdminColors.textSecondary, fontSize: 11.5),
          ),
        ],
      ),
    );
  }

  void _showAddAdminDialog() {
    _showAdminFormDialog();
  }

  void _showEditAdminDialog(Map<String, dynamic> admin) {
    _showAdminFormDialog(admin: admin);
  }

  void _showAdminFormDialog({Map<String, dynamic>? admin}) {
    final bool isEditing = admin != null;

    final nameController = TextEditingController(
      text: admin?['name']?.toString() ?? '',
    );

    final emailController = TextEditingController(
      text: admin?['email']?.toString() ?? '',
    );

    final phoneController = TextEditingController(
      text: admin?['phone']?.toString() ?? '',
    );

    String selectedRole = admin?['role']?.toString() ?? 'Admin';

    String selectedStatus = admin?['status']?.toString() ?? 'Active';

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Admin' : 'Add Admin'),

              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),

                      const SizedBox(height: 14),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),

                      const SizedBox(height: 14),

                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),

                      const SizedBox(height: 14),

                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                        ),
                        items:
                            const [
                              'Super Admin',
                              'Admin',
                              'Inventory Manager',
                              'Order Manager',
                              'Support Manager',
                            ].map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedRole = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 14),

                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.toggle_on_outlined),
                        ),
                        items: const ['Active', 'Inactive'].map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedStatus = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    final String name = nameController.text.trim();

                    final String email = emailController.text.trim();

                    if (name.isEmpty || email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter name and email.'),
                        ),
                      );

                      return;
                    }

                    setState(() {
                      if (isEditing) {
                        admin!['name'] = name;
                        admin['email'] = email;
                        admin['phone'] = phoneController.text.trim();
                        admin['role'] = selectedRole;
                        admin['status'] = selectedStatus;
                      } else {
                        final int nextNumber = _admins.length + 1;

                        _admins.add({
                          'id': 'ADM${nextNumber.toString().padLeft(3, '0')}',
                          'name': name,
                          'email': email,
                          'phone': phoneController.text.trim(),
                          'role': selectedRole,
                          'status': selectedStatus,
                          'lastActive': 'Just now',
                          'initials': _getInitials(name),
                        });
                      }
                    });

                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Admin updated successfully.'
                              : 'Admin added successfully.',
                        ),
                      ),
                    );
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Add Admin'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAdminDetails(Map<String, dynamic> admin) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Admin Details'),

          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailsAvatar(admin['initials'].toString()),

                const SizedBox(height: 14),

                Text(
                  admin['name'].toString(),
                  style: const TextStyle(
                    color: AdminColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  admin['role'].toString(),
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 22),

                _buildDetailRow('Admin ID', admin['id'].toString()),

                _buildDetailRow('Email', admin['email'].toString()),

                _buildDetailRow('Phone', admin['phone'].toString()),

                _buildDetailRow('Role', admin['role'].toString()),

                _buildDetailRow('Status', admin['status'].toString()),

                _buildDetailRow('Last Active', admin['lastActive'].toString()),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailsAvatar(String initials) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AdminColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: AdminColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AdminColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAdminAction(String action, Map<String, dynamic> admin) {
    if (action == 'toggle') {
      final bool currentlyActive = admin['status'] == 'Active';

      setState(() {
        admin['status'] = currentlyActive ? 'Inactive' : 'Active';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentlyActive
                ? '${admin['name']} has been deactivated.'
                : '${admin['name']} has been activated.',
          ),
        ),
      );

      return;
    }

    if (action == 'delete') {
      _showDeleteConfirmation(admin);
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> admin) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Admin'),

          content: Text(
            'Are you sure you want to delete ${admin['name']}? This action cannot be undone.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AdminColors.danger,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _admins.remove(admin);
                });

                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Admin deleted successfully.')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty) {
      return 'AD';
    }

    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  static const TextStyle _headerStyle = TextStyle(
    color: AdminColors.textSecondary,
    fontSize: 9.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
}

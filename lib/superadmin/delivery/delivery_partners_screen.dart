import 'package:barakaa/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DeliveryPartnersScreen extends StatefulWidget {
  const DeliveryPartnersScreen({super.key});

  @override
  State<DeliveryPartnersScreen> createState() => _DeliveryPartnersScreenState();
}

class _DeliveryPartnersScreenState extends State<DeliveryPartnersScreen> {
  String _filter = 'All';

  final List<_PartnerItem> _partners = const [
    _PartnerItem(
      name: 'Muthu Kumar',
      vehicle: 'Bike · TN 09 AB 1234',
      phone: '+91 91234 56789',
      isOnline: true,
      deliveriesToday: 8,
    ),
    _PartnerItem(
      name: 'Ravi Shankar',
      vehicle: 'Scooter · TN 07 CD 4321',
      phone: '+91 91234 22222',
      isOnline: false,
      deliveriesToday: 0,
    ),
    _PartnerItem(
      name: 'Suresh Babu',
      vehicle: 'Bike · TN 11 EF 5566',
      phone: '+91 91234 33333',
      isOnline: true,
      deliveriesToday: 5,
    ),
  ];

  List<_PartnerItem> get _filtered {
    if (_filter == 'All') return _partners;
    final wantOnline = _filter == 'Online';
    return _partners.where((p) => p.isOnline == wantOnline).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Delivery Partners'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: open add-partner form
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.delivery_dining),
        label: const Text('Add Partner'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search delivery partners',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: ['All', 'Online', 'Offline'].map((label) {
                final selected = _filter == label;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    selectedColor: AppColors.primary.withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _filter = label),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _PartnerCard(partner: _filtered[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerItem {
  final String name;
  final String vehicle;
  final String phone;
  final bool isOnline;
  final int deliveriesToday;

  const _PartnerItem({
    required this.name,
    required this.vehicle,
    required this.phone,
    required this.isOnline,
    required this.deliveriesToday,
  });
}

class _PartnerCard extends StatelessWidget {
  const _PartnerCard({required this.partner});

  final _PartnerItem partner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primary.withOpacity(0.12),
                child: Text(
                  partner.name
                      .trim()
                      .split(' ')
                      .map((e) => e[0])
                      .take(2)
                      .join(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: partner.isOnline ? Colors.green : Colors.grey,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  partner.vehicle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  partner.phone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${partner.deliveriesToday}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.brandBlue,
                ),
              ),
              const Text(
                'today',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

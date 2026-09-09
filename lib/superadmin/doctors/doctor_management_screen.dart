import 'package:barakaa/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DoctorManagementScreen extends StatefulWidget {
  const DoctorManagementScreen({super.key});

  @override
  State<DoctorManagementScreen> createState() => _DoctorManagementScreenState();
}

class _DoctorManagementScreenState extends State<DoctorManagementScreen> {
  String _filter = 'All';

  final List<_DoctorItem> _doctors = const [
    _DoctorItem(
      name: 'Dr. Aisha Rahman',
      specialization: 'General Physician',
      phone: '+91 90000 11111',
      isActive: true,
    ),
    _DoctorItem(
      name: 'Dr. Karthik Iyer',
      specialization: 'Pediatrician',
      phone: '+91 90000 22222',
      isActive: true,
    ),
    _DoctorItem(
      name: 'Dr. Fatima Sheikh',
      specialization: 'Dermatologist',
      phone: '+91 90000 33333',
      isActive: false,
    ),
    _DoctorItem(
      name: 'Dr. Rohit Verma',
      specialization: 'Cardiologist',
      phone: '+91 90000 44444',
      isActive: true,
    ),
  ];

  List<_DoctorItem> get _filteredDoctors {
    if (_filter == 'All') return _doctors;
    final wantActive = _filter == 'Active';
    return _doctors.where((d) => d.isActive == wantActive).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Doctor Management'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: open add-doctor form
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Doctor'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search doctors by name or specialization',
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
              children: ['All', 'Active', 'Inactive'].map((label) {
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
              itemCount: _filteredDoctors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final doctor = _filteredDoctors[index];
                return _DoctorCard(doctor: doctor);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorItem {
  final String name;
  final String specialization;
  final String phone;
  final bool isActive;

  const _DoctorItem({
    required this.name,
    required this.specialization,
    required this.phone,
    required this.isActive,
  });
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor});

  final _DoctorItem doctor;

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
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.brandBlue.withOpacity(0.12),
            child: Text(
              doctor.name.trim().split(' ').map((e) => e[0]).take(2).join(),
              style: const TextStyle(
                color: AppColors.brandBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.specialization,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.phone,
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: doctor.isActive
                      ? AppColors.primary.withOpacity(0.12)
                      : Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  doctor.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: doctor.isActive ? AppColors.primary : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  // TODO: edit / deactivate menu
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: AppColors.brandBlue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),

            _buildSectionTitle('How can we help?'),
            const SizedBox(height: 12),

            _buildSupportOption(
              icon: Icons.shopping_bag_outlined,
              title: 'Orders & Delivery',
              subtitle: 'Track your order or get help with delivery',
              onTap: () {
                _showMessage(
                  context,
                  'Orders & Delivery support will be available soon.',
                );
              },
            ),

            _buildSupportOption(
              icon: Icons.medication_outlined,
              title: 'Medicines & Products',
              subtitle: 'Get help finding medicines and health products',
              onTap: () {
                _showMessage(
                  context,
                  'Medicine support will be available soon.',
                );
              },
            ),

            _buildSupportOption(
              icon: Icons.payment_outlined,
              title: 'Payments',
              subtitle: 'Get help with payments and transactions',
              onTap: () {
                _showMessage(
                  context,
                  'Payment support will be available soon.',
                );
              },
            ),

            _buildSupportOption(
              icon: Icons.account_circle_outlined,
              title: 'Account & Login',
              subtitle: 'Get help with your account or login',
              onTap: () {
                _showMessage(
                  context,
                  'Account support will be available soon.',
                );
              },
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Frequently Asked Questions'),
            const SizedBox(height: 12),

            _buildFaqTile(
              question: 'How do I place an order?',
              answer:
                  'Browse the available medicines or health products, '
                  'add the items you need to your cart, and continue '
                  'through checkout.',
            ),

            _buildFaqTile(
              question: 'How can I track my order?',
              answer:
                  'Open My Orders from your profile to view your recent '
                  'orders and their current status.',
            ),

            _buildFaqTile(
              question: 'Can I cancel my order?',
              answer:
                  'Order cancellation will be available once the order '
                  'management system is connected.',
            ),

            _buildFaqTile(
              question: 'How does biometric login work?',
              answer:
                  'Biometric login will allow you to use your device '
                  'fingerprint or Face ID to sign in quickly. This feature '
                  'will be connected after authentication is implemented.',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Contact Us'),
            const SizedBox(height: 12),

            _buildContactCard(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'support@barakaapharmacy.com',
              onTap: () {
                _showMessage(context, 'Email support will be connected later.');
              },
            ),

            _buildContactCard(
              icon: Icons.phone_outlined,
              title: 'Call Support',
              subtitle: '+91 00000 00000',
              onTap: () {
                _showMessage(context, 'Phone support will be connected later.');
              },
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                'Barakaa Pharmacy',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 4),

            const Center(
              child: Text(
                'We are here to help.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.primary,
              size: 31,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Help?',
                  style: TextStyle(
                    color: AppColors.brandBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Find answers or contact our support team.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.brandBlue,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primary, size: 23),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildFaqTile({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textSecondary,
        title: Text(
          question,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

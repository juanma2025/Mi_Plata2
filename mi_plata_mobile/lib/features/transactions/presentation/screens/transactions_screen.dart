import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  String formatMoney(double amount) {
    return NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background comes from Dashboard Scaffold
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text('Movimientos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: const Icon(LucideIcons.search, color: AppColors.textGray400),
                          onPressed: () {},
                          splashRadius: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', isActive: true),
                      const SizedBox(width: 8),
                      _buildFilterChip('Ingresos'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Gastos'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Sep 2026', icon: LucideIcons.calendar),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      _buildDateHeader('HOY'),
                      _buildTransactionCard(
                        icon: LucideIcons.utensils,
                        iconColor: Colors.orange,
                        title: 'Hamburguesas El Corral',
                        category: 'Comida',
                        amount: -45000,
                      ),
                      _buildTransactionCard(
                        icon: LucideIcons.bus,
                        iconColor: Colors.blue,
                        title: 'Recarga TuLlave',
                        category: 'Transporte',
                        amount: -20000,
                      ),
                      const SizedBox(height: 24),

                      _buildDateHeader('AYER'),
                      _buildTransactionCard(
                        icon: Icons.attach_money,
                        iconColor: AppColors.accent,
                        title: 'Transferencia Mamá',
                        category: 'Mesada',
                        amount: 500000,
                      ),
                      _buildTransactionCard(
                        icon: LucideIcons.graduationCap,
                        iconColor: Colors.purple,
                        title: 'Fotocopias U',
                        category: 'Educación',
                        amount: -5500,
                      ),
                      const SizedBox(height: 80), // Padding for FAB
                    ],
                  ),
                ),
              ],
            ),
            
            // FAB
            Positioned(
              bottom: 24,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.graphite900,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onPressed: () => context.push('/add-transaction'),
                child: const Icon(LucideIcons.plus, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isActive = false, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.accent : AppColors.graphite800,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isActive ? AppColors.accent : AppColors.graphite700),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: isActive ? AppColors.graphite900 : AppColors.textGray400),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.graphite900 : AppColors.textGray200,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        date,
        style: const TextStyle(
          color: AppColors.textGray500,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTransactionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String category,
    required double amount,
  }) {
    final isIncome = amount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.graphite800,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.graphite700),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)),
                const SizedBox(height: 2),
                Text(category, style: const TextStyle(color: AppColors.textGray400, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+ ' : '- '}${formatMoney(amount.abs())}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isIncome ? AppColors.accent : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

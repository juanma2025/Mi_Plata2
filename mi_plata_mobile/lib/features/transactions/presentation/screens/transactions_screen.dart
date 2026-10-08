import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/transactions_provider.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  String _filterType = 'Todos'; // Estado de filtro: 'Todos', 'Ingresos', 'Gastos'

  String formatMoney(double amount) {
    return NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0).format(amount);
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.graphite900,
              surface: AppColors.graphite800,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    
    // Filter transactions
    final filteredTransactions = transactions.where((tx) {
      if (_filterType == 'Ingresos' && tx.amount <= 0) return false;
      if (_filterType == 'Gastos' && tx.amount > 0) return false;
      if (_selectedDate != null) {
        if (tx.date.year != _selectedDate!.year || tx.date.month != _selectedDate!.month) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent, // Background comes from Dashboard Scaffold
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header (Animado para mostrar Buscador)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSearching
                        ? Row(
                            key: const ValueKey('searchBar'),
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Buscar movimiento...',
                                    hintStyle: const TextStyle(color: AppColors.textGray500),
                                    filled: true,
                                    fillColor: AppColors.graphite800,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(LucideIcons.x, color: AppColors.textGray400),
                                onPressed: () {
                                  setState(() {
                                    _isSearching = false;
                                    _searchController.clear();
                                  });
                                },
                              ),
                            ],
                          )
                        : Row(
                            key: const ValueKey('headerTitle'),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 48), // Balance visual para centrar el texto
                              const Text('Movimientos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                              IconButton(
                                icon: const Icon(LucideIcons.search, color: AppColors.textGray400),
                                onPressed: () => setState(() => _isSearching = true),
                                splashRadius: 24,
                              ),
                            ],
                          ),
                  ),
                ),

                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _filterType = 'Todos'),
                        child: _buildFilterChip('Todos', isActive: _filterType == 'Todos'),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _filterType = 'Ingresos'),
                        child: _buildFilterChip('Ingresos', isActive: _filterType == 'Ingresos'),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _filterType = 'Gastos'),
                        child: _buildFilterChip('Gastos', isActive: _filterType == 'Gastos'),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _pickDate,
                        child: _buildFilterChip(
                          _selectedDate != null ? DateFormat('MMM yyyy', 'es').format(_selectedDate!) : 'Mes actual',
                          icon: LucideIcons.calendar,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // List
                Expanded(
                  child: filteredTransactions.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay movimientos para este filtro.',
                            style: TextStyle(color: AppColors.textGray500, fontSize: 14),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: filteredTransactions.length + 1, // +1 for FAB padding
                          itemBuilder: (context, index) {
                            if (index == filteredTransactions.length) {
                              return const SizedBox(height: 80);
                            }
                            final tx = filteredTransactions[index];
                            return _buildTransactionCard(
                              icon: tx.icon,
                              iconColor: tx.iconColor,
                              title: tx.title,
                              category: tx.category,
                              amount: tx.amount,
                              delay: (index * 100).clamp(0, 500),
                            );
                          },
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
              ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
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
    ).animate().fade(duration: 300.ms);
  }

  Widget _buildTransactionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String category,
    required double amount,
    required int delay,
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
    ).animate().fade(delay: delay.ms).slideY(begin: 0.2, curve: Curves.easeOut);
  }
}

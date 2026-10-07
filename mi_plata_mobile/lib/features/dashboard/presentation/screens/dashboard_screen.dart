import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/services/supabase_service.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeTab(),
    const Center(child: Text('Finanzas')),
    const Center(child: Text('PLATA IA')),
    const Center(child: Text('Actividad')),
    const Center(child: Text('Perfil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.pieChart), label: 'Finanzas'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.bot), label: 'PLATA IA'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.activity), label: 'Actividad'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab();

  String formatMoney(double amount) {
    return NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = ref.watch(supabaseProvider);
    final user = supabase.auth.currentUser;

    // Default mock data (since we aren't fetching yet)
    const double income = 2600000;
    const double expenses = 755000;
    const double budget = 1500000;
    
    const double balance = income - expenses;
    const double budgetRemaining = budget - expenses;
    final int budgetPercent = budget > 0 ? ((budgetRemaining / budget) * 100).round() : 0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola,',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      user?.userMetadata?['name'] ?? user?.email ?? 'Usuario',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.logOut),
                  onPressed: () async {
                    await supabase.auth.signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 24),
            
            // STATS GRID (2x2)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildStatCard(context, 'Saldo estimado', formatMoney(balance), '8.4% este mes', true),
                _buildStatCard(context, 'Ingresos mensuales', formatMoney(income), '5.2%', true),
                _buildStatCard(context, 'Gastos estimados', formatMoney(expenses), '3.1%', false),
                _buildStatCard(context, 'Presupuesto restante', formatMoney(budgetRemaining > 0 ? budgetRemaining : 0), '$budgetPercent% disponible', null),
              ],
            ),
            const SizedBox(height: 16),

            // EVOLUCIÓN FINANCIERA
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Evolución financiera', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Últimos 6 meses', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBar(context, 45, 'Abr', false),
                          _buildBar(context, 58, 'May', false),
                          _buildBar(context, 51, 'Jun', false),
                          _buildBar(context, 68, 'Jul', false),
                          _buildBar(context, 77, 'Ago', false),
                          _buildBar(context, 88, 'Sep', true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // METAS DE AHORRO
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Metas de ahorro', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Ver todas', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildGoalRow(context, 'Fondo de Ahorro', 73, 365000, 500000),
                    const Divider(height: 24),
                    _buildGoalRow(context, 'MacBook', 72, 3600000, 5000000),
                    const Divider(height: 24),
                    _buildGoalRow(context, 'Viaje', 44, 880000, 2000000),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // MOVIMIENTOS RECIENTES
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Movimientos recientes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Ver todos', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTransactionRow(context, 'Netflix', 'Suscripciones • Hoy', -35000, false),
                    const Divider(height: 16),
                    _buildTransactionRow(context, 'Salario', 'Ingresos • Ayer', 2600000, true),
                    const Divider(height: 16),
                    _buildTransactionRow(context, 'Supermercado', 'Alimentación • 15 Sep', -120000, false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String amount, String subtitle, bool? isPositive) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(amount, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            if (isPositive != null)
              Row(
                children: [
                  Icon(
                    isPositive ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
                    size: 14,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isPositive ? Colors.green : Colors.red,
                      fontSize: 10,
                    ),
                  ),
                ],
              )
            else
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context, double heightPercent, String label, bool isCurrent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: heightPercent,
          decoration: BoxDecoration(
            color: isCurrent ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withValues(alpha: 0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildGoalRow(BuildContext context, String name, int progress, double saved, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('$progress%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: Theme.of(context).dividerColor,
          color: Theme.of(context).primaryColor,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${formatMoney(saved)} ahorrados', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
            Text(formatMoney(total), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionRow(BuildContext context, String name, String subtitle, double amount, bool isIncome) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isIncome ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
            color: isIncome ? Colors.green : Colors.red,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
            ],
          ),
        ),
        Text(
          '${isIncome ? '+' : ''}${formatMoney(amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}

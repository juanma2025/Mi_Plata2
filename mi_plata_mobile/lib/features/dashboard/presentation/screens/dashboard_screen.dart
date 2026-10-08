import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../transactions/presentation/screens/transactions_screen.dart';
import '../../../../core/theme/theme_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'plata_ia_screen.dart';
import '../../../analysis/presentation/screens/analysis_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeTab(),
    const TransactionsScreen(),
    const PlataIaScreen(),
    const AnalysisScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.graphite700, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.graphite900,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textGray400,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.list), label: 'Movs'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.bot), label: 'IA'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.pieChart), label: 'Análisis'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Perfil'),
          ],
        ),
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

    final metadata = user?.userMetadata ?? {};

    // Cargar datos financieros configurados en el onboarding
    final double income = (metadata['monthly_income'] as num?)?.toDouble() ?? 0.0;
    final double expenses = (metadata['monthly_expenses'] as num?)?.toDouble() ?? 0.0;
    final double budget = (metadata['monthly_budget'] as num?)?.toDouble() ?? 0.0;
    final double savingsGoal = (metadata['savings_goal'] as num?)?.toDouble() ?? 0.0;
    
    // Cálculos financieros inteligentes
    final double balance = income - expenses;
    final double recommendedSavings = income * 0.20; // Sugerencia: 20% del ingreso
    final double budgetRemaining = budget - expenses;
    final int budgetPercent = budget > 0 ? ((budgetRemaining / budget) * 100).round() : 0;
    final double savingsPercentage = income > 0 ? (balance / income) * 100 : 0;

    // Saludo dinámico según la hora local
    String greeting = 'Hola';
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      greeting = 'Buenos días';
    } else if (hour >= 12 && hour < 19) {
      greeting = 'Buenas tardes';
    } else {
      greeting = 'Buenas noches';
    }

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
                      '$greeting,',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      user?.userMetadata?['name'] ?? user?.userMetadata?['first_name'] ?? 'Usuario',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Theme.of(context).brightness == Brightness.dark 
                            ? LucideIcons.sun 
                            : LucideIcons.moon,
                      ),
                      onPressed: () {
                        ref.read(themeModeProvider.notifier).toggleTheme();
                      },
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.logOut),
                      onPressed: () async {
                        await supabase.auth.signOut();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                    ),
                  ],
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
                _buildStatCard(context, 'Disponible para ahorrar', formatMoney(balance), '${savingsPercentage.toStringAsFixed(1)}% de tu ingreso', true),
                _buildStatCard(context, 'Ahorro recomendado (20%)', formatMoney(recommendedSavings), 'Ideal', true),
                _buildStatCard(context, 'Gastos estimados', formatMoney(expenses), 'Planificado', false),
                _buildStatCard(context, 'Presupuesto restante', formatMoney(budgetRemaining > 0 ? budgetRemaining : 0), '$budgetPercent% disponible', null),
              ],
            ).animate().fade(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOutQuad),
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
                          _buildBar(context, 45, 'Abr', false).animate(delay: 100.ms).scaleY(begin: 0, alignment: Alignment.bottomCenter),
                          _buildBar(context, 58, 'May', false).animate(delay: 200.ms).scaleY(begin: 0, alignment: Alignment.bottomCenter),
                          _buildBar(context, 51, 'Jun', false).animate(delay: 300.ms).scaleY(begin: 0, alignment: Alignment.bottomCenter),
                          _buildBar(context, 68, 'Jul', false).animate(delay: 400.ms).scaleY(begin: 0, alignment: Alignment.bottomCenter),
                          _buildBar(context, 77, 'Ago', false).animate(delay: 500.ms).scaleY(begin: 0, alignment: Alignment.bottomCenter),
                          _buildBar(context, 88, 'Sep', true).animate(delay: 600.ms).scaleY(begin: 0, alignment: Alignment.bottomCenter),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fade(delay: 200.ms).slideX(begin: 0.05),
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
                    _buildGoalRow(context, 'Fondo de Ahorro', 73, savingsGoal * 0.73, savingsGoal > 0 ? savingsGoal : 500000),
                  ],
                ),
              ),
            ).animate().fade(delay: 300.ms).slideX(begin: 0.05),
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
            ).animate().fade(delay: 400.ms).slideY(begin: 0.1),
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

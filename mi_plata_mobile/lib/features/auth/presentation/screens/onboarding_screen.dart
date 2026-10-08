import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();
  final _budgetController = TextEditingController();
  final _savingsGoalController = TextEditingController();

  String _incomeSource = 'Salario';
  final List<String> _incomeSources = ['Salario', 'Independiente', 'Negocio propio', 'Inversiones', 'Otro'];

  List<String> _selectedCategories = [];
  final List<String> _availableCategories = ['Vivienda', 'Alimentación', 'Transporte', 'Educación', 'Entretenimiento', 'Salud', 'Ahorro', 'Deudas'];

  void _nextStep() {
    if (_currentStep == 0 && _incomeController.text.isEmpty) {
      _showError('Por favor ingresa tus ingresos mensuales.');
      return;
    }
    if (_currentStep == 1 && _expensesController.text.isEmpty) {
      _showError('Por favor ingresa tus gastos aproximados.');
      return;
    }
    if (_currentStep == 2 && (_budgetController.text.isEmpty || _savingsGoalController.text.isEmpty)) {
      _showError('Por favor completa tu presupuesto y meta de ahorro.');
      return;
    }
    
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _finishOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.danger));
  }

  Future<void> _finishOnboarding() async {
    if (_selectedCategories.isEmpty) {
      _showError('Selecciona al menos una categoría principal.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      
      // Guardar en user_metadata de Supabase Auth
      final Map<String, dynamic> onboardingData = {
        'onboarding_completed': true,
        'monthly_income': double.tryParse(_incomeController.text.replaceAll(',', '')) ?? 0.0,
        'income_source': _incomeSource,
        'monthly_expenses': double.tryParse(_expensesController.text.replaceAll(',', '')) ?? 0.0,
        'monthly_budget': double.tryParse(_budgetController.text.replaceAll(',', '')) ?? 0.0,
        'savings_goal': double.tryParse(_savingsGoalController.text.replaceAll(',', '')) ?? 0.0,
        'top_categories': _selectedCategories,
      };

      await supabase.auth.updateUser(UserAttributes(data: onboardingData));

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) _showError('Error al guardar: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.graphite900,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
                      onPressed: _previousStep,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    )
                  else
                    const SizedBox(width: 48), // Spacer
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / 4,
                      backgroundColor: AppColors.graphite700,
                      color: AppColors.accent,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer for balance
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCurrentStep(),
                ),
              ),
            ),
            
            // Footer Action
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.graphite900))
                    : Text(_currentStep == 3 ? 'Finalizar y empezar' : 'Siguiente', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildStep1().animate(key: const ValueKey(0)).fade(duration: 300.ms).slideX(begin: 0.1, curve: Curves.easeOut);
      case 1: return _buildStep2().animate(key: const ValueKey(1)).fade(duration: 300.ms).slideX(begin: 0.1, curve: Curves.easeOut);
      case 2: return _buildStep3().animate(key: const ValueKey(2)).fade(duration: 300.ms).slideX(begin: 0.1, curve: Curves.easeOut);
      case 3: return _buildStep4().animate(key: const ValueKey(3)).fade(duration: 300.ms).slideX(begin: 0.1, curve: Curves.easeOut);
      default: return const SizedBox();
    }
  }

  // Paso 1: Ingresos
  Widget _buildStep1() {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(LucideIcons.coins, color: AppColors.accent, size: 48),
        const SizedBox(height: 24),
        const Text('Tus Ingresos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        const Text('¿Cuánto dinero ingresas mensualmente y de dónde proviene principalmente?', style: TextStyle(color: AppColors.textGray400, fontSize: 14), textAlign: TextAlign.center),
        const SizedBox(height: 48),
        
        const Text('Ingreso Mensual (COP)', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
        const SizedBox(height: 8),
        _buildNumberField(_incomeController, 'Ej. 2500000'),
        const SizedBox(height: 24),
        
        const Text('Fuente principal', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: AppColors.graphite800, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.graphite700)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _incomeSource,
              dropdownColor: AppColors.graphite800,
              icon: const Icon(LucideIcons.chevronDown, color: AppColors.textGray400),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (v) => setState(() => _incomeSource = v!),
              items: _incomeSources.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Paso 2: Gastos
  Widget _buildStep2() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(LucideIcons.receipt, color: AppColors.danger, size: 48),
        const SizedBox(height: 24),
        const Text('Tus Gastos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        const Text('¿Cuánto estimas que gastas al mes en total? No tiene que ser exacto.', style: TextStyle(color: AppColors.textGray400, fontSize: 14), textAlign: TextAlign.center),
        const SizedBox(height: 48),
        
        const Text('Gastos Mensuales (COP)', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
        const SizedBox(height: 8),
        _buildNumberField(_expensesController, 'Ej. 1800000'),
      ],
    );
  }

  // Paso 3: Presupuesto y Metas
  Widget _buildStep3() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(LucideIcons.target, color: Colors.blueAccent, size: 48),
        const SizedBox(height: 24),
        const Text('Metas y Presupuesto', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        const Text('Establece un límite de gasto mensual y una meta de ahorro que quieras alcanzar.', style: TextStyle(color: AppColors.textGray400, fontSize: 14), textAlign: TextAlign.center),
        const SizedBox(height: 48),
        
        const Text('Presupuesto Máximo Mensual (COP)', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
        const SizedBox(height: 8),
        _buildNumberField(_budgetController, 'Ej. 2000000'),
        const SizedBox(height: 24),

        const Text('Objetivo de Ahorro Total (COP)', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
        const SizedBox(height: 8),
        _buildNumberField(_savingsGoalController, 'Ej. 5000000'),
      ],
    );
  }

  // Paso 4: Categorías
  Widget _buildStep4() {
    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(LucideIcons.pieChart, color: Colors.purpleAccent, size: 48),
        const SizedBox(height: 24),
        const Text('Tus Prioridades', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        const Text('Selecciona las categorías en las que más gastas dinero actualmente.', style: TextStyle(color: AppColors.textGray400, fontSize: 14), textAlign: TextAlign.center),
        const SizedBox(height: 32),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableCategories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedCategories.remove(category);
                  } else {
                    _selectedCategories.add(category);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.graphite800,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? AppColors.accent : AppColors.graphite700),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? AppColors.graphite900 : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ).animate().scale(delay: (100 * _availableCategories.indexOf(category)).ms, duration: 200.ms);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNumberField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGray600),
        filled: true,
        fillColor: AppColors.graphite800,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('\$', style: TextStyle(color: AppColors.textGray400, fontSize: 18, fontWeight: FontWeight.bold))]),
        ),
      ),
    );
  }
}

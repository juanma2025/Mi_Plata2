import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

class IncomeSurveyScreen extends StatefulWidget {
  const IncomeSurveyScreen({super.key});

  @override
  State<IncomeSurveyScreen> createState() => _IncomeSurveyScreenState();
}

class _IncomeSurveyScreenState extends State<IncomeSurveyScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un monto para continuar.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // Simular guardado de datos iniciales en la base de datos
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.graphite900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Icon & Title
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.coins, color: AppColors.accent, size: 48),
              ),
              const SizedBox(height: 32),
              
              const Text(
                '¿Cuál es tu ingreso\nprincipal?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              const Text(
                'Para personalizar tu experiencia y ayudarte a administrar mejor tu dinero, necesitamos saber cuánto ingresas aproximadamente al mes.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGray400,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Amount Input
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.graphite800,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.graphite700),
                ),
                child: Column(
                  children: [
                    const Text('Ingreso mensual (COP)', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6, right: 4),
                          child: Text('\$', style: TextStyle(color: AppColors.textGray500, fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(color: AppColors.textGray600),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Actions
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.graphite900))
                    : const Text('Continuar al Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Omitir por ahora', style: TextStyle(color: AppColors.textGray400)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

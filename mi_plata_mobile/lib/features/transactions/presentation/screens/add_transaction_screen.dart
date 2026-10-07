import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isExpense = true;
  String category = 'Comida y Domicilios';

  static const List<MapEntry<String, IconData>> _categories = [
    MapEntry('Comida y Domicilios', LucideIcons.utensils),
    MapEntry('Transporte', LucideIcons.bus),
    MapEntry('Educación', LucideIcons.bookOpen),
    MapEntry('Ocio y Diversión', LucideIcons.film),
    MapEntry('Compras', LucideIcons.shoppingBag),
  ];
  final amountController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.graphite900,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.chevronLeft, color: AppColors.textGray400, size: 28),
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const Text('Nuevo Movimiento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 24),

              // Segmented Control (Gasto / Ingreso)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.graphite800,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.graphite700),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isExpense = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isExpense ? AppColors.danger.withValues(alpha: 0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Gasto',
                            style: TextStyle(
                              color: isExpense ? AppColors.danger : AppColors.textGray400,
                              fontWeight: isExpense ? FontWeight.bold : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isExpense = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isExpense ? AppColors.accent.withValues(alpha: 0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Ingreso',
                            style: TextStyle(
                              color: !isExpense ? AppColors.accent : AppColors.textGray400,
                              fontWeight: !isExpense ? FontWeight.bold : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Amount Input
              const Text('Valor (COP)', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4, right: 4),
                    child: Text('\$', style: TextStyle(color: AppColors.textGray500, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  IntrinsicWidth(
                    child: TextField(
                      controller: amountController,
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
                        filled: false,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.graphite700),
              const SizedBox(height: 32),

              // Form
              const Text('Categoría', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.graphite800,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.graphite700),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: category,
                    dropdownColor: AppColors.graphite800,
                    icon: const Icon(LucideIcons.chevronDown, color: AppColors.textGray400),
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    onChanged: (String? newValue) {
                      if (newValue != null) setState(() => category = newValue);
                    },
                    items: _categories
                        .map((c) => DropdownMenuItem<String>(
                              value: c.key,
                              child: Row(
                                children: [
                                  Icon(c.value, size: 18, color: AppColors.accent),
                                  const SizedBox(width: 12),
                                  Text(c.key),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Descripción', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Ej. Almuerzo cafetería',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Fecha', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: '2026-09-30', // Mock
                  suffixIcon: Icon(LucideIcons.calendar, color: AppColors.textGray400),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  // Mock save
                  context.pop();
                },
                child: const Text('Guardar Movimiento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

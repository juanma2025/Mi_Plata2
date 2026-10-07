import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, completa todos los campos.')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final supabase = ref.read(supabaseProvider);
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {'name': _nameController.text.trim()},
        emailRedirectTo: kIsWeb ? Uri.base.origin : null,
      );

      if (!mounted) return;

      // Con "Confirm email" activo, Supabase no devuelve error si el correo ya existe:
      // responde con un usuario ofuscado cuyo listado de identities viene vacío.
      final identities = response.user?.identities;
      if (response.user != null && identities != null && identities.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Este correo electrónico ya está registrado. Por favor inicia sesión.'),
          backgroundColor: AppColors.danger,
        ));
        return;
      }

      if (supabase.auth.currentSession == null) {
        _showVerificationDialog();
      } else {
        context.go('/dashboard');
      }
    } on AuthException catch (e) {
      if (mounted) {
        String errorMsg = e.message;
        final lower = errorMsg.toLowerCase();
        if (lower.contains('user already registered') || lower.contains('already exists')) {
          errorMsg = 'Este correo electrónico ya está registrado. Por favor inicia sesión.';
        } else if (e.code == 'over_email_send_rate_limit' || lower.contains('rate limit')) {
          errorMsg = 'Se alcanzó el límite de correos por hora. Intenta de nuevo más tarde.';
        } else if (lower.contains('password')) {
          errorMsg = 'La contraseña debe tener al menos 6 caracteres.';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg), backgroundColor: AppColors.danger));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear la cuenta: $e'), backgroundColor: AppColors.danger));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.graphite800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.graphite700)),
        title: const Column(
          children: [
            Icon(LucideIcons.mail, color: AppColors.accent, size: 48),
            SizedBox(height: 16),
            Text('¡Revisa tu correo!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
        content: const Text(
          'Te hemos enviado un enlace de verificación a tu correo electrónico. Por favor revísalo para activar tu cuenta.',
          style: TextStyle(color: AppColors.textGray400, height: 1.5, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.graphite900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                context.go('/login'); // Redirect to login
              },
              child: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.account_balance_wallet, color: Theme.of(context).primaryColor),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'MiPlata',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Controla tu dinero.\nEntiende tus hábitos.\nConstruye tus metas.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  hintText: 'Mateo Rodríguez',
                ),
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  hintText: 'ejemplo@correo.com',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  hintText: '••••••••',
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Crear cuenta'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿Ya tienes una cuenta? ', style: Theme.of(context).textTheme.bodyMedium),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Inicia sesión',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

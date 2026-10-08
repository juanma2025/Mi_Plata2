import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.graphite900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.graphite800,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.graphite700),
                ),
                child: Icon(icon, size: 64, color: AppColors.accent),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: AppColors.textGray400, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.graphite600),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantallas específicas usando el Placeholder

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Configuración de la App',
      icon: LucideIcons.settings,
      description: 'Aquí podrás ajustar preferencias de notificaciones, idioma, tema (Claro/Oscuro) y configuración general de tu cuenta.',
    );
  }
}

class ConnectedAccountsScreen extends StatelessWidget {
  const ConnectedAccountsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Cuentas Conectadas',
      icon: LucideIcons.creditCard,
      description: 'Conecta de forma segura tus bancos (Nequi, Bancolombia, Daviplata) mediante Open Banking para sincronizar tus transacciones automáticamente.',
    );
  }
}

class ExportDataScreen extends StatelessWidget {
  const ExportDataScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Exportar Datos (CSV)',
      icon: LucideIcons.downloadCloud,
      description: 'Genera un archivo CSV o Excel con todos tus movimientos financieros para que puedas analizarlos externamente o presentarlos a tu contador.',
    );
  }
}

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Privacidad y Seguridad',
      icon: LucideIcons.shieldCheck,
      description: 'Revisa nuestras estrictas políticas de protección de datos (cumplimiento Habeas Data), gestiona tus sesiones activas y habilita biometría (Face ID / Huella).',
    );
  }
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Centro de Ayuda',
      icon: LucideIcons.helpCircle,
      description: 'Encuentra respuestas a preguntas frecuentes, tutoriales en video, y contacta a nuestro equipo de soporte técnico 24/7.',
    );
  }
}

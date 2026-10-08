import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = ref.watch(supabaseProvider);
    final user = supabase.auth.currentUser;
    final userName = user?.userMetadata?['name'] as String? ?? 'Usuario';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          children: [
            const Text(
              'Mi Perfil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 32),
            
            // Profile Header
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.graphite800,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      color: AppColors.graphite800,
                      child: ref.watch(profileImageProvider) != null
                          ? Image.network(ref.watch(profileImageProvider)!, fit: BoxFit.cover)
                          : Center(
                              child: Text(
                                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textGray400),
                              ),
                            ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/profile/edit'),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.graphite700,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.graphite600),
                    ),
                    child: const Icon(LucideIcons.pencil, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Estudiante Universitaria • ID: 8901',
              style: TextStyle(fontSize: 14, color: AppColors.textGray400),
            ),
            const SizedBox(height: 32),

            // Settings Group 1
            Container(
              decoration: BoxDecoration(
                color: AppColors.graphite800,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.graphite700),
              ),
              child: Column(
                children: [
                  _buildSettingsItem(
                    icon: LucideIcons.settings,
                    title: 'Configuración de la App',
                    onTap: () => context.push('/profile/settings'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.graphite700),
                  _buildSettingsItem(
                    icon: LucideIcons.creditCard,
                    title: 'Cuentas Conectadas',
                    badge: '2',
                    onTap: () => context.push('/profile/accounts'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.graphite700),
                  _buildSettingsItem(
                    icon: LucideIcons.downloadCloud,
                    title: 'Exportar Datos (CSV)',
                    onTap: () => context.push('/profile/export'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Group 2
            Container(
              decoration: BoxDecoration(
                color: AppColors.graphite800,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.graphite700),
              ),
              child: Column(
                children: [
                  _buildSettingsItem(
                    icon: LucideIcons.shieldCheck,
                    title: 'Privacidad y Seguridad',
                    onTap: () => context.push('/profile/privacy'),
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.graphite700),
                  _buildSettingsItem(
                    icon: LucideIcons.helpCircle,
                    title: 'Centro de Ayuda',
                    onTap: () => context.push('/profile/help'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            OutlinedButton(
              onPressed: () async {
                await supabase.auth.signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.danger.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                foregroundColor: AppColors.danger,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.logOut, size: 20),
                  SizedBox(width: 8),
                  Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textGray400, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            const Icon(LucideIcons.chevronRight, color: AppColors.textGray500, size: 20),
          ],
        ),
      ),
    );
  }
}

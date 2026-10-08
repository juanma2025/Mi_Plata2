import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/transactions/presentation/screens/add_transaction_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/settings_placeholder_screens.dart';
import '../../features/analysis/presentation/screens/analysis_screen.dart';
import '../services/supabase_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final supabase = ref.watch(supabaseProvider);

  return GoRouter(
    initialLocation: supabase.auth.currentSession != null ? '/dashboard' : '/landing',
    redirect: (context, state) {
      final isLoggedIn = supabase.auth.currentSession != null;
      final user = supabase.auth.currentUser;
      final hasCompletedOnboarding = user?.userMetadata?['onboarding_completed'] == true;

      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/register' || state.uri.path == '/landing';
      final isOnboardingRoute = state.uri.path == '/app/onboarding';

      if (!isLoggedIn && !isAuthRoute) return '/landing';
      
      if (isLoggedIn) {
        if (!hasCompletedOnboarding && !isOnboardingRoute) return '/app/onboarding';
        if (hasCompletedOnboarding && (isAuthRoute || isOnboardingRoute)) return '/dashboard';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/landing',
        pageBuilder: (context, state) => _buildPageWithAnimation(const LandingScreen(), state),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _buildPageWithAnimation(const LoginScreen(), state),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _buildPageWithAnimation(const RegisterScreen(), state),
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/add-transaction',
        pageBuilder: (context, state) => _buildPageWithAnimation(const AddTransactionScreen(), state),
      ),
      GoRoute(
        path: '/app/onboarding',
        pageBuilder: (context, state) => _buildPageWithAnimation(const OnboardingScreen(), state),
      ),
      GoRoute(
        path: '/analysis',
        pageBuilder: (context, state) => _buildPageWithAnimation(const AnalysisScreen(), state),
      ),
      GoRoute(
        path: '/profile/edit',
        pageBuilder: (context, state) => _buildPageWithAnimation(const EditProfileScreen(), state),
      ),
      GoRoute(
        path: '/profile/settings',
        pageBuilder: (context, state) => _buildPageWithAnimation(const AppSettingsScreen(), state),
      ),
      GoRoute(
        path: '/profile/accounts',
        pageBuilder: (context, state) => _buildPageWithAnimation(const ConnectedAccountsScreen(), state),
      ),
      GoRoute(
        path: '/profile/export',
        pageBuilder: (context, state) => _buildPageWithAnimation(const ExportDataScreen(), state),
      ),
      GoRoute(
        path: '/profile/privacy',
        pageBuilder: (context, state) => _buildPageWithAnimation(const PrivacySecurityScreen(), state),
      ),
      GoRoute(
        path: '/profile/help',
        pageBuilder: (context, state) => _buildPageWithAnimation(const HelpCenterScreen(), state),
      ),
    ],
  );
});

CustomTransitionPage _buildPageWithAnimation(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      );
    },
  );
}

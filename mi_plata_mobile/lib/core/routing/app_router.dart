import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import '../../features/transactions/presentation/screens/add_transaction_screen.dart';
import '../services/supabase_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final supabase = ref.watch(supabaseProvider);

  return GoRouter(
    initialLocation: supabase.auth.currentSession != null ? '/dashboard' : '/landing',
    redirect: (context, state) {
      final isLoggedIn = supabase.auth.currentSession != null;
      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/register' || state.uri.path == '/landing';

      if (!isLoggedIn && !isAuthRoute) return '/landing';
      if (isLoggedIn && isAuthRoute) return '/dashboard';
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/add-transaction',
        builder: (context, state) => const AddTransactionScreen(),
      ),
    ],
  );
});

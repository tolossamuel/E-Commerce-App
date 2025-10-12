import 'package:ecommerce/feature/auth/presentation/ui/screen/start_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => StartScreen()),
    
  ],
);
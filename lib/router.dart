import 'package:go_router/go_router.dart';
import 'ui/screens/server_list_screen.dart';
import 'ui/screens/project_list_screen.dart';
import 'ui/screens/project_detail_screen.dart';
import 'ui/screens/settings_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ServerListScreen(),
    ),
    GoRoute(
      path: '/projects/:serverId',
      builder: (context, state) {
        final serverId = state.pathParameters['serverId']!;
        return ProjectListScreen(serverId: serverId);
      },
    ),
    GoRoute(
      path: '/projects/:serverId/detail',
      builder: (context, state) {
        final serverId = state.pathParameters['serverId']!;
        final worktree = state.uri.queryParameters['worktree'] ?? '';
        return ProjectDetailScreen(serverId: serverId, worktree: worktree);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

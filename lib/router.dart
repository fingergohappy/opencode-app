import 'package:go_router/go_router.dart';
import 'ui/screens/project/list/screen.dart';
import 'ui/screens/project/session_screen.dart';
import 'ui/screens/server/session/screen.dart';
import 'ui/screens/settings/screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ServerListScreen()),
    GoRoute(
      path: '/projects/:serverId',
      builder: (context, state) {
        final serverId = state.pathParameters['serverId']!;
        return ProjectListScreen(serverId: serverId);
      },
    ),
    GoRoute(
      path: '/projects/:serverId/session',
      builder: (context, state) {
        final serverId = state.pathParameters['serverId']!;
        final worktree = state.uri.queryParameters['worktree'] ?? '';
        final sessionId = state.uri.queryParameters['session'];
        return ProjectSessionScreen(
          serverId: serverId,
          worktree: worktree,
          sessionId: sessionId,
        );
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

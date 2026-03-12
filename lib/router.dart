import 'package:go_router/go_router.dart';

import 'ui/screens/project/list/screen.dart';
import 'ui/screens/project/session/screen.dart';
import 'ui/screens/server/session/screen.dart';
import 'ui/screens/settings/screen.dart';
import 'ui/widgets/workspace_shell.dart';

/// 统一管理应用页面跳转规则。
/// ShellRoute 会保留工作区外壳，只替换内部主内容区。
final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      // ShellRoute 适合放“始终存在的外框”，比如侧边栏和主内容区布局。
      builder: (context, state, child) =>
          WorkspaceShell(state: state, child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ServerListScreen(),
        ),
        GoRoute(
          path: '/projects/:serverId',
          builder: (context, state) {
            // 必填参数通常放在 path 里，更适合标识资源身份。
            final serverId = state.pathParameters['serverId']!;
            return ProjectListScreen(serverId: serverId);
          },
        ),
        GoRoute(
          path: '/projects/:serverId/session',
          builder: (context, state) {
            final serverId = state.pathParameters['serverId']!;
            // 可选参数通过 query 传递，便于在同一路径下切换不同会话。
            // 这里把“项目位置”和“会话编号”拆开，表示会话页既能打开已有会话，也能创建新会话。
            final worktree = state.uri.queryParameters['worktree'] ?? '';
            final sessionId = state.uri.queryParameters['session'];
            return ProjectSessionScreen(
              serverId: serverId,
              worktree: worktree,
              sessionId: sessionId,
            );
          },
        ),
      ],
    ),
    // 设置页放在 ShellRoute 外面，说明它不复用工作区壳层布局。
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

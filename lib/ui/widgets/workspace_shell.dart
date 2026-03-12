import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_drawer.dart';

/// 工作区外壳。
/// 它根据当前路由决定标题、是否展示服务器侧栏，以及内容区显示什么页面。
class WorkspaceShell extends StatelessWidget {
  final GoRouterState state;
  final Widget child;

  const WorkspaceShell({super.key, required this.state, required this.child});

  /// 根路径对应服务器列表页。
  bool get _isServerRoute => state.matchedLocation == '/';

  String? get _serverId => state.pathParameters['serverId'];

  /// 从 query 中取出当前工作目录；为空时说明还停留在项目列表层级。
  String? get _worktree {
    final worktree = state.uri.queryParameters['worktree'];
    if (worktree == null || worktree.isEmpty) {
      return null;
    }
    return worktree;
  }

  String? get _sessionId => state.uri.queryParameters['session'];

  /// AppBar 标题并不是写死的，而是根据当前路由上下文动态推导。
  String get _title {
    if (_isServerRoute) {
      return 'Servers';
    }

    final worktree = _worktree;
    if (worktree == null) {
      return 'Projects';
    }

    final parts = worktree.split('/').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return 'Session';
    }
    return parts.last;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 宽屏时把导航面板固定在左侧，窄屏时退化成 Drawer。
        final showPinnedSidebar = constraints.maxWidth >= 960;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: colorScheme.surface,
            elevation: 2,
            title: Text(
              _title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: colorScheme.onSurface,
              ),
            ),
          ),
          drawer: showPinnedSidebar
              ? null
              : AppDrawer(
                  showServers: _isServerRoute,
                  serverId: _serverId,
                  worktree: _worktree,
                  sessionId: _sessionId,
                ),
          body: Row(
            children: [
              if (showPinnedSidebar)
                SizedBox(
                  width: 320,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        right: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: AppNavigationPanel(
                      showServers: _isServerRoute,
                      serverId: _serverId,
                      worktree: _worktree,
                      sessionId: _sessionId,
                    ),
                  ),
                ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}

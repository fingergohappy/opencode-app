import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/server_store.dart';
import '../../models/api_models.dart';
import '../../models/project.dart';
import '../../models/server_config.dart';
import '../../network/api.dart';
import '../../network/opencode_client.dart';
import 'drawer/icon_rail.dart';
import 'drawer/project_sidebar.dart';
import 'drawer/server_sidebar.dart';

/// Drawer 只是一个壳，真正的导航逻辑在 AppNavigationPanel 里。
class AppDrawer extends StatelessWidget {
  final bool showServers;
  final String? serverId;
  final String? worktree;
  final String? sessionId;

  const AppDrawer({
    super.key,
    this.showServers = true,
    this.serverId,
    this.worktree,
    this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: AppNavigationPanel(
        showServers: showServers,
        serverId: serverId,
        worktree: worktree,
        sessionId: sessionId,
        isDrawer: true,
      ),
    );
  }
}

/// 左侧导航面板。
/// 它会根据当前是否选中了 server/project，动态加载并展示不同层级的数据。
class AppNavigationPanel extends StatefulWidget {
  final bool showServers;
  final String? serverId;
  final String? worktree;
  final String? sessionId;
  final bool isDrawer;

  const AppNavigationPanel({
    super.key,
    this.showServers = true,
    this.serverId,
    this.worktree,
    this.sessionId,
    this.isDrawer = false,
  });

  @override
  State<AppNavigationPanel> createState() => _AppNavigationPanelState();
}

class _AppNavigationPanelState extends State<AppNavigationPanel> {
  final _serverStore = ServerStore();

  List<Project> _projects = [];
  List<Session> _sessions = [];
  Project? _selectedProject;

  List<ServerConfig> _servers = [];
  ServerConfig? _selectedServer;

  bool _loading = true;

  bool get _isServerMode => widget.serverId == null;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant AppNavigationPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 侧边栏本身不会因为路由变化而销毁，所以要在这里手动监听关键参数变化并重载数据。
    if (widget.serverId != oldWidget.serverId ||
        widget.worktree != oldWidget.worktree ||
        widget.sessionId != oldWidget.sessionId ||
        widget.showServers != oldWidget.showServers) {
      _loadData();
    }
  }

  /// 每次路由上下文变化时，重新同步侧边栏所需的数据。
  Future<void> _loadData() async {
    setState(() {
      _loading = true;
    });

    // 先同步服务器列表，再决定当前选中的服务器是谁。
    await _serverStore.ensureDefault();
    final servers = await _serverStore.getAll();

    ServerConfig? selectedServer;
    if (widget.serverId != null) {
      for (final server in servers) {
        if (server.id == widget.serverId) {
          selectedServer = server;
          break;
        }
      }
    }
    // 当 URL 没有明确指出 server，或者本地配置已变化时，退回到第一个可用 server 作为兜底选择。
    selectedServer ??= servers.isNotEmpty ? servers.first : null;

    if (!mounted) return;

    setState(() {
      _servers = servers;
      _selectedServer = selectedServer;
      _projects = [];
      _sessions = [];
      _selectedProject = null;
    });

    // 在服务器模式下不需要继续请求项目和会话数据。
    if (_isServerMode || selectedServer == null) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
      return;
    }

    // 进入项目模式后，再基于当前服务器去拉取项目和会话。
    final client = OpenCodeClient(selectedServer.baseUrl);
    final projectApi = ProjectApi(client);
    final sessionApi = SessionApi(client);
    final projects = await projectApi.getProjects();

    Project? selectedProject;
    if (widget.worktree != null && widget.worktree!.isNotEmpty) {
      for (final project in projects) {
        if (project.worktree == widget.worktree) {
          selectedProject = project;
          break;
        }
      }
    }
    // 会话列表依附于“当前项目”，所以只有选中项目后才继续发下一跳请求。
    selectedProject ??= projects.isNotEmpty ? projects.first : null;

    List<Session> sessions = [];
    if (selectedProject != null) {
      sessions = await sessionApi.getSessions(
        context: {'worktree': selectedProject.worktree},
      );
    }

    if (!mounted) return;

    setState(() {
      _projects = projects;
      _selectedProject = selectedProject;
      _sessions = sessions;
      _loading = false;
    });
  }

  /// 切换项目时会重新拉取当前工作目录对应的会话列表。
  Future<void> _selectProject(Project project) async {
    final server = _selectedServer;
    if (server == null) return;

    setState(() {
      _selectedProject = project;
      _sessions = [];
      _loading = true;
    });

    final client = OpenCodeClient(server.baseUrl);
    final sessionApi = SessionApi(client);
    final sessions = await sessionApi.getSessions(
      context: {'worktree': project.worktree},
    );

    if (!mounted) return;

    setState(() {
      _sessions = sessions;
      _loading = false;
    });
  }

  /// 创建新会话其实是跳到“当前项目 + 无 sessionId”的会话页。
  void _createNewSession() {
    final project = _selectedProject;
    final serverId = widget.serverId;
    if (project == null || serverId == null) return;

    _closeDrawerIfNeeded();
    // 只传 worktree、不传 session，表示让目标页面按“新建会话”模式初始化。
    context.go(
      '/projects/$serverId/session?worktree=${Uri.encodeComponent(project.worktree)}',
    );
  }

  void _closeDrawerIfNeeded() {
    if (widget.isDrawer) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ColoredBox(
      color: colorScheme.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerIconRail(
            isServerMode: _isServerMode,
            servers: _servers,
            projects: _projects,
            selectedServer: _selectedServer,
            selectedProject: _selectedProject,
            onSelectServer: (server) {
              setState(() {
                _selectedServer = server;
              });
            },
            onSelectProject: _selectProject,
            serverId: widget.serverId,
            isDrawer: widget.isDrawer,
          ),
          Container(
            width: 1,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _isServerMode
                ? ServerSidebar(
                    servers: _servers,
                    selectedServer: _selectedServer,
                    onSelectServer: (server) {
                      setState(() {
                        _selectedServer = server;
                      });
                    },
                    isDrawer: widget.isDrawer,
                  )
                : ProjectSidebar(
                    selectedProject: _selectedProject,
                    sessions: _sessions,
                    serverId: widget.serverId,
                    selectedSessionId: widget.sessionId,
                    onCreateSession: _createNewSession,
                    isDrawer: widget.isDrawer,
                  ),
          ),
        ],
      ),
    );
  }
}

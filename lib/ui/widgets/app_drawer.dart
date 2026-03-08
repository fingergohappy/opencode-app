import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../models/api_models.dart';
import '../../models/server_config.dart';
import '../../data/server_store.dart';
import 'drawer/icon_rail.dart';
import 'drawer/server_sidebar.dart';
import 'drawer/project_sidebar.dart';

export 'app_scaffold.dart';

class AppDrawer extends StatefulWidget {
  final bool showServers;
  final String? serverId;
  final List<Project>? projects;
  final List<Session>? sessions;

  const AppDrawer({
    super.key,
    this.showServers = true,
    this.serverId,
    this.projects,
    this.sessions,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
  void didUpdateWidget(AppDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.projects != oldWidget.projects ||
        widget.sessions != oldWidget.sessions) {
      _updateFromExternalData();
    }
  }

  void _updateFromExternalData() {
    setState(() {
      if (widget.projects != null) {
        _projects = widget.projects!;
        _selectedProject = _projects.isNotEmpty ? _projects.first : null;
      }
      if (widget.sessions != null) {
        _sessions = widget.sessions!;
      }
      _loading = false;
    });
  }

  Future<void> _loadData() async {
    final serverStore = ServerStore();

    if (_isServerMode) {
      await serverStore.ensureDefault();
      final servers = await serverStore.getAll();
      setState(() {
        _servers = servers;
        _selectedServer = servers.isNotEmpty ? servers.first : null;
        _loading = false;
      });
      return;
    }

    if (widget.projects != null) {
      _updateFromExternalData();
      return;
    }

    setState(() {
      _projects = [];
      _sessions = [];
      _selectedProject = null;
      _loading = false;
    });
  }

  void _createNewSession() {
    if (_selectedProject == null) return;
    // TODO: Implement session creation API
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return const Drawer(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    const bottomMargin = 24.0;

    return Drawer(
      width: screenWidth,
      child: Container(
        height: screenHeight - topPadding - bottomMargin,
        margin: EdgeInsets.only(top: topPadding),
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
                setState(() => _selectedServer = server);
              },
              onSelectProject: (project) {
                setState(() => _selectedProject = project);
              },
              serverId: widget.serverId,
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
                        setState(() => _selectedServer = server);
                      },
                    )
                  : ProjectSidebar(
                      selectedProject: _selectedProject,
                      sessions: _sessions,
                      serverId: widget.serverId,
                      onCreateSession: _createNewSession,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

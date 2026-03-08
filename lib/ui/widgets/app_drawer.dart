import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/project.dart';
import '../../models/api_models.dart';
import '../../models/server_config.dart';
import '../../network/opencode_client.dart';
import '../../network/api.dart';
import '../../data/server_store.dart';

class AppDrawer extends StatefulWidget {
  final bool showServers;
  final String? serverId;

  const AppDrawer({super.key, this.showServers = true, this.serverId});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // For project mode
  List<Project> _projects = [];
  List<Session> _sessions = [];
  Project? _selectedProject;
  OpenCodeClient? _client;

  // For server mode (when serverId is null)
  List<ServerConfig> _servers = [];
  ServerConfig? _selectedServer;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final serverStore = ServerStore();

    if (widget.serverId == null) {
      // Server mode - load all servers
      await serverStore.ensureDefault();
      final servers = await serverStore.getAll();
      setState(() {
        _servers = servers;
        _selectedServer = servers.isNotEmpty ? servers.first : null;
        _loading = false;
      });
      return;
    }

    // Project mode - load projects and sessions for the server
    final server = await serverStore.getById(widget.serverId!);
    if (server == null) {
      setState(() => _loading = false);
      return;
    }

    _client = OpenCodeClient(server.baseUrl);

    final projectApi = ProjectApi(_client!);
    final sessionApi = SessionApi(_client!);

    final projects = await projectApi.getProjects();
    final sessions = await sessionApi.getSessions();

    setState(() {
      _projects = projects;
      _sessions = sessions;
      _selectedProject = projects.isNotEmpty ? projects.first : null;
      _loading = false;
    });
  }

  Future<void> _createNewSession() async {
    if (_client == null || _selectedProject == null) return;
    // TODO: Implement session creation API
    // For now, just refresh the session list
    await _loadData();
  }

  List<Session> _getSessionsForProject(String projectId) {
    return _sessions.where((s) => s.projectID == projectId).toList();
  }

  String _getProjectInitial(Project project) {
    final iconOverride = project.icon?.override;
    if (iconOverride != null && iconOverride.isNotEmpty) {
      return iconOverride[0].toUpperCase();
    }
    final name = project.worktree == '/' ? 'Global' : project.worktree.split('/').last;
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _getProjectName(Project project) {
    return project.worktree == '/' ? 'Global' : project.worktree.split('/').last;
  }

  Color _getProjectColor(Project project) {
    final hexColor = project.icon?.color;
    if (hexColor != null && hexColor.startsWith('#')) {
      try {
        return Color(int.parse(hexColor.substring(1), radix: 16) + 0xFF000000);
      } catch (_) {}
    }
    return Theme.of(context).colorScheme.primary;
  }

  String _getServerInitial(ServerConfig server) {
    return server.name.isNotEmpty ? server.name[0].toUpperCase() : 'S';
  }

  bool get _isServerMode => widget.serverId == null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return Drawer(
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
            // Icon Rail (narrow column)
            _buildIconRail(context, colorScheme),
            // Divider
            Container(
              width: 1,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            // Sidebar List (wider column) - takes remaining width
            Expanded(
              child: _isServerMode
                  ? _buildServerSidebarContent(context, colorScheme)
                  : _buildProjectSidebarContent(context, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconRail(BuildContext context, ColorScheme colorScheme) {
    return SizedBox(
      width: 56,
      child: Column(
        children: [
          // Menu icon at top to close drawer - aligns with AppBar leading icon
          Tooltip(
            message: 'Close',
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Scrollable icons area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // Icons (servers or projects)
                  ..._isServerMode
                      ? _servers.map((server) => _buildServerIcon(server, colorScheme))
                      : _projects.map((project) => _buildProjectIcon(project, colorScheme)),
                  // Add new button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Tooltip(
                      message: _isServerMode ? 'Add Server' : 'New Project',
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            if (_isServerMode) {
                              // Navigate to server list to add new server
                              context.go('/');
                            } else {
                              // Navigate to project list to add new project
                              context.push('/projects/${widget.serverId}');
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.outline.withValues(alpha: 0.5),
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom icons (settings and servers)
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Tooltip(
                  message: 'Settings',
                  child: IconButton(
                    icon: Icon(Icons.settings_outlined, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/settings');
                    },
                  ),
                ),
                Tooltip(
                  message: 'Servers',
                  child: IconButton(
                    icon: Icon(Icons.dns_outlined, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerIcon(ServerConfig server, ColorScheme colorScheme) {
    final isSelected = _selectedServer?.id == server.id;
    final initial = _getServerInitial(server);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: server.name,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedServer = server;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary.withValues(alpha: 0.2) : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: TextStyle(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectIcon(Project project, ColorScheme colorScheme) {
    final isSelected = _selectedProject?.id == project.id;
    final initial = _getProjectInitial(project);
    final iconColor = _getProjectColor(project);
    final projectName = _getProjectName(project);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: projectName,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedProject = project;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? iconColor.withValues(alpha: 0.2) : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: iconColor, width: 2)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: TextStyle(
                  color: isSelected ? iconColor : colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServerSidebarContent(BuildContext context, ColorScheme colorScheme) {
    if (_selectedServer == null) {
      return Center(
        child: Text(
          'Select a server',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header with server name
        Container(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedServer!.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                '${_selectedServer!.host}:${_selectedServer!.port}',
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Connect button
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push('/projects/${_selectedServer!.id}');
              },
              icon: Icon(Icons.login, size: 18),
              label: Text('Connect'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        // Server list - scrollable
        Expanded(
          child: _servers.isEmpty
              ? Center(
                  child: Text(
                    'No servers configured',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _servers.length,
                  itemBuilder: (context, index) {
                    final server = _servers[index];
                    return _buildServerListItem(server, colorScheme);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildServerListItem(ServerConfig server, ColorScheme colorScheme) {
    final isSelected = _selectedServer?.id == server.id;

    return ListTile(
      dense: true,
      selected: isSelected,
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          _getServerInitial(server),
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
        ),
      ),
      title: Text(
        server.name,
        style: TextStyle(fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${server.host}:${server.port}',
        style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
      ),
      onTap: () {
        setState(() {
          _selectedServer = server;
        });
      },
    );
  }

  Widget _buildProjectSidebarContent(BuildContext context, ColorScheme colorScheme) {
    if (_selectedProject == null) {
      return Center(
        child: Text(
          'Select a project',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    final projectName = _getProjectName(_selectedProject!);
    final projectSessions = _getSessionsForProject(_selectedProject!.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header with project name
        Container(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      _selectedProject!.worktree,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // New Session button
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _createNewSession,
              icon: Icon(Icons.add, size: 18),
              label: Text('New Session'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        // Session list - scrollable
        Expanded(
          child: projectSessions.isEmpty
              ? Center(
                  child: Text(
                    'No sessions yet',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: projectSessions.length,
                  itemBuilder: (context, index) {
                    final session = projectSessions[index];
                    return _buildSessionItem(session, colorScheme);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSessionItem(Session session, ColorScheme colorScheme) {
    return ListTile(
      dense: true,
      leading: Icon(
        Icons.chat_bubble_outline,
        size: 18,
        color: colorScheme.onSurfaceVariant,
      ),
      title: Text(
        session.title.isNotEmpty ? session.title : 'Untitled',
        style: TextStyle(fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete_outline,
          size: 18,
          color: colorScheme.error.withValues(alpha: 0.7),
        ),
        onPressed: () {
          // TODO: Delete session
        },
      ),
      onTap: () {
        Navigator.pop(context);
        // Navigate to session detail
        if (widget.serverId != null && _selectedProject != null) {
          context.push(
            '/projects/${widget.serverId}/detail?worktree=${Uri.encodeComponent(_selectedProject!.worktree)}&session=${session.id}',
          );
        }
      },
    );
  }
}

/// Scaffold wrapper that includes the app drawer
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showDrawer;
  final bool showServersInDrawer;
  final String? serverId;

  const AppScaffold({
    super.key,
    required this.body,
    this.title = 'OpenCode',
    this.titleWidget,
    this.actions,
    this.floatingActionButton,
    this.showDrawer = true,
    this.showServersInDrawer = true,
    this.serverId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 2,
        leading: showDrawer
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
        title: titleWidget ??
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: colorScheme.onSurface,
              ),
            ),
        actions: actions,
      ),
      drawer: showDrawer ? AppDrawer(showServers: showServersInDrawer, serverId: serverId) : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

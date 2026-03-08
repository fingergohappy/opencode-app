import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/project.dart';
import '../../../models/server_config.dart';
import 'utils.dart';

class DrawerIconRail extends StatelessWidget {
  final bool isServerMode;
  final List<ServerConfig> servers;
  final List<Project> projects;
  final ServerConfig? selectedServer;
  final Project? selectedProject;
  final void Function(ServerConfig) onSelectServer;
  final void Function(Project) onSelectProject;
  final String? serverId;

  const DrawerIconRail({
    super.key,
    required this.isServerMode,
    required this.servers,
    required this.projects,
    this.selectedServer,
    this.selectedProject,
    required this.onSelectServer,
    required this.onSelectProject,
    this.serverId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 56,
      child: Column(
        children: [
          // Menu icon at top to close drawer
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
                  ...isServerMode
                      ? servers.map((server) => _ServerIcon(
                          server: server,
                          isSelected: selectedServer?.id == server.id,
                          colorScheme: colorScheme,
                          onTap: () => onSelectServer(server),
                        ))
                      : projects.map((project) => _ProjectIcon(
                          project: project,
                          isSelected: selectedProject?.id == project.id,
                          colorScheme: colorScheme,
                          onTap: () => onSelectProject(project),
                        )),
                  // Add new button
                  _AddButton(
                    isServerMode: isServerMode,
                    colorScheme: colorScheme,
                    serverId: serverId,
                  ),
                ],
              ),
            ),
          ),
          // Bottom icons
          const Divider(height: 1),
          _BottomIcons(colorScheme: colorScheme),
        ],
      ),
    );
  }
}

class _ServerIcon extends StatelessWidget {
  final ServerConfig server;
  final bool isSelected;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _ServerIcon({
    required this.server,
    required this.isSelected,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initial = getServerInitial(server);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: server.name,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.2)
                    : colorScheme.surfaceContainerHighest,
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
}

class _ProjectIcon extends StatelessWidget {
  final Project project;
  final bool isSelected;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _ProjectIcon({
    required this.project,
    required this.isSelected,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initial = getProjectInitial(project);
    final iconColor = getProjectColor(project, colorScheme.primary);
    final projectName = getProjectName(project);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: projectName,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? iconColor.withValues(alpha: 0.2)
                    : colorScheme.surfaceContainerHighest,
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
}

class _AddButton extends StatelessWidget {
  final bool isServerMode;
  final ColorScheme colorScheme;
  final String? serverId;

  const _AddButton({
    required this.isServerMode,
    required this.colorScheme,
    this.serverId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: isServerMode ? 'Add Server' : 'New Project',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              if (isServerMode) {
                context.go('/');
              } else {
                context.push('/projects/$serverId');
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
    );
  }
}

class _BottomIcons extends StatelessWidget {
  final ColorScheme colorScheme;

  const _BottomIcons({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

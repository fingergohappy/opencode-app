import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/project.dart';
import '../../../models/api_models.dart';
import 'utils.dart';

/// 项目侧栏负责展示当前项目信息和该项目下的会话列表。
class ProjectSidebar extends StatelessWidget {
  final Project? selectedProject;
  final List<Session> sessions;
  final String? serverId;
  final String? selectedSessionId;
  final VoidCallback onCreateSession;
  final bool isDrawer;

  const ProjectSidebar({
    super.key,
    required this.selectedProject,
    required this.sessions,
    required this.serverId,
    this.selectedSessionId,
    required this.onCreateSession,
    this.isDrawer = true,
  });

  /// 后端返回的 sessions 可能混有别的项目，这里再按 projectId 做一次过滤。
  List<Session> _getSessionsForProject(String projectId) {
    return sessions.where((s) => s.projectID == projectId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (selectedProject == null) {
      return Center(
        child: Text(
          'Select a project',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    final projectName = getProjectName(selectedProject!);
    final projectSessions = _getSessionsForProject(selectedProject!.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(project: selectedProject!, projectName: projectName),
        const Divider(height: 1),
        _NewSessionButton(onPressed: onCreateSession),
        Expanded(
          child: projectSessions.isEmpty
              ? _EmptyState(colorScheme: colorScheme)
              : _SessionList(
                  sessions: projectSessions,
                  serverId: serverId,
                  selectedProject: selectedProject,
                  selectedSessionId: selectedSessionId,
                  colorScheme: colorScheme,
                  isDrawer: isDrawer,
                ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Project project;
  final String projectName;

  const _Header({required this.project, required this.projectName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
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
          const SizedBox(height: 2),
          Text(
            project.worktree,
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
    );
  }
}

class _NewSessionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _NewSessionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('New Session'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ColorScheme colorScheme;

  const _EmptyState({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No sessions yet',
        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
      ),
    );
  }
}

class _SessionList extends StatelessWidget {
  final List<Session> sessions;
  final String? serverId;
  final Project? selectedProject;
  final String? selectedSessionId;
  final ColorScheme colorScheme;
  final bool isDrawer;

  const _SessionList({
    required this.sessions,
    required this.serverId,
    required this.selectedProject,
    required this.selectedSessionId,
    required this.colorScheme,
    required this.isDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];

        return ListTile(
          dense: true,
          selected: session.id == selectedSessionId,
          leading: Icon(
            Icons.chat_bubble_outline,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          title: Text(
            session.title.isNotEmpty ? session.title : 'Untitled',
            style: const TextStyle(fontSize: 13),
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
              // 会话删除接口还没接上，所以这里只保留占位入口。
              // TODO: Delete session
            },
          ),
          onTap: () {
            if (isDrawer) {
              Navigator.pop(context);
            }
            if (serverId != null && selectedProject != null) {
              context.go(
                '/projects/$serverId/session?worktree=${Uri.encodeComponent(selectedProject!.worktree)}&session=${session.id}',
              );
            }
          },
        );
      },
    );
  }
}

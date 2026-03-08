import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../models/api_models.dart';
import 'app_drawer.dart';

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
  final List<Project>? drawerProjects;
  final List<Session>? drawerSessions;

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
    this.drawerProjects,
    this.drawerSessions,
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
      drawer: showDrawer
          ? AppDrawer(
              showServers: showServersInDrawer,
              serverId: serverId,
              projects: drawerProjects,
              sessions: drawerSessions,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

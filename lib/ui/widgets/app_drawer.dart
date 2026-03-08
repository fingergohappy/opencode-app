import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final bool showServers;

  const AppDrawer({super.key, this.showServers = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          const Spacer(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
                if (showServers)
                  IconButton(
                    icon: const Icon(Icons.dns),
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/');
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
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

  const AppScaffold({
    super.key,
    required this.body,
    this.title = 'OpenCode',
    this.titleWidget,
    this.actions,
    this.floatingActionButton,
    this.showDrawer = true,
    this.showServersInDrawer = true,
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
      drawer: showDrawer ? AppDrawer(showServers: showServersInDrawer) : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

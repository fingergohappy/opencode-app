import 'package:flutter/material.dart';
import 'app_drawer.dart';

/// 通用页面骨架。
/// 把 AppBar、Drawer 和主体布局统一起来，减少各个页面重复写 Scaffold。
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showDrawer;

  const AppScaffold({
    super.key,
    required this.body,
    this.title = 'OpenCode',
    this.titleWidget,
    this.actions,
    this.floatingActionButton,
    this.showDrawer = true,
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
        title:
            titleWidget ??
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
      drawer: showDrawer ? const AppDrawer() : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

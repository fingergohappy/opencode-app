import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String serverId;
  final String worktree;

  const ProjectDetailScreen({
    super.key,
    required this.serverId,
    required this.worktree,
  });

  @override
  Widget build(BuildContext context) {
    final name = worktree == '/' ? 'global' : worktree.split('/').last;

    return AppScaffold(
      serverId: serverId,
      title: name,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Server ID: $serverId', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Worktree: $worktree', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

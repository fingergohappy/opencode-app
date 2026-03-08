import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/server_config.dart';
import 'utils.dart';

class ServerSidebar extends StatelessWidget {
  final List<ServerConfig> servers;
  final ServerConfig? selectedServer;
  final void Function(ServerConfig) onSelectServer;

  const ServerSidebar({
    super.key,
    required this.servers,
    required this.selectedServer,
    required this.onSelectServer,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (selectedServer == null) {
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
        _Header(server: selectedServer!),
        const Divider(height: 1),
        _ConnectButton(server: selectedServer!),
        Expanded(
          child: servers.isEmpty
              ? _EmptyState(colorScheme: colorScheme)
              : _ServerList(
                  servers: servers,
                  selectedServer: selectedServer,
                  colorScheme: colorScheme,
                  onSelectServer: onSelectServer,
                ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ServerConfig server;

  const _Header({required this.server});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            server.name,
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
            '${server.host}:${server.port}',
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

class _ConnectButton extends StatelessWidget {
  final ServerConfig server;

  const _ConnectButton({required this.server});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            context.push('/projects/${server.id}');
          },
          icon: const Icon(Icons.login, size: 18),
          label: const Text('Connect'),
          style: ElevatedButton.styleFrom(
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
        'No servers configured',
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _ServerList extends StatelessWidget {
  final List<ServerConfig> servers;
  final ServerConfig? selectedServer;
  final ColorScheme colorScheme;
  final void Function(ServerConfig) onSelectServer;

  const _ServerList({
    required this.servers,
    required this.selectedServer,
    required this.colorScheme,
    required this.onSelectServer,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: servers.length,
      itemBuilder: (context, index) {
        final server = servers[index];
        final isSelected = selectedServer?.id == server.id;

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
              getServerInitial(server),
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
            style: const TextStyle(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${server.host}:${server.port}',
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          onTap: () => onSelectServer(server),
        );
      },
    );
  }
}

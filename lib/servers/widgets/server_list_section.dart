import 'package:flutter/material.dart';

import '../model.dart';
import 'server_tile.dart';

/// 服务器列表区域，仅负责布局，不处理业务逻辑
class ServerListSection extends StatelessWidget {
  const ServerListSection({
    super.key,
    required this.servers,
    required this.selected,
    required this.health,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Server> servers;
  final Server? selected;
  final ServerHealthStatus? health;
  final ValueChanged<Server> onTap;
  final ValueChanged<Server> onEdit;
  final ValueChanged<Server> onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: servers.length,
      itemBuilder: (context, index) {
        final server = servers[index];
        final isSelected = selected != null && selected!.url == server.url;
        return ServerTile(
          server: server,
          selected: isSelected,
          isCurrentHealthTarget: isSelected,
          health: health,
          onTap: () => onTap(server),
          onEdit: () => onEdit(server),
          onDelete: () => onDelete(server),
        );
      },
    );
  }
}

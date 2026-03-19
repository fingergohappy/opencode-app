import 'package:flutter/material.dart';

import '../model.dart';
import 'server_health_badge.dart';

/// 服务器列表项，支持左滑露出编辑/删除操作
class ServerTile extends StatefulWidget {
  const ServerTile({
    super.key,
    required this.server,
    required this.selected,
    required this.isCurrentHealthTarget,
    this.health,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Server server;
  final bool selected;

  /// 是否是当前健康检测目标（即当前选中服务器）
  final bool isCurrentHealthTarget;
  final ServerHealthStatus? health;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<ServerTile> createState() => _ServerTileState();
}

class _ServerTileState extends State<ServerTile>
    with SingleTickerProviderStateMixin {
  static const _actionWidth = 140.0; // 两个操作按钮总宽度
  static const _tileRadius = BorderRadius.all(Radius.circular(16));

  late final AnimationController _controller;
  late final Animation<double> _offsetAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _offsetAnim = Tween<double>(
      begin: 0,
      end: -_actionWidth,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open() => _controller.forward();
  void _close() => _controller.reverse();
  void _toggle() => _controller.isCompleted ? _close() : _open();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ClipRRect(
        borderRadius: _tileRadius,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          // 左滑展开，右滑收起
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;
            if (details.primaryVelocity! < -200) {
              _open();
            } else if (details.primaryVelocity! > 200) {
              _close();
            } else {
              _toggle();
            }
          },
          // 点击空白处收起
          onTap: () {
            if (_controller.isCompleted) {
              _close();
            } else {
              widget.onTap();
            }
          },
          child: Stack(
            children: [
              // 操作按钮层（始终在底部）
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final isActionPaneVisible = _controller.value > 0;
                    return IgnorePointer(
                      ignoring: !isActionPaneVisible,
                      child: ExcludeSemantics(
                        excluding: !isActionPaneVisible,
                        child: child,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _ActionButton(
                        label: '编辑',
                        icon: Icons.edit_outlined,
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        foregroundColor: colorScheme.primary,
                        width: _actionWidth / 2,
                        onTap: () {
                          _close();
                          widget.onEdit();
                        },
                      ),
                      _ActionButton(
                        label: '删除',
                        icon: Icons.delete_outline,
                        backgroundColor: colorScheme.errorContainer.withValues(
                          alpha: 0.58,
                        ),
                        foregroundColor: colorScheme.error,
                        width: _actionWidth / 2,
                        onTap: () {
                          _close();
                          widget.onDelete();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // 列表项内容层（随手势平移）
              AnimatedBuilder(
                animation: _offsetAnim,
                builder: (context, child) => Transform.translate(
                  offset: Offset(_offsetAnim.value, 0),
                  child: child,
                ),
                child: _TileContent(
                  server: widget.server,
                  selected: widget.selected,
                  health: widget.isCurrentHealthTarget ? widget.health : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileContent extends StatelessWidget {
  const _TileContent({
    required this.server,
    required this.selected,
    required this.health,
  });

  final Server server;
  final bool selected;
  final ServerHealthStatus? health;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = server.name ?? server.url;
    final backgroundColor = selected
        ? Color.alphaBlend(
            colorScheme.primary.withValues(alpha: 0.08),
            colorScheme.surfaceContainerLow,
          )
        : colorScheme.surfaceContainerLow;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: _ServerTileState._tileRadius,
        side: BorderSide(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          width: selected ? 1.2 : 1,
        ),
      ),
      color: backgroundColor,
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: _ServerTileState._tileRadius,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: _SelectionIndicator(
          selected: selected,
          color: selected ? colorScheme.primary : colorScheme.outline,
        ),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        // 有 name 时才显示 url 副标题
        subtitle: server.name != null
            ? Text(
                server.url,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (server.isDefault)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.32),
                  ),
                ),
                child: Text(
                  '默认',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ServerHealthBadge(health: health),
          ],
        ),
        minVerticalPadding: 12,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.width,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: foregroundColor.withValues(alpha: 0.24)),
        ),
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.4),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(1.5),
        ),
      ),
    );
  }
}

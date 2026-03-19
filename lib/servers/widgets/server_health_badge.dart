import 'package:flutter/material.dart';

import '../model.dart';

/// 服务器健康状态徽标
///
/// - healthy == true：在线（附带 version）
/// - healthy == false：离线（可点击查看 error）
/// - null：未检测
class ServerHealthBadge extends StatelessWidget {
  const ServerHealthBadge({super.key, required this.health});

  final ServerHealthStatus? health;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (health == null) {
      return _Badge(
        backgroundColor: colorScheme.surfaceContainerHighest,
        borderColor: colorScheme.outlineVariant,
        foregroundColor: colorScheme.onSurface,
        label: '未检测',
        labelStyle: textTheme.labelSmall?.copyWith(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      );
    }

    if (health!.healthy) {
      final label = health!.version != null ? '在线 ${health!.version}' : '在线';
      return _Badge(
        backgroundColor: Colors.green.withValues(alpha: 0.12),
        borderColor: Colors.green.withValues(alpha: 0.36),
        foregroundColor: Colors.green,
        label: label,
        labelStyle: textTheme.labelSmall?.copyWith(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      );
    }

    // 离线：点击显示错误详情
    return GestureDetector(
      onTap: health!.error != null
          ? () => _showError(context, health!.error!)
          : null,
      child: _Badge(
        backgroundColor: colorScheme.error.withValues(alpha: 0.12),
        borderColor: colorScheme.error.withValues(alpha: 0.36),
        foregroundColor: colorScheme.error,
        label: '离线',
        labelStyle: textTheme.labelSmall?.copyWith(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  void _showError(BuildContext context, String error) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('连接错误'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.label,
    this.labelStyle,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final String label;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: (labelStyle ?? const TextStyle()).copyWith(
          color: foregroundColor,
        ),
      ),
    );
  }
}

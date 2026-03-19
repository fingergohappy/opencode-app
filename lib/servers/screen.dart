import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model.dart';
import 'providers.dart';
import 'widgets/server_form_sheet.dart';
import 'widgets/server_list_section.dart';
import 'widgets/server_search_bar.dart';
import 'widgets/servers_empty_state.dart';

/// 服务器页面内容区域
///
/// 不自行创建 Scaffold/AppBar，由全局 layout 承载
class ServersScreen extends ConsumerStatefulWidget {
  const ServersScreen({super.key});

  @override
  ConsumerState<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends ConsumerState<ServersScreen> {
  static const _kFabInset = 16.0;
  static const _kFabReservedHeight = 96.0;
  static const _kSearchBarHeight = 72.0;
  static const _kSearchBarGap = 16.0;
  static const _kSearchBarCenterRatio = 1 / 3;
  static const _kMinScrollableHeight = 96.0;

  String _query = '';

  // ── 过滤 ──────────────────────────────────────────────────────────────────

  List<Server> _filter(List<Server> servers) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return servers;
    return servers.where((s) {
      return (s.name?.toLowerCase().contains(q) ?? false) ||
          s.url.toLowerCase().contains(q);
    }).toList();
  }

  // ── 操作 ──────────────────────────────────────────────────────────────────

  Future<void> _openAdd() async {
    final result = await ServerFormSheet.show(context);
    if (result == null || !mounted) return;
    try {
      await ref.read(serversControllerProvider.notifier).addServer(result);
    } catch (e) {
      _showError('添加失败：$e');
    }
  }

  Future<void> _openEdit(Server server) async {
    final result = await ServerFormSheet.show(context, initialValue: server);
    if (result == null || !mounted) return;
    try {
      await ref
          .read(serversControllerProvider.notifier)
          .updateServer(server.url, result);
    } catch (e) {
      _showError('保存失败：$e');
    }
  }

  Future<void> _confirmDelete(Server server) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除服务器'),
        content: Text('确定要删除「${server.name ?? server.url}」吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref
          .read(serversControllerProvider.notifier)
          .removeServer(server.url);
    } catch (e) {
      _showError('删除失败：$e');
    }
  }

  void _selectServer(Server server) {
    try {
      ref.read(serversControllerProvider.notifier).selectServer(server.url);
    } catch (e) {
      _showError('切换失败：$e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ── 构建 ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final servers = ref.watch(serversProvider);
    final selected = ref.watch(selectedServerProvider);
    final health = ref.watch(healthStatusProvider);
    final filtered = _filter(servers);

    final safeAreaBottom = MediaQuery.paddingOf(context).bottom;
    final listBottomPadding =
        (servers.isNotEmpty ? _kFabReservedHeight : 32) + safeAreaBottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 搜索框固定在内容区约 1/3 的位置，同时保证下方始终保留可滚动空间。
        final maxSearchBarTop = math.max(
          0.0,
          constraints.maxHeight - _kSearchBarHeight - _kMinScrollableHeight,
        );
        final searchBarTop =
            (constraints.maxHeight * _kSearchBarCenterRatio -
                    _kSearchBarHeight / 2)
                .clamp(0.0, maxSearchBarTop);
        final listTop = searchBarTop + _kSearchBarHeight + _kSearchBarGap;

        return Stack(
          children: [
            const Positioned.fill(child: _ServersBackdrop()),
            const PositionedDirectional(
              top: 20,
              start: 20,
              end: 20,
              child: _ServersHeader(),
            ),
            PositionedDirectional(
              top: searchBarTop,
              start: 0,
              end: 0,
              child: ServerSearchBar(
                query: _query,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Positioned.fill(
              top: listTop,
              child: CustomScrollView(
                key: const ValueKey('servers-scroll-view'),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  if (servers.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          24,
                          0,
                          listBottomPadding,
                        ),
                        child: ServersEmptyState(onAdd: _openAdd),
                      ),
                    )
                  else if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          32,
                          24,
                          32,
                          listBottomPadding,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            '没有匹配的服务器',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, listBottomPadding),
                      sliver: ServerListSection(
                        servers: filtered,
                        selected: selected,
                        health: health,
                        onTap: _selectServer,
                        onEdit: _openEdit,
                        onDelete: _confirmDelete,
                      ),
                    ),
                ],
              ),
            ),
            if (servers.isNotEmpty)
              PositionedDirectional(
                end: _kFabInset,
                bottom: _kFabInset + safeAreaBottom,
                child: FloatingActionButton(
                  key: const ValueKey('servers-add-fab'),
                  onPressed: _openAdd,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  elevation: 0,
                  highlightElevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  tooltip: '新增服务器',
                  child: const Icon(Icons.add),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ServersBackdrop extends StatelessWidget {
  const _ServersBackdrop();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseColor = theme.scaffoldBackgroundColor;
    final topTint = Color.alphaBlend(
      colorScheme.surfaceContainerHigh.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.32 : 0.62,
      ),
      baseColor,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topTint, baseColor],
          stops: const [0, 0.46],
        ),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: 88,
            start: 20,
            end: 20,
            child: Container(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.48),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServersHeader extends StatelessWidget {
  const _ServersHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'CONNECTION GRID',
          style: textTheme.labelSmall?.copyWith(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '管理默认连接与服务器列表',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

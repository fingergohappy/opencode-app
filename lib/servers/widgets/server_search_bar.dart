import 'package:flutter/material.dart';

/// 服务器搜索框，按 name/url 实时过滤列表
class ServerSearchBar extends StatefulWidget {
  const ServerSearchBar({
    super.key,
    required this.query,
    required this.onChanged,
  });

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<ServerSearchBar> createState() => _ServerSearchBarState();
}

class _ServerSearchBarState extends State<ServerSearchBar> {
  late final SearchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SearchController()..text = widget.query;
  }

  @override
  void didUpdateWidget(ServerSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部清空时同步 controller
    if (widget.query.isEmpty && _controller.text.isNotEmpty) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      key: const ValueKey('servers-search-bar'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SearchBar(
        controller: _controller,
        constraints: const BoxConstraints(minHeight: 56),
        hintText: '搜索服务器名称或地址',
        leading: const Icon(Icons.search),
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(
          colorScheme.surface.withValues(alpha: 0.96),
        ),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        side: WidgetStatePropertyAll(
          BorderSide(color: colorScheme.outlineVariant),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 14),
        ),
        textStyle: WidgetStatePropertyAll(
          textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
        hintStyle: WidgetStatePropertyAll(
          textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: widget.query.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                ),
              ]
            : null,
        onChanged: widget.onChanged,
      ),
    );
  }
}

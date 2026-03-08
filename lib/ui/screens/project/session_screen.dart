import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/server_store.dart';
import '../../../models/api_models.dart';
import '../../../models/message.dart';
import '../../../models/config.dart';
import '../../../network/opencode_client.dart';
import '../../../network/api.dart';
import '../../../utils/app_logger.dart';
import '../../widgets/app_drawer.dart';

class _AgentSelector extends StatelessWidget {
  final List<Agent> agents;
  final Agent? selectedAgent;
  final void Function(Agent) onChanged;
  final ColorScheme colors;

  const _AgentSelector({
    required this.agents,
    required this.selectedAgent,
    required this.onChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedAgent?.name ?? 'Select Agent',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.unfold_more,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      },
      menuChildren: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            primary: false,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: agents.map((agent) {
                return MenuItemButton(
                  onPressed: () => onChanged(agent),
                  child: Text(agent.name),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModelSelector extends StatelessWidget {
  final List<ProviderModel> models;
  final ProviderModel? selectedModel;
  final void Function(ProviderModel) onChanged;
  final ColorScheme colors;

  const _ModelSelector({
    required this.models,
    required this.selectedModel,
    required this.onChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedModel?.name ?? 'Select Model',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.unfold_more,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      },
      menuChildren: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            primary: false,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: models.map((model) {
                return MenuItemButton(
                  onPressed: () => onChanged(model),
                  child: Text(model.name),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ThinkingStrengthSelector extends StatelessWidget {
  final ThinkingStrength strength;
  final void Function(ThinkingStrength) onChanged;
  final ColorScheme colors;

  const _ThinkingStrengthSelector({
    required this.strength,
    required this.onChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  strength.displayName,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.unfold_more,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      },
      menuChildren: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            primary: false,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ThinkingStrength.values.map((s) {
                return MenuItemButton(
                  onPressed: () => onChanged(s),
                  child: Text(s.displayName),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

const String _TAG = 'ProjectSessionScreen';
const _logger = AppLogger(_TAG);

void _log(String message) {
  _logger.info(message);
}

class ProjectSessionScreen extends StatefulWidget {
  final String serverId;
  final String worktree;
  final String? sessionId;

  const ProjectSessionScreen({
    super.key,
    required this.serverId,
    required this.worktree,
    this.sessionId,
  });

  @override
  State<ProjectSessionScreen> createState() => _ProjectSessionScreenState();
}

class _ProjectSessionScreenState extends State<ProjectSessionScreen> {
  final _serverStore = ServerStore();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  OpenCodeClient? _client;
  Session? _currentSession;
  List<Message> _messages = [];
  List<DiffFile> _diffFiles = [];
  List<Agent> _agents = [];
  List<ProviderModel> _models = [];

  Agent? _selectedAgent;
  ProviderModel? _selectedModel;
  ThinkingStrength _thinkingStrength = ThinkingStrength.medium;

  bool _loading = true;
  bool _sending = false;
  int _selectedTab = 0;

  Map<String, dynamic> get _context => {'worktree': widget.worktree};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _log('loadData: starting');
    final server = await _serverStore.getById(widget.serverId);
    if (server == null) {
      _log('loadData: server not found');
      if (mounted) context.pop();
      return;
    }

    _client = OpenCodeClient(server.baseUrl);
    final sessionApi = SessionApi(_client!);
    final configApi = ConfigApi(_client!);

    final sessions = await sessionApi.getSessions(context: _context);
    _log('loadData: got ${sessions.length} sessions');

    final appConfig = await configApi.getAppConfig();
    final agents = appConfig.agents.where((a) => a.isVisible).toList();
    _log('loadData: got ${agents.length} visible agents');

    final allModels = <ProviderModel>[];
    for (final provider in appConfig.providers) {
      allModels.addAll(provider.models);
    }
    _log('loadData: got ${allModels.length} models');

    Session? currentSession;
    List<Message> messages = [];
    List<DiffFile> diffFiles = [];

    if (widget.sessionId != null) {
      try {
        currentSession = sessions.firstWhere((s) => s.id == widget.sessionId);
      } catch (_) {
        currentSession = sessions.isNotEmpty ? sessions.first : null;
      }
    } else if (sessions.isNotEmpty) {
      currentSession = sessions.first;
    }

    if (currentSession != null && currentSession.id.isNotEmpty) {
      messages = await sessionApi.getMessages(
        currentSession.id,
        context: _context,
      );
      diffFiles = await sessionApi.getDiff(
        currentSession.id,
        context: _context,
      );
    }

    setState(() {
      _currentSession = currentSession;
      _messages = messages;
      _diffFiles = diffFiles;
      _agents = agents;
      _models = allModels;
      if (agents.isNotEmpty) _selectedAgent = agents.first;
      if (allModels.isNotEmpty) _selectedModel = allModels.first;
      _loading = false;
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    _messageController.clear();

    // TODO: Implement actual message sending via API

    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (_loading) {
      return AppScaffold(
        serverId: widget.serverId,
        titleWidget: Text('Session'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AppScaffold(
      serverId: widget.serverId,
      titleWidget: Text(_currentSession?.title ?? 'New Session'),
      body: Column(
        children: [
          _buildTabBar(colors),
          Expanded(
            child: _selectedTab == 0
                ? _buildMessagesView(colors)
                : _buildDiffView(colors),
          ),
          _buildInputArea(colors),
        ],
      ),
    );
  }

  Widget _buildTabBar(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          _buildTab('会话', 0, colors),
          const SizedBox(width: 16),
          _buildTab('${_diffFiles.length}个文件变更', 1, colors),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, ColorScheme colors) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? colors.primary : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesView(ColorScheme colors) {
    if (_messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageItem(message, colors);
      },
    );
  }

  Widget _buildMessageItem(Message message, ColorScheme colors) {
    final isUser = message.info.role == 'user';
    final content = message.parts
        .where((p) => p.text != null)
        .map((p) => p.text!)
        .join('\n');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: colors.primaryContainer,
              child: Icon(
                Icons.smart_toy,
                size: 16,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? colors.primaryContainer
                    : colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(content, style: TextStyle(fontSize: 14)),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: colors.secondaryContainer,
              child: Icon(
                Icons.person,
                size: 16,
                color: colors.onSecondaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiffView(ColorScheme colors) {
    if (_diffFiles.isEmpty) {
      return Center(
        child: Text(
          'No file changes',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      );
    }

    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.all(12),
      itemCount: _diffFiles.length,
      itemBuilder: (context, index) {
        final file = _diffFiles[index];
        return _buildDiffItem(file, colors);
      },
    );
  }

  Widget _buildDiffItem(DiffFile file, ColorScheme colors) {
    Color statusColor;
    IconData statusIcon;

    switch (file.status) {
      case 'added':
        statusColor = Colors.green;
        statusIcon = Icons.add;
        break;
      case 'deleted':
        statusColor = Colors.red;
        statusIcon = Icons.remove;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.edit;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              file.path,
              style: TextStyle(fontSize: 13, fontFamily: 'monospace'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '+${file.additions} -${file.deletions}',
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _AgentSelector(
                  agents: _agents,
                  selectedAgent: _selectedAgent,
                  onChanged: (agent) => setState(() => _selectedAgent = agent),
                  colors: colors,
                ),
                const SizedBox(width: 8),
                _ModelSelector(
                  models: _models,
                  selectedModel: _selectedModel,
                  onChanged: (model) => setState(() => _selectedModel = model),
                  colors: colors,
                ),
                const SizedBox(width: 8),
                _ThinkingStrengthSelector(
                  strength: _thinkingStrength,
                  onChanged: (s) => setState(() => _thinkingStrength = s),
                  colors: colors,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sending ? null : _sendMessage,
                icon: _sending
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.onPrimary,
                        ),
                      )
                    : Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

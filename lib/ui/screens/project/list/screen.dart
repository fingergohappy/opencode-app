import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/server_store.dart';
import '../../../../models/project.dart';
import '../../../../network/opencode_client.dart';
import '../../../../network/api.dart';
import '../../../../utils/app_logger.dart';
import '../../../widgets/app_drawer.dart';

const String _tag = 'ProjectListScreen';
const _logger = AppLogger(_tag);

void _log(String message) {
  _logger.info(message);
}

class ProjectListScreen extends StatefulWidget {
  final String serverId;
  const ProjectListScreen({super.key, required this.serverId});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final _serverStore = ServerStore();
  final _pathController = TextEditingController();
  final _focusNode = FocusNode();
  List<Project> _projects = [];
  bool _loading = true;
  bool _healthy = false;

  // Path suggestion state
  List<String> _pathSuggestions = [];
  bool _suggestionsExpanded = false;
  String _homePath = '';
  Timer? _debounceTimer;
  OpenCodeClient? _client;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _pathController.text.isEmpty) {
        _triggerSuggestions('focus');
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.dispose();
    _pathController.dispose();
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

    _log('loadData: server found, baseUrl=${server.baseUrl}');
    _client = OpenCodeClient(server.baseUrl);
    final projectApi = ProjectApi(_client!);
    final healthApi = HealthApi(_client!);
    final systemApi = SystemApi(_client!);

    final health = await healthApi.getHealthInfo();
    _log('loadData: health=$health');
    final projects = await projectApi.getProjects();
    _log('loadData: projects count=${projects.length}');
    final pathInfo = await systemApi.getPaths();
    _log('loadData: pathInfo.home=${pathInfo.home}');

    setState(() {
      _healthy = health.healthy;
      _projects = projects;
      _homePath = pathInfo.home;
      _loading = false;
    });
    _log('loadData: completed, homePath=$_homePath');
  }

  void _triggerSuggestions(String reason) {
    _log('triggerSuggestions: reason=$reason');
    setState(() {
      _suggestionsExpanded = true;
    });
    _searchProjects(_pathController.text);
  }

  void _searchProjects(String query) {
    _log('searchProjects: query=$query');
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () async {
      _log(
        'searchProjects debounce triggered: query=$query client=${_client != null}',
      );
      if (_client == null) {
        _log('searchProjects: client is null, returning');
        return;
      }

      final trimmedQuery = query.trim();

      // Skip if empty and not triggered
      if (trimmedQuery.isEmpty && !_suggestionsExpanded) {
        _log('searchProjects: empty query and not expanded, skipping');
        setState(() {
          _pathSuggestions = [];
          _suggestionsExpanded = false;
        });
        return;
      }

      // Wait for home path if needed
      if ((trimmedQuery.isEmpty || trimmedQuery.startsWith('~')) &&
          _homePath.isEmpty) {
        _log('searchProjects: waiting for homePath, homePath=$_homePath');
        setState(() {
          _pathSuggestions = [];
          _suggestionsExpanded = false;
        });
        return;
      }

      final requestPath = _expandHomePath(trimmedQuery, _homePath);
      final fileQuery = _buildFileQuery(requestPath, _homePath);

      _log(
        'searchProjects: requestPath=$requestPath directory=${fileQuery['directory']} path=${fileQuery['path']} homePath=$_homePath',
      );

      final fileApi = FileApi(_client!);
      try {
        final suggestions = await fileApi.listFiles(
          fileQuery['path'] ?? '',
          directory: fileQuery['directory'],
        );

        _log('searchProjects: got ${suggestions.length} suggestions');
        for (final s in suggestions.take(5)) {
          _log('  - ${s.absolute}');
        }

        if (mounted) {
          setState(() {
            _pathSuggestions = suggestions.map((e) => e.absolute).toList();
            _suggestionsExpanded = _pathSuggestions.isNotEmpty;
          });
          _log(
            'searchProjects: suggestionsExpanded=$_suggestionsExpanded pathSuggestions.length=${_pathSuggestions.length}',
          );
        }
      } catch (e, stack) {
        _log('searchProjects error: $e');
        _log('stack: $stack');
      }
    });
  }

  String _expandHomePath(String path, String homePath) {
    if (!path.startsWith('~') || homePath.isEmpty) return path;
    if (path == '~') return homePath;
    if (path.startsWith('~/')) return homePath + path.substring(1);
    return path;
  }

  String _formatPathForDisplay(String absolutePath, String homePath) {
    if (homePath.isEmpty || !absolutePath.startsWith(homePath)) {
      return absolutePath;
    }
    final remainder = absolutePath.substring(homePath.length);
    return remainder.isEmpty ? '~' : '~$remainder';
  }

  String _continueSearchPath(String path) {
    if (path == '/') return path;
    if (path.endsWith('/')) return path;
    return '$path/';
  }

  Map<String, String?> _buildFileQuery(String inputPath, String homePath) {
    if (inputPath.isEmpty) {
      return {'directory': homePath.isEmpty ? null : homePath, 'path': ''};
    }

    if (inputPath == '/') {
      return {'directory': '/', 'path': ''};
    }

    if (inputPath.endsWith('/')) {
      final dir = inputPath.substring(0, inputPath.length - 1);
      return {'directory': dir.isEmpty ? '/' : dir, 'path': ''};
    }

    final lastSlashIndex = inputPath.lastIndexOf('/');
    if (lastSlashIndex >= 0) {
      final directory = inputPath.substring(0, lastSlashIndex);
      final path = inputPath.substring(lastSlashIndex + 1);
      return {'directory': directory.isEmpty ? '/' : directory, 'path': path};
    }

    return {'directory': homePath.isEmpty ? null : homePath, 'path': inputPath};
  }

  void _openProjectFromInput() {
    final rawPath = _pathController.text.trim();
    if (rawPath.isEmpty) {
      _triggerSuggestions('enter-empty');
      return;
    }

    final expandedPath = _expandHomePath(rawPath, _homePath);
    final normalizedPath = expandedPath.length > 1
        ? expandedPath.replaceAll(RegExp(r'/+$'), '')
        : expandedPath;

    setState(() {
      _suggestionsExpanded = false;
    });
    context.push(
      '/projects/${widget.serverId}/session?worktree=${Uri.encodeComponent(normalizedPath)}',
    );
  }

  void _selectSuggestion(String suggestion) {
    final displayPath = _formatPathForDisplay(suggestion, _homePath);
    final continuedPath = _continueSearchPath(displayPath);
    _pathController.text = continuedPath;
    _pathController.selection = TextSelection.fromPosition(
      TextPosition(offset: continuedPath.length),
    );
    _triggerSuggestions('suggestion-select');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AppScaffold(
      serverId: widget.serverId,
      titleWidget: Row(
        children: [
          Text(
            'OpenCode',
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          _StatusBadge(_healthy),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Text(
                            'OpenCode',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Enter project path',
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: colors.outline,
                                width: 0.5,
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _pathController,
                                  focusNode: _focusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Project Path',
                                    hintText: '/path/to/project',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_pathController.text.isNotEmpty)
                                          IconButton(
                                            icon: Icon(Icons.clear),
                                            onPressed: () {
                                              _pathController.clear();
                                              setState(() {
                                                _pathSuggestions = [];
                                                _suggestionsExpanded = false;
                                              });
                                            },
                                          ),
                                        TextButton(
                                          onPressed: _openProjectFromInput,
                                          child: Text('Open'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onSubmitted: (_) => _openProjectFromInput(),
                                  onChanged: (value) {
                                    setState(() {});
                                    _searchProjects(value);
                                  },
                                ),
                                if (_suggestionsExpanded &&
                                    _pathSuggestions.isNotEmpty) ...[
                                  SizedBox(height: 8),
                                  Container(
                                    constraints: BoxConstraints(maxHeight: 180),
                                    decoration: BoxDecoration(
                                      color: colors.surfaceContainerHighest
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: colors.outline.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      itemCount: _pathSuggestions.length,
                                      itemBuilder: (context, index) {
                                        final suggestion =
                                            _pathSuggestions[index];
                                        final displayPath =
                                            _formatPathForDisplay(
                                              suggestion,
                                              _homePath,
                                            );
                                        return InkWell(
                                          onTap: () =>
                                              _selectSuggestion(suggestion),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              displayPath,
                                              style: TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                                SizedBox(height: 10),
                                Text(
                                  'Recent projects shown below',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    constraints: BoxConstraints(minHeight: 300, maxHeight: 500),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.outline, width: 0.5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Projects',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${_projects.length} total',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.onSurfaceVariant.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.only(top: 4, bottom: 8),
                            itemCount: _projects.length,
                            separatorBuilder: (_, index) => SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final project = _projects[index];
                              return _ProjectCard(
                                project,
                                () => context.push(
                                  '/projects/${widget.serverId}/session?worktree=${Uri.encodeComponent(project.worktree)}',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool healthy;
  const _StatusBadge(this.healthy);

  @override
  Widget build(BuildContext context) {
    final color = healthy ? Colors.green : Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 4),
          Text(
            healthy ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  const _ProjectCard(this.project, this.onTap);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final name = project.worktree == '/'
        ? 'global'
        : project.worktree.split('/').last;
    final iconColor = _parseColor(project.icon?.color) ?? colors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.outline, width: 0.5),
        ),
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                name[0].toUpperCase(),
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    project.worktree,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color? _parseColor(String? hex) {
  if (hex == null || !hex.startsWith('#')) return null;
  return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
}

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/server_store.dart';
import '../../../../models/server_config.dart';
import '../../../widgets/app_drawer.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final _serverStore = ServerStore();
  List<ServerConfig> _servers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadServers();
  }

  Future<void> _loadServers() async {
    await _serverStore.ensureDefault();
    final servers = await _serverStore.getAll();
    setState(() {
      _servers = servers;
      _loading = false;
    });
  }

  void _showAddServerDialog(ServerConfig? initial) {
    final nameController = TextEditingController(text: initial?.name);
    final hostController = TextEditingController(text: initial?.host);
    final portController = TextEditingController(
      text: (initial?.port ?? 8080).toString(),
    );
    final usernameController = TextEditingController(text: initial?.username);
    final passwordController = TextEditingController(text: initial?.password);
    bool testing = false;
    String? testMessage;
    bool testSuccess = false;

    Future<void> testConnection(StateSetter setDialogState) async {
      final host = hostController.text;
      final port = int.tryParse(portController.text) ?? 8080;
      final protocol = host.startsWith('http') ? '' : 'http://';
      final url = Uri.parse('$protocol$host:$port/global/health');

      setDialogState(() {
        testing = true;
        testMessage = null;
      });

      try {
        final response = await Dio()
            .get<dynamic>(
              url.toString(),
              options: Options(validateStatus: (_) => true),
            )
            .timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          setDialogState(() {
            testing = false;
            testMessage = 'Connection successful!';
            testSuccess = true;
          });
        } else {
          setDialogState(() {
            testing = false;
            testMessage = 'Connect failed, please check connection info';
            testSuccess = false;
          });
        }
      } catch (e) {
        setDialogState(() {
          testing = false;
          testMessage = 'Connect failed, please check connection info';
          testSuccess = false;
        });
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(initial == null ? 'Add Server' : 'Edit Server'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (testMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: testSuccess
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: testSuccess ? Colors.green : Colors.red,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          testSuccess ? Icons.check_circle : Icons.error,
                          color: testSuccess ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            testMessage!,
                            style: TextStyle(
                              color: testSuccess ? Colors.green : Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'My Server',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hostController,
                  decoration: const InputDecoration(
                    labelText: 'Host',
                    hintText: '192.168.1.1 or localhost',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: portController,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    hintText: '8080',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username (optional)',
                    hintText: 'Optional',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password (optional)',
                    hintText: 'Optional',
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: testing ? null : () => testConnection(setDialogState),
              child: testing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Test'),
            ),
            ElevatedButton(
              onPressed: () async {
                final server = ServerConfig(
                  id: initial?.id,
                  name: nameController.text.isEmpty
                      ? hostController.text
                      : nameController.text,
                  host: hostController.text,
                  port: int.tryParse(portController.text) ?? 8080,
                  username: usernameController.text,
                  password: passwordController.text,
                );
                await _serverStore.save(server);
                if (mounted) {
                  Navigator.pop(dialogContext);
                  _loadServers();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      showServersInDrawer: false,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OpenCode',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select a server to connect',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: _servers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final server = _servers[index];
                      return _ServerCard(
                        server: server,
                        onTap: () => context.push('/projects/${server.id}'),
                        onEdit: () => _showAddServerDialog(server),
                        onDelete: () async {
                          await _serverStore.delete(server.id);
                          _loadServers();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServerDialog(null),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Text(
          '+',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class _ServerCard extends StatelessWidget {
  final ServerConfig server;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ServerCard({
    super.key,
    required this.server,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  server.name.isNotEmpty ? server.name[0].toUpperCase() : 'S',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      server.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${server.host}:${server.port}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: Text(
                  '⋮',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(onTap: onEdit, child: const Text('Edit')),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: Text(
                      'Delete',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

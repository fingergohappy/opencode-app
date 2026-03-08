// Config and Agent models

// Thinking strength options
enum ThinkingStrength {
  none,
  low,
  medium,
  high,
  xhigh;

  String get displayName {
    switch (this) {
      case ThinkingStrength.none:
        return 'None';
      case ThinkingStrength.low:
        return 'Low';
      case ThinkingStrength.medium:
        return 'Medium';
      case ThinkingStrength.high:
        return 'High';
      case ThinkingStrength.xhigh:
        return 'XHigh';
    }
  }
}

class ModelInfo {
  final String name;
  final int? contextLimit;
  final int? outputLimit;

  ModelInfo({required this.name, this.contextLimit, this.outputLimit});

  factory ModelInfo.fromJson(String key, Map<String, dynamic> json) => ModelInfo(
    name: json['name'] ?? key,
    contextLimit: json['limit']?['context'],
    outputLimit: json['limit']?['output'],
  );
}

class AgentPermission {
  final String permission;
  final String action;
  final String? pattern;

  AgentPermission({required this.permission, required this.action, this.pattern});

  factory AgentPermission.fromJson(Map<String, dynamic> json) => AgentPermission(
    permission: json['permission'] ?? '',
    action: json['action'] ?? '',
    pattern: json['pattern'],
  );
}

class AgentModel {
  final String providerID;
  final String modelID;

  AgentModel({required this.providerID, required this.modelID});

  factory AgentModel.fromJson(Map<String, dynamic> json) => AgentModel(
    providerID: json['providerID'] ?? '',
    modelID: json['modelID'] ?? '',
  );
}

class Agent {
  final String name;
  final String mode;
  final List<AgentPermission> permissions;
  final AgentModel? model;
  final String? prompt;

  Agent({
    required this.name,
    required this.mode,
    this.permissions = const [],
    this.model,
    this.prompt,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
    name: json['name'] ?? '',
    mode: json['mode'] ?? '',
    permissions: (json['permission'] as List<dynamic>?)
        ?.map((e) => AgentPermission.fromJson(e))
        .toList() ?? [],
    model: json['model'] != null ? AgentModel.fromJson(json['model']) : null,
    prompt: json['prompt'],
  );

  /// Check if this agent should be shown in the UI (not a subagent-only agent)
  bool get isVisible => mode != 'subagent';
}

class ProviderModel {
  final String id;
  final String name;

  ProviderModel({required this.id, required this.name});
}

class Provider {
  final String id;
  final String name;
  final List<ProviderModel> models;

  Provider({required this.id, required this.name, required this.models});

  factory Provider.fromJson(String id, Map<String, dynamic> json) {
    final modelsMap = json['models'] as Map<String, dynamic>? ?? {};
    final models = modelsMap.entries.map((e) => ProviderModel(
      id: e.key,
      name: (e.value as Map<String, dynamic>?)?['name'] ?? e.key,
    )).toList();

    return Provider(
      id: id,
      name: json['name'] ?? id,
      models: models,
    );
  }
}

class AppConfig {
  final String? model;
  final List<Agent> agents;
  final List<Provider> providers;

  AppConfig({this.model, this.agents = const [], this.providers = const []});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    final agentsList = (json['agent'] as List<dynamic>?)
        ?.map((e) => Agent.fromJson(e))
        .toList() ?? [];

    final providersMap = json['provider'] as Map<String, dynamic>? ?? {};
    final providers = providersMap.entries
        .where((e) => e.value is Map<String, dynamic>)
        .map((e) => Provider.fromJson(e.key, e.value as Map<String, dynamic>))
        .toList();

    return AppConfig(
      model: json['model'],
      agents: agentsList,
      providers: providers,
    );
  }
}

// Diff models
class DiffFile {
  final String path;
  final String status; // added, modified, deleted
  final int additions;
  final int deletions;
  final String? patch;

  DiffFile({
    required this.path,
    required this.status,
    this.additions = 0,
    this.deletions = 0,
    this.patch,
  });

  factory DiffFile.fromJson(Map<String, dynamic> json) => DiffFile(
    path: json['path'] ?? json['filename'] ?? '',
    status: json['status'] ?? 'modified',
    additions: json['additions'] ?? 0,
    deletions: json['deletions'] ?? 0,
    patch: json['patch'],
  );
}

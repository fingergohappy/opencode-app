class Project {
  final String id;
  final String worktree;
  final String? vcs;
  final ProjectTime time;
  final ProjectIcon? icon;
  final List<String>? sandboxes;

  Project({
    required this.id,
    required this.worktree,
    this.vcs,
    required this.time,
    this.icon,
    this.sandboxes,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'],
        worktree: json['worktree'],
        vcs: json['vcs'],
        time: ProjectTime.fromJson(json['time']),
        icon: json['icon'] != null ? ProjectIcon.fromJson(json['icon']) : null,
        sandboxes: json['sandboxes'] != null ? List<String>.from(json['sandboxes']) : null,
      );
}

class ProjectTime {
  final int created;
  final int updated;
  final int? initialized;

  ProjectTime({required this.created, required this.updated, this.initialized});

  factory ProjectTime.fromJson(Map<String, dynamic> json) => ProjectTime(
        created: json['created'],
        updated: json['updated'],
        initialized: json['initialized'],
      );
}

class ProjectIcon {
  final String? color;
  final String? url;
  final String? override;

  ProjectIcon({this.color, this.url, this.override});

  factory ProjectIcon.fromJson(Map<String, dynamic> json) => ProjectIcon(
        color: json['color'],
        url: json['url'],
        override: json['override'],
      );
}

class HealthResponse {
  final bool healthy;
  final String version;

  HealthResponse({required this.healthy, this.version = ''});

  factory HealthResponse.fromJson(Map<String, dynamic> json) => HealthResponse(
        healthy: json['healthy'],
        version: json['version'] ?? '',
      );
}

class GlobalConfig {
  final String model;
  final bool autoupdate;

  GlobalConfig({this.model = '', this.autoupdate = false});

  factory GlobalConfig.fromJson(Map<String, dynamic> json) => GlobalConfig(
        model: json['model'] ?? '',
        autoupdate: json['autoupdate'] ?? false,
      );
}

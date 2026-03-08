// API Models
class ProjectUpdateRequest {
  final String? name;
  final ProjectIconUpdateRequest? icon;

  ProjectUpdateRequest({this.name, this.icon});

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (icon != null) 'icon': icon!.toJson(),
  };
}

class ProjectIconUpdateRequest {
  final String? url;
  final String? override;
  final String? color;

  ProjectIconUpdateRequest({this.url, this.override, this.color});

  Map<String, dynamic> toJson() => {
    if (url != null) 'url': url,
    if (override != null) 'override': override,
    if (color != null) 'color': color,
  };
}

class Pty {
  final String id;
  final String title;
  final String command;
  final List<String> args;
  final String cwd;
  final String status;
  final int pid;

  Pty({required this.id, required this.title, required this.command, this.args = const [], required this.cwd, required this.status, required this.pid});

  factory Pty.fromJson(Map<String, dynamic> json) => Pty(
    id: json['id'],
    title: json['title'],
    command: json['command'],
    args: json['args'] != null ? List<String>.from(json['args']) : [],
    cwd: json['cwd'],
    status: json['status'],
    pid: json['pid'],
  );
}

class Session {
  final String id;
  final String slug;
  final String projectID;
  final String? workspaceID;
  final String directory;
  final String title;

  Session({required this.id, required this.slug, required this.projectID, this.workspaceID, required this.directory, required this.title});

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    id: json['id'],
    slug: json['slug'],
    projectID: json['projectID'],
    workspaceID: json['workspaceID'],
    directory: json['directory'],
    title: json['title'],
  );
}

class FileNode {
  final String name;
  final String path;
  final String absolute;
  final String type;
  final bool ignored;

  FileNode({required this.name, required this.path, required this.absolute, required this.type, required this.ignored});

  factory FileNode.fromJson(Map<String, dynamic> json) => FileNode(
    name: json['name'],
    path: json['path'],
    absolute: json['absolute'],
    type: json['type'],
    ignored: json['ignored'],
  );
}

class PathInfo {
  final String home;
  final String state;
  final String config;
  final String worktree;
  final String directory;

  PathInfo({required this.home, required this.state, required this.config, required this.worktree, required this.directory});

  factory PathInfo.fromJson(Map<String, dynamic> json) => PathInfo(
    home: json['home'],
    state: json['state'],
    config: json['config'],
    worktree: json['worktree'],
    directory: json['directory'],
  );
}

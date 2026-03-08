import '../models/project.dart';
import '../models/api_models.dart';
import 'opencode_client.dart';

class ProjectApi {
  final OpenCodeClient client;
  ProjectApi(this.client);

  Future<List<Project>> getProjects({Map<String, dynamic>? context}) async {
    try {
      return await client.get<List<Project>>('project', query: context, fromJson: (data) => (data as List).map((e) => Project.fromJson(e)).toList());
    } catch (_) {
      return [];
    }
  }

  Future<Project?> getCurrentProject({Map<String, dynamic>? context}) async {
    try {
      return await client.get<Project>('project/current', query: context, fromJson: (data) => Project.fromJson(data));
    } catch (_) {
      return null;
    }
  }

  Future<Project> updateProject(String projectId, ProjectUpdateRequest request, {Map<String, dynamic>? context}) async {
    return await client.patch<Project>('project/$projectId', body: request.toJson(), query: context, fromJson: (data) => Project.fromJson(data));
  }
}

class HealthApi {
  final OpenCodeClient client;
  HealthApi(this.client);

  Future<HealthResponse> getHealthInfo() async {
    try {
      return await client.get<HealthResponse>('global/health', fromJson: (data) => HealthResponse.fromJson(data));
    } catch (_) {
      return HealthResponse(healthy: false);
    }
  }
}

class ConfigApi {
  final OpenCodeClient client;
  ConfigApi(this.client);

  Future<GlobalConfig> getConfig() async {
    try {
      return await client.get<GlobalConfig>('global/config', fromJson: (data) => GlobalConfig.fromJson(data));
    } catch (_) {
      return GlobalConfig();
    }
  }
}

class SessionApi {
  final OpenCodeClient client;
  SessionApi(this.client);

  Future<List<Session>> getSessions({Map<String, dynamic>? context}) async {
    try {
      return await client.get<List<Session>>('session', query: context, fromJson: (data) => (data as List).map((e) => Session.fromJson(e)).toList());
    } catch (_) {
      return [];
    }
  }

  Future<Session?> getSession(String sessionId, {Map<String, dynamic>? context}) async {
    try {
      return await client.get<Session>('session/$sessionId', query: context, fromJson: (data) => Session.fromJson(data));
    } catch (_) {
      return null;
    }
  }
}

class PtyApi {
  final OpenCodeClient client;
  PtyApi(this.client);

  Future<List<Pty>> getPtys({Map<String, dynamic>? context}) async {
    try {
      return await client.get<List<Pty>>('pty', query: context, fromJson: (data) => (data as List).map((e) => Pty.fromJson(e)).toList());
    } catch (_) {
      return [];
    }
  }
}

class FileApi {
  final OpenCodeClient client;
  FileApi(this.client);

  Future<List<FileNode>> listFiles(String path, {String? directory, Map<String, dynamic>? context}) async {
    try {
      final query = <String, dynamic>{...?context, 'path': path};
      if (directory != null) query['directory'] = directory;
      print('[FileApi] listFiles: query=$query');
      final result = await client.get<List<FileNode>>('file', query: query, fromJson: (data) => (data as List).map((e) => FileNode.fromJson(e)).toList());
      print('[FileApi] listFiles result: ${result.length} items');
      return result;
    } catch (e, stack) {
      print('[FileApi] listFiles error: $e');
      print('[FileApi] stack: $stack');
      return [];
    }
  }

  Future<String> readFile(String path, {Map<String, dynamic>? context}) async {
    try {
      return await client.get<String>('file/read', query: {...?context, 'path': path}, fromJson: (data) => data['content'] ?? '');
    } catch (_) {
      return '';
    }
  }
}

class SystemApi {
  final OpenCodeClient client;
  SystemApi(this.client);

  Future<PathInfo> getPaths() async {
    try {
      print('[SystemApi] getPaths: calling path endpoint');
      final result = await client.get<PathInfo>('path', fromJson: (data) => PathInfo.fromJson(data));
      print('[SystemApi] getPaths result: home=${result.home}');
      return result;
    } catch (e) {
      print('[SystemApi] getPaths error: $e');
      return PathInfo(home: '', state: '', config: '', worktree: '', directory: '');
    }
  }
}

class FindApi {
  final OpenCodeClient client;
  FindApi(this.client);

  Future<List<FileNode>> findFiles(String query, {String? directory, Map<String, dynamic>? context}) async {
    try {
      return await client.get<List<FileNode>>('find/file', query: {...?context, 'query': query, if (directory != null) 'directory': directory}, fromJson: (data) => (data as List).map((e) => FileNode.fromJson(e)).toList());
    } catch (_) {
      return [];
    }
  }
}

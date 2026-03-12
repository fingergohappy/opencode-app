import '../models/project.dart';
import '../models/api_models.dart';
import '../models/message.dart';
import '../models/config.dart';
import '../utils/app_logger.dart';
import 'opencode_client.dart';

const _fileApiLogger = AppLogger('FileApi');
const _systemApiLogger = AppLogger('SystemApi');

/// 这一文件把端点按领域拆成多个小 API 类。
/// UI 通常只依赖自己需要的那一小组接口，而不是直接拼 URL 或解析 JSON。

/// 项目相关接口封装。
class ProjectApi {
  final OpenCodeClient client;
  ProjectApi(this.client);

  /// 列表接口失败时返回空数组，让 UI 可以继续展示空状态。
  Future<List<Project>> getProjects({Map<String, dynamic>? context}) async {
    try {
      return await client.get<List<Project>>(
        'project',
        query: context,
        fromJson: (data) =>
            (data as List).map((e) => Project.fromJson(e)).toList(),
      );
    } catch (_) {
      return [];
    }
  }

  /// 单个项目不存在时返回 null，比把异常传播到 UI 更容易处理。
  Future<Project?> getCurrentProject({Map<String, dynamic>? context}) async {
    try {
      return await client.get<Project>(
        'project/current',
        query: context,
        fromJson: (data) => Project.fromJson(data),
      );
    } catch (_) {
      return null;
    }
  }

  /// 更新接口直接接受请求模型，调用方不需要自己拼 JSON。
  Future<Project> updateProject(
    String projectId,
    ProjectUpdateRequest request, {
    Map<String, dynamic>? context,
  }) async {
    return await client.patch<Project>(
      'project/$projectId',
      body: request.toJson(),
      query: context,
      fromJson: (data) => Project.fromJson(data),
    );
  }
}

/// 用于判断服务器是否在线。
class HealthApi {
  final OpenCodeClient client;
  HealthApi(this.client);

  Future<HealthResponse> getHealthInfo() async {
    try {
      return await client.get<HealthResponse>(
        'global/health',
        fromJson: (data) => HealthResponse.fromJson(data),
      );
    } catch (_) {
      return HealthResponse(healthy: false);
    }
  }
}

/// 配置接口会把后端返回的 agent/provider 信息转换成前端模型。
class ConfigApi {
  final OpenCodeClient client;
  ConfigApi(this.client);

  Future<GlobalConfig> getConfig() async {
    try {
      return await client.get<GlobalConfig>(
        'global/config',
        fromJson: (data) => GlobalConfig.fromJson(data),
      );
    } catch (_) {
      // 配置读取失败时返回空配置，调用方可以先展示默认 UI，再决定是否提示错误。
      return GlobalConfig();
    }
  }

  Future<AppConfig> getAppConfig() async {
    try {
      return await client.get<AppConfig>(
        'config',
        fromJson: (data) => AppConfig.fromJson(data),
      );
    } catch (_) {
      return AppConfig();
    }
  }

  Future<List<Agent>> getAgents() async {
    try {
      return await client.get<List<Agent>>(
        'agent',
        fromJson: (data) =>
            (data as List).map((e) => Agent.fromJson(e)).toList(),
      );
    } catch (_) {
      return [];
    }
  }
}

/// 会话接口负责会话列表、消息列表和 diff 数据。
class SessionApi {
  final OpenCodeClient client;
  SessionApi(this.client);

  // 这里的 context 会把 worktree 之类的页面上下文透传给后端，让同一组端点服务不同项目。
  Future<List<Session>> getSessions({Map<String, dynamic>? context}) async {
    try {
      return await client.get<List<Session>>(
        'session',
        query: context,
        fromJson: (data) =>
            (data as List).map((e) => Session.fromJson(e)).toList(),
      );
    } catch (_) {
      return [];
    }
  }

  Future<Session?> getSession(
    String sessionId, {
    Map<String, dynamic>? context,
  }) async {
    try {
      return await client.get<Session>(
        'session/$sessionId',
        query: context,
        fromJson: (data) => Session.fromJson(data),
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<Message>> getMessages(
    String sessionId, {
    Map<String, dynamic>? context,
  }) async {
    try {
      return await client.get<List<Message>>(
        'session/$sessionId/message',
        query: context,
        fromJson: (data) =>
            (data as List).map((e) => Message.fromJson(e)).toList(),
      );
    } catch (_) {
      return [];
    }
  }

  Future<List<DiffFile>> getDiff(
    String sessionId, {
    Map<String, dynamic>? context,
  }) async {
    try {
      return await client.get<List<DiffFile>>(
        'session/$sessionId/diff',
        query: context,
        fromJson: (data) =>
            (data as List).map((e) => DiffFile.fromJson(e)).toList(),
      );
    } catch (_) {
      return [];
    }
  }
}

/// 下面这些 API 类职责都比较单一，适合作为某一类端点的薄封装。
class MessageApi {
  final OpenCodeClient client;
  MessageApi(this.client);

  Future<List<Message>> getMessages(
    String sessionId, {
    Map<String, dynamic>? context,
  }) async {
    try {
      return await client.get<List<Message>>(
        'session/$sessionId/message',
        query: context,
        fromJson: (data) =>
            (data as List).map((e) => Message.fromJson(e)).toList(),
      );
    } catch (_) {
      return [];
    }
  }
}

class DiffApi {
  final OpenCodeClient client;
  DiffApi(this.client);

  Future<List<DiffFile>> getDiff(
    String sessionId, {
    Map<String, dynamic>? context,
  }) async {
    try {
      return await client.get<List<DiffFile>>(
        'session/$sessionId/diff',
        query: context,
        fromJson: (data) =>
            (data as List).map((e) => DiffFile.fromJson(e)).toList(),
      );
    } catch (_) {
      return [];
    }
  }
}

class PtyApi {
  final OpenCodeClient client;
  PtyApi(this.client);

  Future<List<Pty>> getPtys({Map<String, dynamic>? context}) async {
    try {
      return await client.get<List<Pty>>(
        'pty',
        query: context,
        fromJson: (data) => (data as List).map((e) => Pty.fromJson(e)).toList(),
      );
    } catch (_) {
      return [];
    }
  }
}

/// 文件接口既被页面使用，也被路径搜索功能复用。
class FileApi {
  final OpenCodeClient client;
  FileApi(this.client);

  Future<List<FileNode>> listFiles(
    String path, {
    String? directory,
    Map<String, dynamic>? context,
  }) async {
    try {
      // 把页面上下文和查询 path 合并后再发给后端。
      // 这样文件搜索既能服务“全局浏览”，也能服务“当前项目内补全”。
      final query = <String, dynamic>{...?context, 'path': path};
      if (directory != null) query['directory'] = directory;
      _fileApiLogger.info('listFiles: query=$query');
      final result = await client.get<List<FileNode>>(
        'file',
        query: query,
        fromJson: (data) =>
            (data as List).map((e) => FileNode.fromJson(e)).toList(),
      );
      _fileApiLogger.info('listFiles result: ${result.length} items');
      return result;
    } catch (e, stack) {
      _fileApiLogger.error('listFiles error', error: e, stackTrace: stack);
      return [];
    }
  }

  Future<String> readFile(String path, {Map<String, dynamic>? context}) async {
    try {
      return await client.get<String>(
        'file/read',
        query: {...?context, 'path': path},
        fromJson: (data) => data['content'] ?? '',
      );
    } catch (_) {
      return '';
    }
  }
}

class SystemApi {
  final OpenCodeClient client;
  SystemApi(this.client);

  /// PathInfo 里的 home/worktree 信息会被前端用于路径展示和补全。
  Future<PathInfo> getPaths() async {
    try {
      // 项目列表页会先拿这份路径信息，再决定如何处理 ~ 和默认目录提示。
      _systemApiLogger.info('getPaths: calling path endpoint');
      final result = await client.get<PathInfo>(
        'path',
        fromJson: (data) => PathInfo.fromJson(data),
      );
      _systemApiLogger.info('getPaths result: home=${result.home}');
      return result;
    } catch (e) {
      _systemApiLogger.error('getPaths error', error: e);
      return PathInfo(
        home: '',
        state: '',
        config: '',
        worktree: '',
        directory: '',
      );
    }
  }
}

class FindApi {
  final OpenCodeClient client;
  FindApi(this.client);

  Future<List<FileNode>> findFiles(
    String query, {
    String? directory,
    Map<String, dynamic>? context,
  }) async {
    try {
      return await client.get<List<FileNode>>(
        'find/file',
        query: {
          ...?context,
          'query': query,
          ...?(directory == null ? null : {'directory': directory}),
        },
        fromJson: (data) =>
            (data as List).map((e) => FileNode.fromJson(e)).toList(),
      );
    } catch (_) {
      return [];
    }
  }
}

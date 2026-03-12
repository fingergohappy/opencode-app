import '../../../../network/api.dart';

/// 搜索结果除了候选路径本身，还带着“是否展开建议框”的状态。
class ProjectPathSearchResult {
  final List<String> suggestions;
  final bool expanded;

  const ProjectPathSearchResult({
    required this.suggestions,
    required this.expanded,
  });
}

/// 把输入框里的路径转换成文件接口可识别的查询条件。
class ProjectPathSearchService {
  final FileApi fileApi;

  const ProjectPathSearchService(this.fileApi);

  /// 这一层把“输入文本 -> 请求参数 -> 候选项列表”的流程串起来。
  Future<ProjectPathSearchResult> search(
    String query, {
    required String homePath,
    required bool suggestionsExpanded,
  }) async {
    final trimmedQuery = query.trim();

    // 输入为空且面板还没展开时，说明用户还没有真正开始搜索。
    if (trimmedQuery.isEmpty && !suggestionsExpanded) {
      return const ProjectPathSearchResult(suggestions: [], expanded: false);
    }

    // 用户输入 ~ 时必须知道 homePath，否则无法展开成绝对路径。
    if ((trimmedQuery.isEmpty || trimmedQuery.startsWith('~')) &&
        homePath.isEmpty) {
      return const ProjectPathSearchResult(suggestions: [], expanded: false);
    }

    final requestPath = expandHomePath(trimmedQuery, homePath);
    final fileQuery = buildFileQuery(requestPath, homePath);
    // 这里先把输入拆成 directory/path，再适配后端 file 接口的参数结构。
    final suggestions = await fileApi.listFiles(
      fileQuery.path,
      directory: fileQuery.directory,
    );
    final paths = suggestions.map((entry) => entry.absolute).toList();

    return ProjectPathSearchResult(
      suggestions: paths,
      expanded: paths.isNotEmpty,
    );
  }
}

class ProjectFileQuery {
  final String? directory;
  final String path;

  const ProjectFileQuery({required this.directory, required this.path});
}

/// 把 ~ / ~/foo 这种写法展开成真实家目录，便于发送给后端。
String expandHomePath(String path, String homePath) {
  if (!path.startsWith('~') || homePath.isEmpty) return path;
  if (path == '~') return homePath;
  if (path.startsWith('~/')) return homePath + path.substring(1);
  return path;
}

/// 展示给用户时再把绝对路径缩回 ~ 开头，更接近终端习惯。
String formatPathForDisplay(String absolutePath, String homePath) {
  if (homePath.isEmpty || !absolutePath.startsWith(homePath)) {
    return absolutePath;
  }
  final remainder = absolutePath.substring(homePath.length);
  return remainder.isEmpty ? '~' : '~$remainder';
}

/// 目录候选项默认补上 /，表示用户大概率还想继续向下搜索。
String continueSearchPath(String path) {
  if (path == '/') return path;
  if (path.endsWith('/')) return path;
  // 给目录补上 / 后，下一次输入会自然变成“在这个目录下继续搜”。
  return '$path/';
}

/// 根据当前输入拆出 directory 和 path，适配后端文件枚举接口。
ProjectFileQuery buildFileQuery(String inputPath, String homePath) {
  if (inputPath.isEmpty) {
    return ProjectFileQuery(
      directory: homePath.isEmpty ? null : homePath,
      path: '',
    );
  }

  if (inputPath == '/') {
    return const ProjectFileQuery(directory: '/', path: '');
  }

  if (inputPath.endsWith('/')) {
    // 以 / 结尾说明用户已经确定目录，只差列出这个目录下面还能输入什么。
    final directory = inputPath.substring(0, inputPath.length - 1);
    return ProjectFileQuery(
      directory: directory.isEmpty ? '/' : directory,
      path: '',
    );
  }

  final lastSlashIndex = inputPath.lastIndexOf('/');
  if (lastSlashIndex >= 0) {
    final directory = inputPath.substring(0, lastSlashIndex);
    final path = inputPath.substring(lastSlashIndex + 1);
    // 最后一个 / 之前是目录上下文，之后才是当前正在补全的片段。
    return ProjectFileQuery(
      directory: directory.isEmpty ? '/' : directory,
      path: path,
    );
  }

  return ProjectFileQuery(
    directory: homePath.isEmpty ? null : homePath,
    path: inputPath,
  );
}

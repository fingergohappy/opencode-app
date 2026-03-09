import '../../../../network/api.dart';

class ProjectPathSearchResult {
  final List<String> suggestions;
  final bool expanded;

  const ProjectPathSearchResult({
    required this.suggestions,
    required this.expanded,
  });
}

class ProjectPathSearchService {
  final FileApi fileApi;

  const ProjectPathSearchService(this.fileApi);

  Future<ProjectPathSearchResult> search(
    String query, {
    required String homePath,
    required bool suggestionsExpanded,
  }) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty && !suggestionsExpanded) {
      return const ProjectPathSearchResult(suggestions: [], expanded: false);
    }

    if ((trimmedQuery.isEmpty || trimmedQuery.startsWith('~')) &&
        homePath.isEmpty) {
      return const ProjectPathSearchResult(suggestions: [], expanded: false);
    }

    final requestPath = expandHomePath(trimmedQuery, homePath);
    final fileQuery = buildFileQuery(requestPath, homePath);
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

String expandHomePath(String path, String homePath) {
  if (!path.startsWith('~') || homePath.isEmpty) return path;
  if (path == '~') return homePath;
  if (path.startsWith('~/')) return homePath + path.substring(1);
  return path;
}

String formatPathForDisplay(String absolutePath, String homePath) {
  if (homePath.isEmpty || !absolutePath.startsWith(homePath)) {
    return absolutePath;
  }
  final remainder = absolutePath.substring(homePath.length);
  return remainder.isEmpty ? '~' : '~$remainder';
}

String continueSearchPath(String path) {
  if (path == '/') return path;
  if (path.endsWith('/')) return path;
  return '$path/';
}

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

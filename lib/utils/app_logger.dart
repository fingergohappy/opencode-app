import 'dart:developer' as developer;

/// 一个很薄的日志封装。
/// 统一入口的好处是后面想换日志方案时，不必逐个改业务代码。
class AppLogger {
  final String name;

  const AppLogger(this.name);

  /// info 只包一层模块名，方便在开发期快速判断日志来自哪一层。
  void info(String message) {
    developer.log(message, name: name);
  }

  /// error 会把异常对象和堆栈一并交给 developer.log，方便排查异步调用链。
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}

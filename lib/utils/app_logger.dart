import 'dart:developer' as developer;

class AppLogger {
  final String name;

  const AppLogger(this.name);

  void info(String message) {
    developer.log(message, name: name);
  }

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

const String stage = Environment.dev;

class Environment {
  static const String local = 'local';
  static const String dev = 'dev';

  static const enableLogs = true;
}

class ApiUrl {
  static const String baseUrl = stage == Environment.local
      ? 'https://api.kuttystory.yaseralabs.com'
      : stage == Environment.dev
          ? 'https://api.kuttystory.yaseralabs.com'
          : "";
}

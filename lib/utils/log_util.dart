import 'dart:developer';
import 'package:rpskindisease/utils/parameters.dart';

void printLog(message, [Object? stackTrace, int? level]) {
  if (Environment.enableLogs) {
    log(
      message.toString(),
      level: level ?? 0,
      stackTrace: stackTrace != null
          ? StackTrace.fromString(stackTrace.toString())
          : null,
    );
  }
}

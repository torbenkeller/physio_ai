export 'dart:developer';

class LogLevel {
  const LogLevel._();

  /// Special key to turn on logging for all levels.
  static const all = 0;

  /// Special key to turn off all logging.
  static const off = 2000;

  /// Key for highly detailed tracing.
  static const finest = 300;

  /// Key for fairly detailed tracing.
  static const finer = 400;

  /// Key for tracing information.
  static const fine = 500;

  /// Key for static configuration messages..
  static const config = 700;

  /// Key for informational messages.
  static const info = 800;

  /// Key for potential problems.
  static const warning = 900;

  /// Key for serious failures.
  static const serve = 1000;

  /// Key for extra debugging loudness.
  static const shout = 1200;
}

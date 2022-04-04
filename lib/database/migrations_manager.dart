import 'package:flutter/services.dart' show rootBundle;

class MigrationsManager {
  static Future<String> getMigrationScript(int version) {
    return rootBundle.loadString('assets/sql/v$version.sql');
  }
}

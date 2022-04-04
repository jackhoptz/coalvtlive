import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  final int databaseVersion = 22;
  final String databaseName;
  late Database db;

  DatabaseManager({required this.databaseName});
  Future<Database> open({
    required Function(Database db, int version) onCreate,
    String? databasePath,
    required Function(Database db) onOpen,
    required Function(Database db, int oldVersion, int newVersion) onUpdate,
  }) async {
    databasePath ??= await getDatabasesPath();
    final path = join(databasePath, databaseName);

    final exists = await databaseExists(path);
    if (!exists) {
      // copy database seed
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      try {
        final ByteData data =
            await rootBundle.load(join('assets', 'sql', 'pulse_move.db'));
        final List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Write and flush the bytes written
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (error) {
        debugPrint('No initial data seed used');
      }
    }

    db = await openDatabase(path,
        version: databaseVersion,
        onCreate: onCreate,
        onOpen: onOpen,
        onUpgrade: onUpdate);

    return db;
  }

  Future close() async => db.close();

  @override
  String toString() {
    final Map<String, String> info = {
      'status': db == null ? 'closed' : db.isOpen.toString()
    };

    if (db != null) {
      info['path'] = db.path;
      info['version'] = databaseVersion.toString();
    }
    return 'Database $info';
  }
}

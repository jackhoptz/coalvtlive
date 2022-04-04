import 'package:ecodate/database/migrations_manager.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import 'database_manager.dart';
import 'entity.dart';

class DatabaseProvider<T extends Entity> extends StatefulWidget {
  final DatabaseManager _manager;
  final List<EntityProvider<T>> _entityProviders;
  final Widget child;

  const DatabaseProvider({
    required Widget child,
    required DatabaseManager manager,
    required List<EntityProvider<T>> entityProviders,
  }) : this._(child, manager, entityProviders);

  const DatabaseProvider._(this.child, this._manager, this._entityProviders);

  static Future<void> clearDatabase(
      BuildContext context, List<Entity> entities) async {
    for (var entity in entities) {
      await clearTable(context, entity);
    }
  }

  static Future<void> clearTable(BuildContext context, Entity entity) async {
    await managerOf(context).db.delete(entity.tableName(), where: '1');
  }

  static DatabaseManager managerOf(BuildContext context) {
    final _InheritedDatabaseProvider? dbProvider = context
        .dependOnInheritedWidgetOfExactType<_InheritedDatabaseProvider>();

    if (dbProvider == null) {
      throw DatabaseProviderNotFoundError(
          DatabaseManager, context.widget.runtimeType);
    }

    return dbProvider.data._manager;
  }

  static EntityProvider<T> entityProviderOf<T extends Entity>(
      BuildContext context) {
    final _InheritedDatabaseProvider? dbProvider = context
        .dependOnInheritedWidgetOfExactType<_InheritedDatabaseProvider>();

    if (dbProvider == null) {
      throw DatabaseProviderNotFoundError(
          DatabaseManager, context.widget.runtimeType);
    }

    if (dbProvider.data._entityProviders.isEmpty) {
      throw EntityProviderNotFoundError(T, context.widget.runtimeType);
    }

    try {
      final ep =
          dbProvider.data._entityProviders.whereType<EntityProvider<T>>().first;
      return ep;
    } catch (e) {
      throw EntityProviderNotFoundError(T, context.widget.runtimeType);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _DatabaseProviderState(_manager, _entityProviders);
  }
}

class _DatabaseProviderState<T extends Entity> extends State<DatabaseProvider> {
  final DatabaseManager _manager;
  final List<EntityProvider<T>> _entityProviders;

  _DatabaseProviderState(this._manager, this._entityProviders);

  Future<Database> openDB() async {
    return await _manager.open(onCreate: (db, version) async {
      debugPrint('Did create db!');
      for (var p in _entityProviders) {
        await p.builder().createTable(db);
        p.db = db;
      }
      debugPrint('Did create all tables');
    }, onOpen: (db) {
      debugPrint('Did open db!');
      for (var p in _entityProviders) {
        p.db = db;
      }
    }, onUpdate: (db, int oldVersion, int newVersion) async {
      final batch = db.batch();
      debugPrint('Migrating from $oldVersion to $newVersion');
      for (int i = oldVersion + 1; i <= newVersion; i++) {
        // Load migration script from file
        final script = await MigrationsManager.getMigrationScript(i);
        // Run Scripts
        final statements =
            script.split(';').where((s) => s.isNotEmpty).toList();
        statements.forEach((st) => batch.execute(st));
      }
      try {
        await batch.commit();
      } catch (error) {
        debugPrint('Migration failed: ${error.toString()}');
      }

      debugPrint('migration complete');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: openDB(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: Text('A Game By Coal Troptaz')),
              ),
            ); // Empty screen for when database has not yet loaded
          default:
            if (snapshot.hasError) {
              debugPrint(
                  'Database builder error: ${snapshot.error.toString()}');
              return Center(
                child: Text(
                  'Failed to open database: ${snapshot.error.toString()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  textDirection: TextDirection.ltr,
                ),
              );
            } else {
              for (var p in _entityProviders) {
                final Database? db = snapshot.data;
                if (db != null) {
                  p.db = db;
                }
              }
              return _InheritedDatabaseProvider(
                child: widget.child,
                data: this,
              );
            }
        }
      },
    );
  }
}

class _InheritedDatabaseProvider extends InheritedWidget {
  final _DatabaseProviderState data;

  const _InheritedDatabaseProvider({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class DatabaseProviderNotFoundError extends Error {
  final Type valueType;
  final Type widgetType;

  DatabaseProviderNotFoundError(
    this.valueType,
    this.widgetType,
  );

  @override
  String toString() {
    return '''
    Error: Could not find the correct DatabaseProvider<$valueType> above this $widgetType Widget.

    To fix, please:

      * Ensure the DatabaseProvider<$valueType> is an ancestor of this $widgetType Widget
      * Provide types to DatabaseProvider.of<$valueType>()
      * Always use pacakge imports. Ex: `import 'package:my_app/my_code.dart';`
      * Ensure the correct `context` is being used.

    ''';
  }
}

class EntityProviderNotFoundError extends Error {
  final Type valueType;
  final Type widgetType;

  EntityProviderNotFoundError(
    this.valueType,
    this.widgetType,
  );

  @override
  String toString() {
    return '''
    Error: Could not find the correct EntityProvider<$valueType> above this $widgetType Widget.

    To fix, please:

      * Ensure the EntityProvider<$valueType> is an ancestor of this $widgetType Widget
      * Provide types to EntityProvider.of<$valueType>()
      * Always use pacakge imports. Ex: `import 'package:my_app/my_code.dart';`
      * Ensure the correct `context` is being used.

    ''';
  }
}

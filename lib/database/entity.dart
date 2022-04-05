import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

abstract class Mappable<T> {
  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
}

abstract class Entity extends Mappable {
  String tableName();
  final String columnId = 'Id';

  Entity({this.id});

  factory Entity.factoryDefault() {
    throw UnimplementedError();
  }

  /// Primary key in the DB
  int? id;
  Future createTable(Database db);
}

typedef EntityBuilder<T extends Entity> = T Function();

class EntityProvider<T extends Entity> {
  late Database db;
  final EntityBuilder<T> builder;

  /// Will not continue on error in batch operation
  final bool _debugBatchOperation = false;

  EntityProvider({
    required EntityBuilder<T> builder,
  }) : this._(builder);

  EntityProvider._(this.builder) {
    if (_debugBatchOperation) {
      debugPrint(
          '[EntityProvider]: _debugBatchOperation is ON! all batch operations will stop on error');
    }
  }

  Future<T?> getOne(int id) async {
    final T entity = builder();
    final List<Map<String, dynamic>> maps = await db.query(entity.tableName(),
        where: 'Id = ?', whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return entity.fromJson(maps.first);
    }
    return null;
  }

  Future<T?> findOne({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final T entity = builder();
    final List<Map<String, dynamic>> maps = await db.query(entity.tableName(),
        where: where, whereArgs: whereArgs, limit: 1);
    if (maps.isNotEmpty) {
      return entity.fromJson(maps.first);
    }
    return null;
  }

  Future<List<T>?> findAll({
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final T entity = builder();
    final List<Map<String, dynamic>> maps = await db.query(entity.tableName(),
        where: where, whereArgs: whereArgs, orderBy: orderBy);

    final List<T> result = [];
    for (var m in maps) {
      result.add(entity.fromJson(m));
    }

    return result;
  }

  Future<T> findLast({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final T entity = builder();
    final List<Map<String, dynamic>> maps = await db.query(entity.tableName(),
        where: where, whereArgs: whereArgs, orderBy: 'Id DESC', limit: 1);

    return entity.fromJson(maps.last);
  }

  /// Inserts an entity into a database and creates local id
  Future<void> insert(T entity, {Batch? batch}) async {
    final dynamic executor = batch ?? db;
    try {
      final recordId = await executor.insert(
          entity.tableName(), entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      entity.id = recordId;
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  /// Inserts or updates entity in the database
  /// If there is a `localId` presented - will update straight away
  /// If there is a `Id` only present - will search for an entity with such `Id`, then update or insert.
  /// If neither is present - will run `insert` and create `localId`
  Future<void> upsert(T entity, {Batch? batch}) async {
    final dynamic executor = batch ?? db;

    if (entity.id != null) {
      final T? storedData =
          await findOne(where: 'Id = ?', whereArgs: [entity.id]);

      if (storedData != null) {
        await executor.update(entity.tableName(), entity.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
            where: 'Id = ?',
            whereArgs: [entity.id]);
      } else {
        await insert(entity, batch: batch);
      }
    } else {
      await insert(entity, batch: batch);
    }
  }

  Future<List<dynamic>> upsertList(List<T> entities) async {
    try {
      final batch = db.batch();

      for (int i = 0; i < entities.length; i++) {
        await upsert(entities[i], batch: batch);
      }
      final recordIds = await batch.commit(
          noResult: false, continueOnError: !_debugBatchOperation);

      return recordIds;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  Future<int> update(
    T entity, {
    Batch? batch,
  }) async {
    final dynamic executor = batch ?? db;
    return await executor.update(entity.tableName(), entity.toJson(),
        where: 'Id = ?', whereArgs: [entity.id]);
  }

  Future<int> delete(
    T entity, {
    Batch? batch,
  }) async {
    final dynamic executor = batch ?? db;
    return await executor
        .delete(entity.tableName(), where: 'Id = ?', whereArgs: [entity.id]);
  }

  Future<List<dynamic>> deleteList(
    List<T> entities,
  ) async {
    final batch = db.batch();

    for (int i = 0; i < entities.length; i++) {
      await delete(entities[i], batch: batch);
    }

    return await batch.commit(
        noResult: false, continueOnError: !_debugBatchOperation);
  }

  /// This is used to clean up entities that have been hard deleted from the server.
  /// Uses remote ID type by default, so ensure to pass entities that came from the server
  /// Make sure list of entities passed is not filtered and is the only thing that should be there.
  Future<int> deleteAllNotInList(List<T> remoteEntities) async {
    try {
      if (remoteEntities.isEmpty) {
        return 0;
      }

      final entityIds = remoteEntities
          .where((e) => e.id != null)
          .map<String>((e) => e.id.toString())
          .toList();
      if (entityIds.isEmpty) {
        return 0;
      }

      final result = await db.delete(remoteEntities[0].tableName(),
          where: 'Id NOT IN (${entityIds.join(',')}) OR Id IS NULL');
      return result;
    } catch (error) {
      debugPrint(error.toString());
      return -1;
    }
  }
}

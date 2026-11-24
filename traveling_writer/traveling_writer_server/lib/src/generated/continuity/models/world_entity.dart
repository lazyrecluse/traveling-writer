/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:traveling_writer_server/src/generated/protocol.dart'
    as _ivgs3v8u;

abstract class WorldEntity
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  WorldEntity._({
    this.id,
    this.worldId,
    required this.name,
    required this.category,
    required this.description,
    this.traits,
    required this.isActive,
  });

  factory WorldEntity({
    int? id,
    int? worldId,
    required String name,
    required String category,
    required String description,
    List<String>? traits,
    required bool isActive,
  }) = _WorldEntityImpl;

  factory WorldEntity.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorldEntity(
      id: jsonSerialization['id'] as int?,
      worldId: jsonSerialization['worldId'] as int?,
      name: jsonSerialization['name'] as String,
      category: jsonSerialization['category'] as String,
      description: jsonSerialization['description'] as String,
      traits: jsonSerialization['traits'] == null
          ? null
          : _ivgs3v8u.Protocol().deserialize<List<String>>(
              jsonSerialization['traits'],
            ),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  static final t = WorldEntityTable();

  static const db = WorldEntityRepository._();

  @override
  int? id;

  int? worldId;

  String name;

  String category;

  String description;

  List<String>? traits;

  bool isActive;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [WorldEntity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorldEntity copyWith({
    int? id,
    int? worldId,
    String? name,
    String? category,
    String? description,
    List<String>? traits,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorldEntity',
      if (id != null) 'id': id,
      if (worldId != null) 'worldId': worldId,
      'name': name,
      'category': category,
      'description': description,
      if (traits != null) 'traits': traits?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorldEntity',
      if (id != null) 'id': id,
      if (worldId != null) 'worldId': worldId,
      'name': name,
      'category': category,
      'description': description,
      if (traits != null) 'traits': traits?.toJson(),
      'isActive': isActive,
    };
  }

  static WorldEntityInclude include() {
    return WorldEntityInclude._();
  }

  static WorldEntityIncludeList includeList({
    _is.WhereExpressionBuilder<WorldEntityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorldEntityTable>? orderBy,
    _is.OrderByListBuilder<WorldEntityTable>? orderByList,
    WorldEntityInclude? include,
  }) {
    return WorldEntityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorldEntity.t),
      orderByList: orderByList?.call(WorldEntity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorldEntityImpl extends WorldEntity {
  _WorldEntityImpl({
    int? id,
    int? worldId,
    required String name,
    required String category,
    required String description,
    List<String>? traits,
    required bool isActive,
  }) : super._(
         id: id,
         worldId: worldId,
         name: name,
         category: category,
         description: description,
         traits: traits,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [WorldEntity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorldEntity copyWith({
    Object? id = _Undefined,
    Object? worldId = _Undefined,
    String? name,
    String? category,
    String? description,
    Object? traits = _Undefined,
    bool? isActive,
  }) {
    return WorldEntity(
      id: id is int? ? id : this.id,
      worldId: worldId is int? ? worldId : this.worldId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      traits: traits is List<String>?
          ? traits
          : this.traits?.map((e0) => e0).toList(),
      isActive: isActive ?? this.isActive,
    );
  }
}

class WorldEntityUpdateTable extends _is.UpdateTable<WorldEntityTable> {
  WorldEntityUpdateTable(super.table);

  _is.ColumnValue<int, int> worldId(int? value) => _is.ColumnValue(
    table.worldId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> category(String value) => _is.ColumnValue(
    table.category,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> traits(List<String>? value) =>
      _is.ColumnValue(
        table.traits,
        value,
      );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );
}

class WorldEntityTable extends _is.Table<int?> {
  WorldEntityTable({super.tableRelation}) : super(tableName: 'world_entity') {
    updateTable = WorldEntityUpdateTable(this);
    worldId = _is.ColumnInt(
      'worldId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    traits = _is.ColumnSerializable<List<String>>(
      'traits',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
  }

  late final WorldEntityUpdateTable updateTable;

  late final _is.ColumnInt worldId;

  late final _is.ColumnString name;

  late final _is.ColumnString category;

  late final _is.ColumnString description;

  late final _is.ColumnSerializable<List<String>> traits;

  late final _is.ColumnBool isActive;

  @override
  List<_is.Column> get columns => [
    id,
    worldId,
    name,
    category,
    description,
    traits,
    isActive,
  ];
}

class WorldEntityInclude extends _is.IncludeObject {
  WorldEntityInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => WorldEntity.t;
}

class WorldEntityIncludeList extends _is.IncludeList {
  WorldEntityIncludeList._({
    _is.WhereExpressionBuilder<WorldEntityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorldEntity.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => WorldEntity.t;
}

class WorldEntityRepository {
  const WorldEntityRepository._();

  /// Returns a list of [WorldEntity]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<WorldEntity>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorldEntityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorldEntityTable>? orderBy,
    _is.OrderByListBuilder<WorldEntityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WorldEntity>(
      where: where?.call(WorldEntity.t),
      orderBy: orderBy?.call(WorldEntity.t),
      orderByList: orderByList?.call(WorldEntity.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WorldEntity] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<WorldEntity?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorldEntityTable>? where,
    int? offset,
    _is.OrderByBuilder<WorldEntityTable>? orderBy,
    _is.OrderByListBuilder<WorldEntityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WorldEntity>(
      where: where?.call(WorldEntity.t),
      orderBy: orderBy?.call(WorldEntity.t),
      orderByList: orderByList?.call(WorldEntity.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WorldEntity] by its [id] or null if no such row exists.
  Future<WorldEntity?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WorldEntity>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WorldEntity]s in the list and returns the inserted rows.
  ///
  /// The returned [WorldEntity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorldEntity>> insert(
    _is.DatabaseSession session,
    List<WorldEntity> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WorldEntity>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WorldEntity] and returns the inserted row.
  ///
  /// The returned [WorldEntity] will have its `id` field set.
  Future<WorldEntity> insertRow(
    _is.DatabaseSession session,
    WorldEntity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorldEntity>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WorldEntity]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [WorldEntity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorldEntity>> upsert(
    _is.DatabaseSession session,
    List<WorldEntity> rows, {
    required _is.ColumnSelections<WorldEntityTable> conflictColumns,
    _is.ColumnSelections<WorldEntityTable>? updateColumns,
    _is.WhereExpressionBuilder<WorldEntityTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WorldEntity>(
      rows,
      conflictColumns: conflictColumns(WorldEntity.t),
      updateColumns: updateColumns?.call(WorldEntity.t),
      updateWhere: updateWhere?.call(WorldEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WorldEntity] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [WorldEntity] will have its `id` field set.
  Future<WorldEntity?> upsertRow(
    _is.DatabaseSession session,
    WorldEntity row, {
    required _is.ColumnSelections<WorldEntityTable> conflictColumns,
    _is.ColumnSelections<WorldEntityTable>? updateColumns,
    _is.WhereExpressionBuilder<WorldEntityTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WorldEntity>(
      row,
      conflictColumns: conflictColumns(WorldEntity.t),
      updateColumns: updateColumns?.call(WorldEntity.t),
      updateWhere: updateWhere?.call(WorldEntity.t),
      transaction: transaction,
    );
  }

  /// Updates all [WorldEntity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorldEntity>> update(
    _is.DatabaseSession session,
    List<WorldEntity> rows, {
    _is.ColumnSelections<WorldEntityTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WorldEntity>(
      rows,
      columns: columns?.call(WorldEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WorldEntity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorldEntity> updateRow(
    _is.DatabaseSession session,
    WorldEntity row, {
    _is.ColumnSelections<WorldEntityTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorldEntity>(
      row,
      columns: columns?.call(WorldEntity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorldEntity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WorldEntity?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WorldEntityUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WorldEntity>(
      id,
      columnValues: columnValues(WorldEntity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WorldEntity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorldEntity>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WorldEntityUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<WorldEntityTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorldEntityTable>? orderBy,
    _is.OrderByListBuilder<WorldEntityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WorldEntity>(
      columnValues: columnValues(WorldEntity.t.updateTable),
      where: where(WorldEntity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorldEntity.t),
      orderByList: orderByList?.call(WorldEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WorldEntity]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorldEntity>> delete(
    _is.DatabaseSession session,
    List<WorldEntity> rows, {
    _is.OrderByBuilder<WorldEntityTable>? orderBy,
    _is.OrderByListBuilder<WorldEntityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WorldEntity>(
      rows,
      orderBy: orderBy?.call(WorldEntity.t),
      orderByList: orderByList?.call(WorldEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WorldEntity].
  Future<WorldEntity> deleteRow(
    _is.DatabaseSession session,
    WorldEntity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorldEntity>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorldEntity>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorldEntityTable> where,
    _is.OrderByBuilder<WorldEntityTable>? orderBy,
    _is.OrderByListBuilder<WorldEntityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WorldEntity>(
      where: where(WorldEntity.t),
      orderBy: orderBy?.call(WorldEntity.t),
      orderByList: orderByList?.call(WorldEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorldEntityTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WorldEntity>(
      where: where?.call(WorldEntity.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WorldEntity] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorldEntityTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WorldEntity>(
      where: where(WorldEntity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

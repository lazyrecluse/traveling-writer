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

abstract class World implements _is.TableRow<int?>, _is.ProtocolSerialization {
  World._({
    this.id,
    required this.name,
    this.genre,
    this.description,
    this.ownerId,
    required this.createdAt,
  });

  factory World({
    int? id,
    required String name,
    String? genre,
    String? description,
    String? ownerId,
    required DateTime createdAt,
  }) = _WorldImpl;

  factory World.fromJson(Map<String, dynamic> jsonSerialization) {
    return World(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      genre: jsonSerialization['genre'] as String?,
      description: jsonSerialization['description'] as String?,
      ownerId: jsonSerialization['ownerId'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = WorldTable();

  static const db = WorldRepository._();

  @override
  int? id;

  String name;

  String? genre;

  String? description;

  String? ownerId;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [World]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  World copyWith({
    int? id,
    String? name,
    String? genre,
    String? description,
    String? ownerId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'World',
      if (id != null) 'id': id,
      'name': name,
      if (genre != null) 'genre': genre,
      if (description != null) 'description': description,
      if (ownerId != null) 'ownerId': ownerId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'World',
      if (id != null) 'id': id,
      'name': name,
      if (genre != null) 'genre': genre,
      if (description != null) 'description': description,
      if (ownerId != null) 'ownerId': ownerId,
      'createdAt': createdAt.toJson(),
    };
  }

  static WorldInclude include() {
    return WorldInclude._();
  }

  static WorldIncludeList includeList({
    _is.WhereExpressionBuilder<WorldTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorldTable>? orderBy,
    _is.OrderByListBuilder<WorldTable>? orderByList,
    WorldInclude? include,
  }) {
    return WorldIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(World.t),
      orderByList: orderByList?.call(World.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorldImpl extends World {
  _WorldImpl({
    int? id,
    required String name,
    String? genre,
    String? description,
    String? ownerId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         genre: genre,
         description: description,
         ownerId: ownerId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [World]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  World copyWith({
    Object? id = _Undefined,
    String? name,
    Object? genre = _Undefined,
    Object? description = _Undefined,
    Object? ownerId = _Undefined,
    DateTime? createdAt,
  }) {
    return World(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      genre: genre is String? ? genre : this.genre,
      description: description is String? ? description : this.description,
      ownerId: ownerId is String? ? ownerId : this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WorldUpdateTable extends _is.UpdateTable<WorldTable> {
  WorldUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> genre(String? value) => _is.ColumnValue(
    table.genre,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> ownerId(String? value) => _is.ColumnValue(
    table.ownerId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class WorldTable extends _is.Table<int?> {
  WorldTable({super.tableRelation}) : super(tableName: 'world') {
    updateTable = WorldUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    genre = _is.ColumnString(
      'genre',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    ownerId = _is.ColumnString(
      'ownerId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final WorldUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString genre;

  late final _is.ColumnString description;

  late final _is.ColumnString ownerId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    genre,
    description,
    ownerId,
    createdAt,
  ];
}

class WorldInclude extends _is.IncludeObject {
  WorldInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => World.t;
}

class WorldIncludeList extends _is.IncludeList {
  WorldIncludeList._({
    _is.WhereExpressionBuilder<WorldTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(World.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => World.t;
}

class WorldRepository {
  const WorldRepository._();

  /// Returns a list of [World]s matching the given query parameters.
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
  Future<List<World>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorldTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorldTable>? orderBy,
    _is.OrderByListBuilder<WorldTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<World>(
      where: where?.call(World.t),
      orderBy: orderBy?.call(World.t),
      orderByList: orderByList?.call(World.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [World] matching the given query parameters.
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
  Future<World?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorldTable>? where,
    int? offset,
    _is.OrderByBuilder<WorldTable>? orderBy,
    _is.OrderByListBuilder<WorldTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<World>(
      where: where?.call(World.t),
      orderBy: orderBy?.call(World.t),
      orderByList: orderByList?.call(World.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [World] by its [id] or null if no such row exists.
  Future<World?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<World>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [World]s in the list and returns the inserted rows.
  ///
  /// The returned [World]s will have their `id` fields set.
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
  Future<List<World>> insert(
    _is.DatabaseSession session,
    List<World> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<World>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [World] and returns the inserted row.
  ///
  /// The returned [World] will have its `id` field set.
  Future<World> insertRow(
    _is.DatabaseSession session,
    World row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<World>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [World]s in the list and returns the resulting rows.
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
  /// The returned [World]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<World>> upsert(
    _is.DatabaseSession session,
    List<World> rows, {
    required _is.ColumnSelections<WorldTable> conflictColumns,
    _is.ColumnSelections<WorldTable>? updateColumns,
    _is.WhereExpressionBuilder<WorldTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<World>(
      rows,
      conflictColumns: conflictColumns(World.t),
      updateColumns: updateColumns?.call(World.t),
      updateWhere: updateWhere?.call(World.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [World] and returns the resulting row.
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
  /// The returned [World] will have its `id` field set.
  Future<World?> upsertRow(
    _is.DatabaseSession session,
    World row, {
    required _is.ColumnSelections<WorldTable> conflictColumns,
    _is.ColumnSelections<WorldTable>? updateColumns,
    _is.WhereExpressionBuilder<WorldTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<World>(
      row,
      conflictColumns: conflictColumns(World.t),
      updateColumns: updateColumns?.call(World.t),
      updateWhere: updateWhere?.call(World.t),
      transaction: transaction,
    );
  }

  /// Updates all [World]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<World>> update(
    _is.DatabaseSession session,
    List<World> rows, {
    _is.ColumnSelections<WorldTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<World>(
      rows,
      columns: columns?.call(World.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [World]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<World> updateRow(
    _is.DatabaseSession session,
    World row, {
    _is.ColumnSelections<WorldTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<World>(
      row,
      columns: columns?.call(World.t),
      transaction: transaction,
    );
  }

  /// Updates a single [World] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<World?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WorldUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<World>(
      id,
      columnValues: columnValues(World.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [World]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<World>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WorldUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<WorldTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorldTable>? orderBy,
    _is.OrderByListBuilder<WorldTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<World>(
      columnValues: columnValues(World.t.updateTable),
      where: where(World.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(World.t),
      orderByList: orderByList?.call(World.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [World]s in the list and returns the deleted rows.
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
  Future<List<World>> delete(
    _is.DatabaseSession session,
    List<World> rows, {
    _is.OrderByBuilder<WorldTable>? orderBy,
    _is.OrderByListBuilder<WorldTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<World>(
      rows,
      orderBy: orderBy?.call(World.t),
      orderByList: orderByList?.call(World.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [World].
  Future<World> deleteRow(
    _is.DatabaseSession session,
    World row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<World>(
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
  Future<List<World>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorldTable> where,
    _is.OrderByBuilder<WorldTable>? orderBy,
    _is.OrderByListBuilder<WorldTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<World>(
      where: where(World.t),
      orderBy: orderBy?.call(World.t),
      orderByList: orderByList?.call(World.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorldTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<World>(
      where: where?.call(World.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [World] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorldTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<World>(
      where: where(World.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

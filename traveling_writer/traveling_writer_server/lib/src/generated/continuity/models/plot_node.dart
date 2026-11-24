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

abstract class PlotNode
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PlotNode._({
    this.id,
    this.worldId,
    required this.title,
    required this.summary,
    this.content,
    required this.positionX,
    required this.positionY,
    this.connectedNodeIds,
    this.entityIds,
    required this.status,
  });

  factory PlotNode({
    int? id,
    int? worldId,
    required String title,
    required String summary,
    String? content,
    required double positionX,
    required double positionY,
    List<int>? connectedNodeIds,
    List<int>? entityIds,
    required String status,
  }) = _PlotNodeImpl;

  factory PlotNode.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlotNode(
      id: jsonSerialization['id'] as int?,
      worldId: jsonSerialization['worldId'] as int?,
      title: jsonSerialization['title'] as String,
      summary: jsonSerialization['summary'] as String,
      content: jsonSerialization['content'] as String?,
      positionX: (jsonSerialization['positionX'] as num).toDouble(),
      positionY: (jsonSerialization['positionY'] as num).toDouble(),
      connectedNodeIds: jsonSerialization['connectedNodeIds'] == null
          ? null
          : _ivgs3v8u.Protocol().deserialize<List<int>>(
              jsonSerialization['connectedNodeIds'],
            ),
      entityIds: jsonSerialization['entityIds'] == null
          ? null
          : _ivgs3v8u.Protocol().deserialize<List<int>>(
              jsonSerialization['entityIds'],
            ),
      status: jsonSerialization['status'] as String,
    );
  }

  static final t = PlotNodeTable();

  static const db = PlotNodeRepository._();

  @override
  int? id;

  int? worldId;

  String title;

  String summary;

  String? content;

  double positionX;

  double positionY;

  List<int>? connectedNodeIds;

  List<int>? entityIds;

  String status;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PlotNode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlotNode copyWith({
    int? id,
    int? worldId,
    String? title,
    String? summary,
    String? content,
    double? positionX,
    double? positionY,
    List<int>? connectedNodeIds,
    List<int>? entityIds,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlotNode',
      if (id != null) 'id': id,
      if (worldId != null) 'worldId': worldId,
      'title': title,
      'summary': summary,
      if (content != null) 'content': content,
      'positionX': positionX,
      'positionY': positionY,
      if (connectedNodeIds != null)
        'connectedNodeIds': connectedNodeIds?.toJson(),
      if (entityIds != null) 'entityIds': entityIds?.toJson(),
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlotNode',
      if (id != null) 'id': id,
      if (worldId != null) 'worldId': worldId,
      'title': title,
      'summary': summary,
      if (content != null) 'content': content,
      'positionX': positionX,
      'positionY': positionY,
      if (connectedNodeIds != null)
        'connectedNodeIds': connectedNodeIds?.toJson(),
      if (entityIds != null) 'entityIds': entityIds?.toJson(),
      'status': status,
    };
  }

  static PlotNodeInclude include() {
    return PlotNodeInclude._();
  }

  static PlotNodeIncludeList includeList({
    _is.WhereExpressionBuilder<PlotNodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlotNodeTable>? orderBy,
    _is.OrderByListBuilder<PlotNodeTable>? orderByList,
    PlotNodeInclude? include,
  }) {
    return PlotNodeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlotNode.t),
      orderByList: orderByList?.call(PlotNode.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlotNodeImpl extends PlotNode {
  _PlotNodeImpl({
    int? id,
    int? worldId,
    required String title,
    required String summary,
    String? content,
    required double positionX,
    required double positionY,
    List<int>? connectedNodeIds,
    List<int>? entityIds,
    required String status,
  }) : super._(
         id: id,
         worldId: worldId,
         title: title,
         summary: summary,
         content: content,
         positionX: positionX,
         positionY: positionY,
         connectedNodeIds: connectedNodeIds,
         entityIds: entityIds,
         status: status,
       );

  /// Returns a shallow copy of this [PlotNode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlotNode copyWith({
    Object? id = _Undefined,
    Object? worldId = _Undefined,
    String? title,
    String? summary,
    Object? content = _Undefined,
    double? positionX,
    double? positionY,
    Object? connectedNodeIds = _Undefined,
    Object? entityIds = _Undefined,
    String? status,
  }) {
    return PlotNode(
      id: id is int? ? id : this.id,
      worldId: worldId is int? ? worldId : this.worldId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content is String? ? content : this.content,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      connectedNodeIds: connectedNodeIds is List<int>?
          ? connectedNodeIds
          : this.connectedNodeIds?.map((e0) => e0).toList(),
      entityIds: entityIds is List<int>?
          ? entityIds
          : this.entityIds?.map((e0) => e0).toList(),
      status: status ?? this.status,
    );
  }
}

class PlotNodeUpdateTable extends _is.UpdateTable<PlotNodeTable> {
  PlotNodeUpdateTable(super.table);

  _is.ColumnValue<int, int> worldId(int? value) => _is.ColumnValue(
    table.worldId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> summary(String value) => _is.ColumnValue(
    table.summary,
    value,
  );

  _is.ColumnValue<String, String> content(String? value) => _is.ColumnValue(
    table.content,
    value,
  );

  _is.ColumnValue<double, double> positionX(double value) => _is.ColumnValue(
    table.positionX,
    value,
  );

  _is.ColumnValue<double, double> positionY(double value) => _is.ColumnValue(
    table.positionY,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> connectedNodeIds(List<int>? value) =>
      _is.ColumnValue(
        table.connectedNodeIds,
        value,
      );

  _is.ColumnValue<List<int>, List<int>> entityIds(List<int>? value) =>
      _is.ColumnValue(
        table.entityIds,
        value,
      );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );
}

class PlotNodeTable extends _is.Table<int?> {
  PlotNodeTable({super.tableRelation}) : super(tableName: 'plot_node') {
    updateTable = PlotNodeUpdateTable(this);
    worldId = _is.ColumnInt(
      'worldId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    summary = _is.ColumnString(
      'summary',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    positionX = _is.ColumnDouble(
      'positionX',
      this,
    );
    positionY = _is.ColumnDouble(
      'positionY',
      this,
    );
    connectedNodeIds = _is.ColumnSerializable<List<int>>(
      'connectedNodeIds',
      this,
    );
    entityIds = _is.ColumnSerializable<List<int>>(
      'entityIds',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
  }

  late final PlotNodeUpdateTable updateTable;

  late final _is.ColumnInt worldId;

  late final _is.ColumnString title;

  late final _is.ColumnString summary;

  late final _is.ColumnString content;

  late final _is.ColumnDouble positionX;

  late final _is.ColumnDouble positionY;

  late final _is.ColumnSerializable<List<int>> connectedNodeIds;

  late final _is.ColumnSerializable<List<int>> entityIds;

  late final _is.ColumnString status;

  @override
  List<_is.Column> get columns => [
    id,
    worldId,
    title,
    summary,
    content,
    positionX,
    positionY,
    connectedNodeIds,
    entityIds,
    status,
  ];
}

class PlotNodeInclude extends _is.IncludeObject {
  PlotNodeInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PlotNode.t;
}

class PlotNodeIncludeList extends _is.IncludeList {
  PlotNodeIncludeList._({
    _is.WhereExpressionBuilder<PlotNodeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PlotNode.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PlotNode.t;
}

class PlotNodeRepository {
  const PlotNodeRepository._();

  /// Returns a list of [PlotNode]s matching the given query parameters.
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
  Future<List<PlotNode>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlotNodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlotNodeTable>? orderBy,
    _is.OrderByListBuilder<PlotNodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PlotNode>(
      where: where?.call(PlotNode.t),
      orderBy: orderBy?.call(PlotNode.t),
      orderByList: orderByList?.call(PlotNode.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PlotNode] matching the given query parameters.
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
  Future<PlotNode?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlotNodeTable>? where,
    int? offset,
    _is.OrderByBuilder<PlotNodeTable>? orderBy,
    _is.OrderByListBuilder<PlotNodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PlotNode>(
      where: where?.call(PlotNode.t),
      orderBy: orderBy?.call(PlotNode.t),
      orderByList: orderByList?.call(PlotNode.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PlotNode] by its [id] or null if no such row exists.
  Future<PlotNode?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PlotNode>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PlotNode]s in the list and returns the inserted rows.
  ///
  /// The returned [PlotNode]s will have their `id` fields set.
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
  Future<List<PlotNode>> insert(
    _is.DatabaseSession session,
    List<PlotNode> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PlotNode>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PlotNode] and returns the inserted row.
  ///
  /// The returned [PlotNode] will have its `id` field set.
  Future<PlotNode> insertRow(
    _is.DatabaseSession session,
    PlotNode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PlotNode>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PlotNode]s in the list and returns the resulting rows.
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
  /// The returned [PlotNode]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlotNode>> upsert(
    _is.DatabaseSession session,
    List<PlotNode> rows, {
    required _is.ColumnSelections<PlotNodeTable> conflictColumns,
    _is.ColumnSelections<PlotNodeTable>? updateColumns,
    _is.WhereExpressionBuilder<PlotNodeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PlotNode>(
      rows,
      conflictColumns: conflictColumns(PlotNode.t),
      updateColumns: updateColumns?.call(PlotNode.t),
      updateWhere: updateWhere?.call(PlotNode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PlotNode] and returns the resulting row.
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
  /// The returned [PlotNode] will have its `id` field set.
  Future<PlotNode?> upsertRow(
    _is.DatabaseSession session,
    PlotNode row, {
    required _is.ColumnSelections<PlotNodeTable> conflictColumns,
    _is.ColumnSelections<PlotNodeTable>? updateColumns,
    _is.WhereExpressionBuilder<PlotNodeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PlotNode>(
      row,
      conflictColumns: conflictColumns(PlotNode.t),
      updateColumns: updateColumns?.call(PlotNode.t),
      updateWhere: updateWhere?.call(PlotNode.t),
      transaction: transaction,
    );
  }

  /// Updates all [PlotNode]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlotNode>> update(
    _is.DatabaseSession session,
    List<PlotNode> rows, {
    _is.ColumnSelections<PlotNodeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PlotNode>(
      rows,
      columns: columns?.call(PlotNode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PlotNode]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PlotNode> updateRow(
    _is.DatabaseSession session,
    PlotNode row, {
    _is.ColumnSelections<PlotNodeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PlotNode>(
      row,
      columns: columns?.call(PlotNode.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PlotNode] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PlotNode?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PlotNodeUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PlotNode>(
      id,
      columnValues: columnValues(PlotNode.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PlotNode]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlotNode>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PlotNodeUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PlotNodeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlotNodeTable>? orderBy,
    _is.OrderByListBuilder<PlotNodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PlotNode>(
      columnValues: columnValues(PlotNode.t.updateTable),
      where: where(PlotNode.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlotNode.t),
      orderByList: orderByList?.call(PlotNode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PlotNode]s in the list and returns the deleted rows.
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
  Future<List<PlotNode>> delete(
    _is.DatabaseSession session,
    List<PlotNode> rows, {
    _is.OrderByBuilder<PlotNodeTable>? orderBy,
    _is.OrderByListBuilder<PlotNodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PlotNode>(
      rows,
      orderBy: orderBy?.call(PlotNode.t),
      orderByList: orderByList?.call(PlotNode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PlotNode].
  Future<PlotNode> deleteRow(
    _is.DatabaseSession session,
    PlotNode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PlotNode>(
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
  Future<List<PlotNode>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlotNodeTable> where,
    _is.OrderByBuilder<PlotNodeTable>? orderBy,
    _is.OrderByListBuilder<PlotNodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PlotNode>(
      where: where(PlotNode.t),
      orderBy: orderBy?.call(PlotNode.t),
      orderByList: orderByList?.call(PlotNode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlotNodeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PlotNode>(
      where: where?.call(PlotNode.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PlotNode] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlotNodeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PlotNode>(
      where: where(PlotNode.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

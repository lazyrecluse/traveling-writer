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

abstract class WorldRule
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  WorldRule._({
    this.id,
    this.worldId,
    this.entityId,
    required this.subject,
    required this.relation,
    required this.constraint,
    this.explanation,
    required this.severity,
    required this.isActive,
  });

  factory WorldRule({
    int? id,
    int? worldId,
    int? entityId,
    required String subject,
    required String relation,
    required String constraint,
    String? explanation,
    required String severity,
    required bool isActive,
  }) = _WorldRuleImpl;

  factory WorldRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorldRule(
      id: jsonSerialization['id'] as int?,
      worldId: jsonSerialization['worldId'] as int?,
      entityId: jsonSerialization['entityId'] as int?,
      subject: jsonSerialization['subject'] as String,
      relation: jsonSerialization['relation'] as String,
      constraint: jsonSerialization['constraint'] as String,
      explanation: jsonSerialization['explanation'] as String?,
      severity: jsonSerialization['severity'] as String,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  static final t = WorldRuleTable();

  static const db = WorldRuleRepository._();

  @override
  int? id;

  int? worldId;

  int? entityId;

  String subject;

  String relation;

  String constraint;

  String? explanation;

  String severity;

  bool isActive;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [WorldRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorldRule copyWith({
    int? id,
    int? worldId,
    int? entityId,
    String? subject,
    String? relation,
    String? constraint,
    String? explanation,
    String? severity,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorldRule',
      if (id != null) 'id': id,
      if (worldId != null) 'worldId': worldId,
      if (entityId != null) 'entityId': entityId,
      'subject': subject,
      'relation': relation,
      'constraint': constraint,
      if (explanation != null) 'explanation': explanation,
      'severity': severity,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorldRule',
      if (id != null) 'id': id,
      if (worldId != null) 'worldId': worldId,
      if (entityId != null) 'entityId': entityId,
      'subject': subject,
      'relation': relation,
      'constraint': constraint,
      if (explanation != null) 'explanation': explanation,
      'severity': severity,
      'isActive': isActive,
    };
  }

  static WorldRuleInclude include() {
    return WorldRuleInclude._();
  }

  static WorldRuleIncludeList includeList({
    _is.WhereExpressionBuilder<WorldRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorldRuleTable>? orderBy,
    _is.OrderByListBuilder<WorldRuleTable>? orderByList,
    WorldRuleInclude? include,
  }) {
    return WorldRuleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorldRule.t),
      orderByList: orderByList?.call(WorldRule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorldRuleImpl extends WorldRule {
  _WorldRuleImpl({
    int? id,
    int? worldId,
    int? entityId,
    required String subject,
    required String relation,
    required String constraint,
    String? explanation,
    required String severity,
    required bool isActive,
  }) : super._(
         id: id,
         worldId: worldId,
         entityId: entityId,
         subject: subject,
         relation: relation,
         constraint: constraint,
         explanation: explanation,
         severity: severity,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [WorldRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorldRule copyWith({
    Object? id = _Undefined,
    Object? worldId = _Undefined,
    Object? entityId = _Undefined,
    String? subject,
    String? relation,
    String? constraint,
    Object? explanation = _Undefined,
    String? severity,
    bool? isActive,
  }) {
    return WorldRule(
      id: id is int? ? id : this.id,
      worldId: worldId is int? ? worldId : this.worldId,
      entityId: entityId is int? ? entityId : this.entityId,
      subject: subject ?? this.subject,
      relation: relation ?? this.relation,
      constraint: constraint ?? this.constraint,
      explanation: explanation is String? ? explanation : this.explanation,
      severity: severity ?? this.severity,
      isActive: isActive ?? this.isActive,
    );
  }
}

class WorldRuleUpdateTable extends _is.UpdateTable<WorldRuleTable> {
  WorldRuleUpdateTable(super.table);

  _is.ColumnValue<int, int> worldId(int? value) => _is.ColumnValue(
    table.worldId,
    value,
  );

  _is.ColumnValue<int, int> entityId(int? value) => _is.ColumnValue(
    table.entityId,
    value,
  );

  _is.ColumnValue<String, String> subject(String value) => _is.ColumnValue(
    table.subject,
    value,
  );

  _is.ColumnValue<String, String> relation(String value) => _is.ColumnValue(
    table.relation,
    value,
  );

  _is.ColumnValue<String, String> constraint(String value) => _is.ColumnValue(
    table.constraint,
    value,
  );

  _is.ColumnValue<String, String> explanation(String? value) => _is.ColumnValue(
    table.explanation,
    value,
  );

  _is.ColumnValue<String, String> severity(String value) => _is.ColumnValue(
    table.severity,
    value,
  );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );
}

class WorldRuleTable extends _is.Table<int?> {
  WorldRuleTable({super.tableRelation}) : super(tableName: 'world_rule') {
    updateTable = WorldRuleUpdateTable(this);
    worldId = _is.ColumnInt(
      'worldId',
      this,
    );
    entityId = _is.ColumnInt(
      'entityId',
      this,
    );
    subject = _is.ColumnString(
      'subject',
      this,
    );
    relation = _is.ColumnString(
      'relation',
      this,
    );
    constraint = _is.ColumnString(
      'constraint',
      this,
    );
    explanation = _is.ColumnString(
      'explanation',
      this,
    );
    severity = _is.ColumnString(
      'severity',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
  }

  late final WorldRuleUpdateTable updateTable;

  late final _is.ColumnInt worldId;

  late final _is.ColumnInt entityId;

  late final _is.ColumnString subject;

  late final _is.ColumnString relation;

  late final _is.ColumnString constraint;

  late final _is.ColumnString explanation;

  late final _is.ColumnString severity;

  late final _is.ColumnBool isActive;

  @override
  List<_is.Column> get columns => [
    id,
    worldId,
    entityId,
    subject,
    relation,
    constraint,
    explanation,
    severity,
    isActive,
  ];
}

class WorldRuleInclude extends _is.IncludeObject {
  WorldRuleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => WorldRule.t;
}

class WorldRuleIncludeList extends _is.IncludeList {
  WorldRuleIncludeList._({
    _is.WhereExpressionBuilder<WorldRuleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorldRule.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => WorldRule.t;
}

class WorldRuleRepository {
  const WorldRuleRepository._();

  /// Returns a list of [WorldRule]s matching the given query parameters.
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
  Future<List<WorldRule>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorldRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorldRuleTable>? orderBy,
    _is.OrderByListBuilder<WorldRuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WorldRule>(
      where: where?.call(WorldRule.t),
      orderBy: orderBy?.call(WorldRule.t),
      orderByList: orderByList?.call(WorldRule.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WorldRule] matching the given query parameters.
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
  Future<WorldRule?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorldRuleTable>? where,
    int? offset,
    _is.OrderByBuilder<WorldRuleTable>? orderBy,
    _is.OrderByListBuilder<WorldRuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WorldRule>(
      where: where?.call(WorldRule.t),
      orderBy: orderBy?.call(WorldRule.t),
      orderByList: orderByList?.call(WorldRule.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WorldRule] by its [id] or null if no such row exists.
  Future<WorldRule?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WorldRule>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WorldRule]s in the list and returns the inserted rows.
  ///
  /// The returned [WorldRule]s will have their `id` fields set.
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
  Future<List<WorldRule>> insert(
    _is.DatabaseSession session,
    List<WorldRule> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WorldRule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WorldRule] and returns the inserted row.
  ///
  /// The returned [WorldRule] will have its `id` field set.
  Future<WorldRule> insertRow(
    _is.DatabaseSession session,
    WorldRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorldRule>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WorldRule]s in the list and returns the resulting rows.
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
  /// The returned [WorldRule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorldRule>> upsert(
    _is.DatabaseSession session,
    List<WorldRule> rows, {
    required _is.ColumnSelections<WorldRuleTable> conflictColumns,
    _is.ColumnSelections<WorldRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<WorldRuleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WorldRule>(
      rows,
      conflictColumns: conflictColumns(WorldRule.t),
      updateColumns: updateColumns?.call(WorldRule.t),
      updateWhere: updateWhere?.call(WorldRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WorldRule] and returns the resulting row.
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
  /// The returned [WorldRule] will have its `id` field set.
  Future<WorldRule?> upsertRow(
    _is.DatabaseSession session,
    WorldRule row, {
    required _is.ColumnSelections<WorldRuleTable> conflictColumns,
    _is.ColumnSelections<WorldRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<WorldRuleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WorldRule>(
      row,
      conflictColumns: conflictColumns(WorldRule.t),
      updateColumns: updateColumns?.call(WorldRule.t),
      updateWhere: updateWhere?.call(WorldRule.t),
      transaction: transaction,
    );
  }

  /// Updates all [WorldRule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorldRule>> update(
    _is.DatabaseSession session,
    List<WorldRule> rows, {
    _is.ColumnSelections<WorldRuleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WorldRule>(
      rows,
      columns: columns?.call(WorldRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WorldRule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorldRule> updateRow(
    _is.DatabaseSession session,
    WorldRule row, {
    _is.ColumnSelections<WorldRuleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorldRule>(
      row,
      columns: columns?.call(WorldRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorldRule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WorldRule?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WorldRuleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WorldRule>(
      id,
      columnValues: columnValues(WorldRule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WorldRule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorldRule>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WorldRuleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<WorldRuleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorldRuleTable>? orderBy,
    _is.OrderByListBuilder<WorldRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WorldRule>(
      columnValues: columnValues(WorldRule.t.updateTable),
      where: where(WorldRule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorldRule.t),
      orderByList: orderByList?.call(WorldRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WorldRule]s in the list and returns the deleted rows.
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
  Future<List<WorldRule>> delete(
    _is.DatabaseSession session,
    List<WorldRule> rows, {
    _is.OrderByBuilder<WorldRuleTable>? orderBy,
    _is.OrderByListBuilder<WorldRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WorldRule>(
      rows,
      orderBy: orderBy?.call(WorldRule.t),
      orderByList: orderByList?.call(WorldRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WorldRule].
  Future<WorldRule> deleteRow(
    _is.DatabaseSession session,
    WorldRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorldRule>(
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
  Future<List<WorldRule>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorldRuleTable> where,
    _is.OrderByBuilder<WorldRuleTable>? orderBy,
    _is.OrderByListBuilder<WorldRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WorldRule>(
      where: where(WorldRule.t),
      orderBy: orderBy?.call(WorldRule.t),
      orderByList: orderByList?.call(WorldRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorldRuleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WorldRule>(
      where: where?.call(WorldRule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WorldRule] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorldRuleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WorldRule>(
      where: where(WorldRule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

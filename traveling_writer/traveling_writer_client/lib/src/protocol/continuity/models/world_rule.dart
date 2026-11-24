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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class WorldRule
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? worldId;

  int? entityId;

  String subject;

  String relation;

  String constraint;

  String? explanation;

  String severity;

  bool isActive;

  /// Returns a shallow copy of this [WorldRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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

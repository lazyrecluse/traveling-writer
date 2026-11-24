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
import '../../continuity/models/continuity_violation.dart' as _iiss7pjd;

abstract class AuditResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AuditResult._({
    required this.storyText,
    required this.totalParagraphs,
    required this.violations,
    required this.isConsistent,
    required this.summary,
    required this.auditedAt,
    this.cached,
  });

  factory AuditResult({
    required String storyText,
    required int totalParagraphs,
    required List<_iiss7pjd.ContinuityViolation> violations,
    required bool isConsistent,
    required String summary,
    required DateTime auditedAt,
    bool? cached,
  }) = _AuditResultImpl;

  factory AuditResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditResult(
      storyText: jsonSerialization['storyText'] as String,
      totalParagraphs: jsonSerialization['totalParagraphs'] as int,
      violations: _ivgs3v8u.Protocol()
          .deserialize<List<_iiss7pjd.ContinuityViolation>>(
            jsonSerialization['violations'],
          ),
      isConsistent: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isConsistent'],
      ),
      summary: jsonSerialization['summary'] as String,
      auditedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['auditedAt'],
      ),
      cached: jsonSerialization['cached'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['cached']),
    );
  }

  String storyText;

  int totalParagraphs;

  List<_iiss7pjd.ContinuityViolation> violations;

  bool isConsistent;

  String summary;

  DateTime auditedAt;

  bool? cached;

  /// Returns a shallow copy of this [AuditResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuditResult copyWith({
    String? storyText,
    int? totalParagraphs,
    List<_iiss7pjd.ContinuityViolation>? violations,
    bool? isConsistent,
    String? summary,
    DateTime? auditedAt,
    bool? cached,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditResult',
      'storyText': storyText,
      'totalParagraphs': totalParagraphs,
      'violations': violations.toJson(valueToJson: (v) => v.toJson()),
      'isConsistent': isConsistent,
      'summary': summary,
      'auditedAt': auditedAt.toJson(),
      if (cached != null) 'cached': cached,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditResult',
      'storyText': storyText,
      'totalParagraphs': totalParagraphs,
      'violations': violations.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'isConsistent': isConsistent,
      'summary': summary,
      'auditedAt': auditedAt.toJson(),
      if (cached != null) 'cached': cached,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditResultImpl extends AuditResult {
  _AuditResultImpl({
    required String storyText,
    required int totalParagraphs,
    required List<_iiss7pjd.ContinuityViolation> violations,
    required bool isConsistent,
    required String summary,
    required DateTime auditedAt,
    bool? cached,
  }) : super._(
         storyText: storyText,
         totalParagraphs: totalParagraphs,
         violations: violations,
         isConsistent: isConsistent,
         summary: summary,
         auditedAt: auditedAt,
         cached: cached,
       );

  /// Returns a shallow copy of this [AuditResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuditResult copyWith({
    String? storyText,
    int? totalParagraphs,
    List<_iiss7pjd.ContinuityViolation>? violations,
    bool? isConsistent,
    String? summary,
    DateTime? auditedAt,
    Object? cached = _Undefined,
  }) {
    return AuditResult(
      storyText: storyText ?? this.storyText,
      totalParagraphs: totalParagraphs ?? this.totalParagraphs,
      violations:
          violations ?? this.violations.map((e0) => e0.copyWith()).toList(),
      isConsistent: isConsistent ?? this.isConsistent,
      summary: summary ?? this.summary,
      auditedAt: auditedAt ?? this.auditedAt,
      cached: cached is bool? ? cached : this.cached,
    );
  }
}

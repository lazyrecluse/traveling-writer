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

abstract class ContinuityViolation
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ContinuityViolation._({
    required this.paragraphIndex,
    required this.textSnippet,
    required this.entityName,
    required this.brokenRule,
    required this.explanation,
    required this.severity,
  });

  factory ContinuityViolation({
    required int paragraphIndex,
    required String textSnippet,
    required String entityName,
    required String brokenRule,
    required String explanation,
    required String severity,
  }) = _ContinuityViolationImpl;

  factory ContinuityViolation.fromJson(Map<String, dynamic> jsonSerialization) {
    return ContinuityViolation(
      paragraphIndex: jsonSerialization['paragraphIndex'] as int,
      textSnippet: jsonSerialization['textSnippet'] as String,
      entityName: jsonSerialization['entityName'] as String,
      brokenRule: jsonSerialization['brokenRule'] as String,
      explanation: jsonSerialization['explanation'] as String,
      severity: jsonSerialization['severity'] as String,
    );
  }

  int paragraphIndex;

  String textSnippet;

  String entityName;

  String brokenRule;

  String explanation;

  String severity;

  /// Returns a shallow copy of this [ContinuityViolation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ContinuityViolation copyWith({
    int? paragraphIndex,
    String? textSnippet,
    String? entityName,
    String? brokenRule,
    String? explanation,
    String? severity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ContinuityViolation',
      'paragraphIndex': paragraphIndex,
      'textSnippet': textSnippet,
      'entityName': entityName,
      'brokenRule': brokenRule,
      'explanation': explanation,
      'severity': severity,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ContinuityViolation',
      'paragraphIndex': paragraphIndex,
      'textSnippet': textSnippet,
      'entityName': entityName,
      'brokenRule': brokenRule,
      'explanation': explanation,
      'severity': severity,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ContinuityViolationImpl extends ContinuityViolation {
  _ContinuityViolationImpl({
    required int paragraphIndex,
    required String textSnippet,
    required String entityName,
    required String brokenRule,
    required String explanation,
    required String severity,
  }) : super._(
         paragraphIndex: paragraphIndex,
         textSnippet: textSnippet,
         entityName: entityName,
         brokenRule: brokenRule,
         explanation: explanation,
         severity: severity,
       );

  /// Returns a shallow copy of this [ContinuityViolation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ContinuityViolation copyWith({
    int? paragraphIndex,
    String? textSnippet,
    String? entityName,
    String? brokenRule,
    String? explanation,
    String? severity,
  }) {
    return ContinuityViolation(
      paragraphIndex: paragraphIndex ?? this.paragraphIndex,
      textSnippet: textSnippet ?? this.textSnippet,
      entityName: entityName ?? this.entityName,
      brokenRule: brokenRule ?? this.brokenRule,
      explanation: explanation ?? this.explanation,
      severity: severity ?? this.severity,
    );
  }
}

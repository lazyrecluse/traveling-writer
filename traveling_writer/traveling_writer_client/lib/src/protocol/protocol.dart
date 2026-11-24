/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:traveling_writer_client/src/protocol/continuity/models/plot_node.dart'
    as _i4y9zu9x;
import 'package:traveling_writer_client/src/protocol/continuity/models/world.dart'
    as _i8356hej;
import 'package:traveling_writer_client/src/protocol/continuity/models/world_entity.dart'
    as _ia9nmxb6;
import 'package:traveling_writer_client/src/protocol/continuity/models/world_rule.dart'
    as _ivoto9at;
import 'continuity/models/audit_result.dart' as _id6f7u5i;
import 'continuity/models/continuity_violation.dart' as _i0mmdncd;
import 'continuity/models/plot_node.dart' as _iec2mgjv;
import 'continuity/models/world.dart' as _i8oebejy;
import 'continuity/models/world_entity.dart' as _itygi21c;
import 'continuity/models/world_rule.dart' as _i5tt6je2;
import 'greetings/greeting.dart' as _izw8z7ou;
export 'continuity/models/audit_result.dart';
export 'continuity/models/continuity_violation.dart';
export 'continuity/models/plot_node.dart';
export 'continuity/models/world.dart';
export 'continuity/models/world_entity.dart';
export 'continuity/models/world_rule.dart';
export 'greetings/greeting.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _id6f7u5i.AuditResult) {
      return _id6f7u5i.AuditResult.fromJson(data) as T;
    }
    if (t == _i0mmdncd.ContinuityViolation) {
      return _i0mmdncd.ContinuityViolation.fromJson(data) as T;
    }
    if (t == _iec2mgjv.PlotNode) {
      return _iec2mgjv.PlotNode.fromJson(data) as T;
    }
    if (t == _i8oebejy.World) {
      return _i8oebejy.World.fromJson(data) as T;
    }
    if (t == _itygi21c.WorldEntity) {
      return _itygi21c.WorldEntity.fromJson(data) as T;
    }
    if (t == _i5tt6je2.WorldRule) {
      return _i5tt6je2.WorldRule.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _isc.getType<_id6f7u5i.AuditResult?>()) {
      return (data != null ? _id6f7u5i.AuditResult.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0mmdncd.ContinuityViolation?>()) {
      return (data != null
              ? _i0mmdncd.ContinuityViolation.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iec2mgjv.PlotNode?>()) {
      return (data != null ? _iec2mgjv.PlotNode.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8oebejy.World?>()) {
      return (data != null ? _i8oebejy.World.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itygi21c.WorldEntity?>()) {
      return (data != null ? _itygi21c.WorldEntity.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5tt6je2.WorldRule?>()) {
      return (data != null ? _i5tt6je2.WorldRule.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == List<_i0mmdncd.ContinuityViolation>) {
      return (data as List)
              .map((e) => deserialize<_i0mmdncd.ContinuityViolation>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _isc.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i8356hej.World>) {
      return (data as List).map((e) => deserialize<_i8356hej.World>(e)).toList()
          as T;
    }
    if (t == List<_ia9nmxb6.WorldEntity>) {
      return (data as List)
              .map((e) => deserialize<_ia9nmxb6.WorldEntity>(e))
              .toList()
          as T;
    }
    if (t == List<_ivoto9at.WorldRule>) {
      return (data as List)
              .map((e) => deserialize<_ivoto9at.WorldRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i4y9zu9x.PlotNode>) {
      return (data as List)
              .map((e) => deserialize<_i4y9zu9x.PlotNode>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _id6f7u5i.AuditResult => 'AuditResult',
      _i0mmdncd.ContinuityViolation => 'ContinuityViolation',
      _iec2mgjv.PlotNode => 'PlotNode',
      _i8oebejy.World => 'World',
      _itygi21c.WorldEntity => 'WorldEntity',
      _i5tt6je2.WorldRule => 'WorldRule',
      _izw8z7ou.Greeting => 'Greeting',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'traveling_writer.',
        '',
      );
    }

    switch (data) {
      case _id6f7u5i.AuditResult():
        return 'AuditResult';
      case _i0mmdncd.ContinuityViolation():
        return 'ContinuityViolation';
      case _iec2mgjv.PlotNode():
        return 'PlotNode';
      case _i8oebejy.World():
        return 'World';
      case _itygi21c.WorldEntity():
        return 'WorldEntity';
      case _i5tt6je2.WorldRule():
        return 'WorldRule';
      case _izw8z7ou.Greeting():
        return 'Greeting';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuditResult') {
      return deserialize<_id6f7u5i.AuditResult>(data['data']);
    }
    if (dataClassName == 'ContinuityViolation') {
      return deserialize<_i0mmdncd.ContinuityViolation>(data['data']);
    }
    if (dataClassName == 'PlotNode') {
      return deserialize<_iec2mgjv.PlotNode>(data['data']);
    }
    if (dataClassName == 'World') {
      return deserialize<_i8oebejy.World>(data['data']);
    }
    if (dataClassName == 'WorldEntity') {
      return deserialize<_itygi21c.WorldEntity>(data['data']);
    }
    if (dataClassName == 'WorldRule') {
      return deserialize<_i5tt6je2.WorldRule>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('traveling_writer', this);
    _iacc.Protocol().registerHostProtocol('traveling_writer', this);
  }

  @override
  String getModuleName() => 'traveling_writer';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

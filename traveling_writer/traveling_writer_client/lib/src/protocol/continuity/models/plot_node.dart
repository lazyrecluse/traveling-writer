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
import 'package:traveling_writer_client/src/protocol/protocol.dart'
    as _ixza497f;

abstract class PlotNode
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _ixza497f.Protocol().deserialize<List<int>>(
              jsonSerialization['connectedNodeIds'],
            ),
      entityIds: jsonSerialization['entityIds'] == null
          ? null
          : _ixza497f.Protocol().deserialize<List<int>>(
              jsonSerialization['entityIds'],
            ),
      status: jsonSerialization['status'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  /// Returns a shallow copy of this [PlotNode]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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

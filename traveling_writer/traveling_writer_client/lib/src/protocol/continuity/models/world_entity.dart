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

abstract class WorldEntity
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _ixza497f.Protocol().deserialize<List<String>>(
              jsonSerialization['traits'],
            ),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? worldId;

  String name;

  String category;

  String description;

  List<String>? traits;

  bool isActive;

  /// Returns a shallow copy of this [WorldEntity]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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

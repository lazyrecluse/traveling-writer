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

abstract class World
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? genre;

  String? description;

  String? ownerId;

  DateTime createdAt;

  /// Returns a shallow copy of this [World]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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

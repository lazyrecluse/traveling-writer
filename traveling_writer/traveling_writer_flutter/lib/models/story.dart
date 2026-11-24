import 'package:uuid/uuid.dart';
import 'chapter.dart';

const _uuid = Uuid();

class UserAccount {
  final String id;
  final String username;
  final String password;
  final String penName;
  final String email;
  final DateTime createdAt;

  UserAccount({
    String? id,
    required this.username,
    required this.password,
    required this.penName,
    required this.email,
    DateTime? createdAt,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'penName': penName,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        id: json['id'] as String? ?? _uuid.v4(),
        username: json['username'] as String? ?? '',
        password: json['password'] as String? ?? '',
        penName: json['penName'] as String? ?? 'Author',
        email: json['email'] as String? ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
            : DateTime.now(),
      );

  UserSession toSession() => UserSession(
        id: id,
        penName: penName,
        email: email,
        username: username,
        createdAt: createdAt,
        isGuest: false,
      );
}

class UserSession {
  final String id;
  final String penName;
  final String email;
  final String username;
  final DateTime createdAt;
  final bool isGuest;

  UserSession({
    String? id,
    required this.penName,
    required this.email,
    this.username = '',
    DateTime? createdAt,
    this.isGuest = false,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  String get storageKey {
    if (isGuest) return 'guest_$id';
    if (username.isNotEmpty) return username.toLowerCase();
    return penName.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'penName': penName,
        'email': email,
        'username': username,
        'createdAt': createdAt.toIso8601String(),
        'isGuest': isGuest,
      };

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
        id: json['id'] as String? ?? _uuid.v4(),
        penName: json['penName'] as String? ?? 'Guest Writer',
        email: json['email'] as String? ?? '',
        username: json['username'] as String? ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
            : DateTime.now(),
        isGuest: json['isGuest'] as bool? ?? false,
      );
}

class Story {
  final String id;
  int? worldId;
  String title;
  String synopsis;
  String genre;
  List<Chapter> chapters;
  DateTime createdAt;

  Story({
    String? id,
    this.worldId = 1,
    required this.title,
    required this.synopsis,
    this.genre = 'Fantasy',
    List<Chapter>? chapters,
    DateTime? createdAt,
  })  : id = id ?? _uuid.v4(),
        chapters = chapters ?? [],
        createdAt = createdAt ?? DateTime.now();

  int get totalWords => chapters.fold(0, (sum, c) => sum + c.wordCount);

  int get conflictCount => chapters.where((c) => c.isConflicting).length;

  bool get hasConflict => conflictCount > 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'worldId': worldId,
        'title': title,
        'synopsis': synopsis,
        'genre': genre,
        'chapters': chapters.map((c) => c.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json['id'] as String? ?? _uuid.v4(),
        worldId: json['worldId'] as int? ?? 1,
        title: json['title'] as String? ?? 'Untitled Story',
        synopsis: json['synopsis'] as String? ?? '',
        genre: json['genre'] as String? ?? 'Fantasy',
        chapters: (json['chapters'] as List<dynamic>?)
                ?.map((c) =>
                    Chapter.fromJson(Map<String, dynamic>.from(c as Map)))
                .toList() ??
            [],
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
}

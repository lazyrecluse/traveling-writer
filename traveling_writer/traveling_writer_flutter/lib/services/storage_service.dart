import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story.dart';

class StorageService {
  static const String _accountsKey = 'tw_user_accounts';
  static const String _sessionKey = 'tw_active_session';
  static const String _storiesPrefix = 'tw_stories_';
  static const String _dismissedLorePrefix = 'tw_dismissed_lore_';
  static const String _activeWorldPrefix = 'tw_active_world_';

  /// Load all registered accounts
  static Future<List<UserAccount>> loadAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_accountsKey);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) =>
              UserAccount.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Register or update an account
  static Future<void> saveAccount(UserAccount account) async {
    try {
      final accounts = await loadAccounts();
      final index = accounts.indexWhere(
        (a) => a.username.toLowerCase() == account.username.toLowerCase(),
      );
      if (index >= 0) {
        accounts[index] = account;
      } else {
        accounts.add(account);
      }
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(accounts.map((a) => a.toJson()).toList());
      await prefs.setString(_accountsKey, raw);
    } catch (_) {}
  }

  /// Authenticate a user by username/email and password
  static Future<UserAccount?> authenticate(
      String login, String password) async {
    final accounts = await loadAccounts();
    final cleanLogin = login.trim().toLowerCase();
    for (final acc in accounts) {
      if ((acc.username.toLowerCase() == cleanLogin ||
              acc.email.toLowerCase() == cleanLogin) &&
          acc.password == password) {
        return acc;
      }
    }
    return null;
  }

  /// Load currently active session
  static Future<UserSession?> getActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_sessionKey);
      if (raw == null || raw.isEmpty) return null;
      return UserSession.fromJson(
          Map<String, dynamic>.from(jsonDecode(raw) as Map));
    } catch (_) {
      return null;
    }
  }

  /// Save active session
  static Future<void> setActiveSession(UserSession? session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (session == null) {
        await prefs.remove(_sessionKey);
      } else {
        await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
      }
    } catch (_) {}
  }

  /// Load currently active World ID for user
  static Future<int?> getActiveWorldId(String storageKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('$_activeWorldPrefix$storageKey');
    } catch (_) {
      return null;
    }
  }

  /// Save active World ID for user
  static Future<void> setActiveWorldId(String storageKey, int worldId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$_activeWorldPrefix$storageKey', worldId);
    } catch (_) {}
  }

  /// Load stories for a given user storage key, scoped to a specific world universe
  static Future<List<Story>?> loadStories(String storageKey,
      {int? worldId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = worldId != null
          ? '$_storiesPrefix${storageKey}_w$worldId'
          : '$_storiesPrefix$storageKey';

      var raw = prefs.getString(key);
      // Fallback for legacy stories stored before worldId partition
      if ((raw == null || raw.isEmpty) && worldId == 1) {
        raw = prefs.getString('$_storiesPrefix$storageKey');
      }

      if (raw == null || raw.isEmpty) return null;
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => Story.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Save stories for a given user storage key, scoped to a specific world universe
  static Future<void> saveStories(String storageKey, List<Story> stories,
      {int? worldId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = worldId != null
          ? '$_storiesPrefix${storageKey}_w$worldId'
          : '$_storiesPrefix$storageKey';

      final raw = jsonEncode(stories.map((s) => s.toJson()).toList());
      await prefs.setString(key, raw);
    } catch (_) {}
  }

  /// Load dismissed / permanently deleted lore signatures for user in a world
  static Future<Set<String>> loadDismissedLore(String storageKey,
      {int? worldId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = worldId != null
          ? '$_dismissedLorePrefix${storageKey}_w$worldId'
          : '$_dismissedLorePrefix$storageKey';

      final list = prefs.getStringList(key);
      if (list == null) return {};
      return list.toSet();
    } catch (_) {
      return {};
    }
  }

  /// Record a dismissed / permanently deleted lore signature in a world
  static Future<void> addDismissedLore(String storageKey, String signature,
      {int? worldId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = worldId != null
          ? '$_dismissedLorePrefix${storageKey}_w$worldId'
          : '$_dismissedLorePrefix$storageKey';

      final set = (prefs.getStringList(key) ?? []).toSet();
      set.add(signature);
      await prefs.setStringList(key, set.toList());
    } catch (_) {}
  }
}

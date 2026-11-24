import 'dart:async';

enum ContinuityEventType {
  loreCreated,
  loreUpdated,
  loreDeleted,
  chapterAudited,
  worldSwitched,
  storyUpdated,
}

class ContinuityEvent {
  final ContinuityEventType type;
  final int? worldId;
  final String? chapterId;
  final String? message;
  final dynamic payload;
  final DateTime timestamp;

  ContinuityEvent({
    required this.type,
    this.worldId,
    this.chapterId,
    this.message,
    this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ContinuityEventBus {
  static final ContinuityEventBus _instance = ContinuityEventBus._internal();
  factory ContinuityEventBus() => _instance;
  ContinuityEventBus._internal();

  final _streamController = StreamController<ContinuityEvent>.broadcast();

  Stream<ContinuityEvent> get stream => _streamController.stream;

  Stream<ContinuityEvent> on(ContinuityEventType type) =>
      _streamController.stream.where((event) => event.type == type);

  void emit(ContinuityEvent event) {
    if (!_streamController.isClosed) {
      _streamController.add(event);
    }
  }

  void emitLoreChange({
    required ContinuityEventType type,
    int? worldId,
    String? message,
    dynamic payload,
  }) {
    emit(ContinuityEvent(
      type: type,
      worldId: worldId,
      message: message,
      payload: payload,
    ));
  }

  void emitChapterAudited({
    int? worldId,
    String? chapterId,
    dynamic payload,
  }) {
    emit(ContinuityEvent(
      type: ContinuityEventType.chapterAudited,
      worldId: worldId,
      chapterId: chapterId,
      payload: payload,
    ));
  }

  void emitWorldSwitched(int? worldId, {String? worldName}) {
    emit(ContinuityEvent(
      type: ContinuityEventType.worldSwitched,
      worldId: worldId,
      message: worldName,
    ));
  }
}

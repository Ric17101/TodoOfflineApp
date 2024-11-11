import 'dart:typed_data';

/// Interface for storage engines
abstract class StorageEngine {
  const StorageEngine(this.key);

  final String key;

  /// Save state ([data] could be null)
  Future<void>? save(Uint8List data) => null;

  /// Load state (can return null)
  Future<Uint8List?>? load() => null;

  /// Delete state
  Future<void>? delete() => null;
}

/// Storage engine to save to memory.
/// Do not use in production, this doesn't persist to disk.
class MemoryStorage extends StorageEngine {
  MemoryStorage({String key = 'memory', Uint8List? memory})
      : _memory = memory,
        super(key);

  /// Internal memory.
  Uint8List? _memory;

  @override
  Future<Uint8List?> load() async => _memory;

  @override
  Future<void> save(Uint8List data) async => _memory = data;

  @override
  Future<void> delete() async => _memory = null;
}

/// Saving/loading failed.
class StorageException implements Exception {
  const StorageException(this.msg);

  final String msg;

  @override
  String toString() => 'StorageException: $msg';
}

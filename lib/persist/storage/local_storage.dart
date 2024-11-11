import 'dart:typed_data';

abstract class LocalStorage {
  const LocalStorage(this.key);

  final String key;

  Future<void>? save(Uint8List data) => null;

  Future<Uint8List?>? load() => null;

  Future<void>? delete() => null;
}

import 'dart:typed_data';

import 'package:todo_offline_app/persist/storage_engine.dart';

class StandardEngine extends StorageEngine {
  StandardEngine({String key = 'web'}) : super(key);

  @override
  Future<Uint8List?>? load() => super.load();

  @override
  Future<void>? save(Uint8List data) => super.save(data);

  @override
  Future<void>? delete() => super.delete();
}

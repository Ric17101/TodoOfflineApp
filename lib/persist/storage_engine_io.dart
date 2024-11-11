import 'dart:io';
import 'dart:typed_data';

import 'package:expense_tracker_app/persist/storage_engine.dart';
import 'package:path_provider/path_provider.dart';

/// Storage engine to save to application document directory.
class StandardEngineIO extends StorageEngine {
  StandardEngineIO({String key = 'app'}) : super(key);

  @override
  Future<Uint8List?> load() async {
    final file = await _getFile();
    if (file.existsSync()) {
      return Uint8List.fromList(await file.readAsBytes());
    }
    return null;
  }

  @override
  Future<void> save(Uint8List data) async {
    final file = await _getFile();
    await file.writeAsBytes(data);
  }

  @override
  Future<void> delete() async {
    final file = await _getFile();
    if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/persist_$key.json');
  }
}

/// Storage engine to save to file.
class FileStorage extends StorageEngine {
  FileStorage(this.file, {String key = 'file'}) : super(key);

  /// File to save to.
  final File file;

  @override
  Future<Uint8List?> load() async {
    if (file.existsSync()) {
      return Uint8List.fromList(await file.readAsBytes());
    }
    return null;
  }

  @override
  Future<void> save(Uint8List data) async {
    if (file.existsSync()) {
      await file.writeAsBytes(data);
    }
  }

  @override
  Future<void> delete() async {
    if (file.existsSync()) {
      await file.delete();
    }
  }
}

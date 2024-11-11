import 'dart:io';
import 'dart:typed_data';

import 'package:expense_tracker_app/persist/storage/local_storage.dart';
import 'package:path_provider/path_provider.dart';

class AppLocalStorage extends LocalStorage {
  AppLocalStorage({String key = 'app_storage'}) : super(key);

  @override
  Future<void>? save(Uint8List data) async {
    final file = await _getFile();
    await file.writeAsBytes(data);
  }

  @override
  Future<Uint8List?>? load() async {
    final file = await _getFile();
    if (file.existsSync()) {
      return Uint8List.fromList(await file.readAsBytes());
    }
    return null;
  }

  @override
  Future<void>? delete() async {
    final file = await _getFile();
    if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/persisted_state_$key.json');
  }
}

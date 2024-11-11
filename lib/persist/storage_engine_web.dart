import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

import 'package:todo_offline_app/persist/persistor.dart';
import 'package:todo_offline_app/persist/storage_engine.dart';

class StandardEngineWeb extends StorageEngine {
  StandardEngineWeb({String key = 'web'}) : super(key);

  @override
  Future<Uint8List?> load() async => html.window.localStorage.containsKey(key)
      ? stringToUint8List(html.window.localStorage[key]!)
      : null;

  @override
  Future<void> save(Uint8List data) async =>
      html.window.localStorage[key] = uint8ListToString(data);

  @override
  Future<void> delete() async => html.window.localStorage.remove(key);
}

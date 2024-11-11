import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:todo_offline_app/todo_app.dart';
import 'package:todo_offline_app/persist/persistor.dart';
import 'package:todo_offline_app/persist/storage_engine_io.dart';
import 'package:todo_offline_app/persist/storage_engine_web.dart';
import 'package:todo_offline_app/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final persistor = _getSupportedPersistor();

    AppState? state;
    try {
      state = await persistor.readState();
    } on Exception catch (_) {}

    if (state == null) {
      // for newly installed app or there's something wrong with data thus persistor.readState() returns null state
      state = AppState.init();
      await persistor.saveInitialState(state);
    }

    final store = Store<AppState>(
      initialState: state,
      actionObservers: [Log.printer(formatter: Log.verySimpleFormatter)],
      persistor: persistor,
    );

    // store.dispatch(SubscribeToConnectivityAction());
    runApp(MyApp(store: store));
  }, (error, stackTrace) async {
    /// TODO: Log error here
    debugPrintStack(stackTrace: stackTrace, label: error.toString());
  });
}

StatePersistor<AppState> _getSupportedPersistor() {
  final storageEngine = kIsWeb ? StandardEngineWeb() : StandardEngineIO();

  return StatePersistor<AppState>(
    storageEngine,
    AppStateSerializer(),
  );
}

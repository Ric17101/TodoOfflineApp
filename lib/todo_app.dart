import 'package:async_redux/async_redux.dart';
import 'package:todo_offline_app/page/todo_page/todo_page_connector.dart';
import 'package:todo_offline_app/state/app_state.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    required this.store,
    super.key,
  });

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) => StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
          ),
          home: TodoPageConnector(),
        ),
      );
}

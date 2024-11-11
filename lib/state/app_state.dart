import 'package:async_redux/async_redux.dart';
import 'package:todo_offline_app/persist/persistor.dart';
import 'package:todo_offline_app/api/models/todo_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

part 'app_state.g.dart';

@freezed
class AppState with _$AppState {
  factory AppState({
    @Default(Wait.empty) @JsonKey(name: 'wait', includeFromJson: false) Wait wait,
    @Default("") String test,
    @Default(<TodoItem>[]) List<TodoItem> todoList,
  }) = _AppState;

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  factory AppState.init() => AppState(
        test: "String",
        todoList: [
          TodoItem(id: 1, title: 'Code With Flutter', checked: true),
          TodoItem(id: 2, title: 'Learn Flutter', checked: true),
          TodoItem(id: 3, title: 'Drink Coffee', checked: false),
          TodoItem(id: 4, title: 'Explore Firebase', checked: false),
        ],
      );
}

class AppStateSerializer extends StateSerializer<AppState> {
  @override
  AppState decode(Map<String, dynamic>? data) =>
      AppState.fromJson(data ?? <String, dynamic>{});

  @override
  Map<String, dynamic> encode(AppState state) => state.toJson();
}

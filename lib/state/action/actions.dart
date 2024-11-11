import 'package:async_redux/async_redux.dart';
import 'package:expense_tracker_app/api/models/todo_item.dart';
import 'package:expense_tracker_app/state/app_state.dart';
import 'package:flutter/foundation.dart';

/// Reusable loading page state for request action
abstract class LoadingAction extends ReduxAction<AppState> {
  LoadingAction({required this.actionKey});

  final String actionKey;

  @override
  Future<void> before() async => await dispatchAsync(WaitAction.add(actionKey));

  @override
  void after() => dispatch(WaitAction.remove(actionKey));
}

/// Get Data request action
class GetDataAction extends LoadingAction {
  GetDataAction() : super(actionKey: key);

  static const key = 'get-data-action';

  @override
  Future<AppState> reduce() async {
    // final data = await getIt<ApiService>().todosApi.todoApi.getData();
    final todoList = store.state.todoList;

    return state.copyWith(todoList: todoList);
  }
}

class CreateTodoAction extends LoadingAction {
  CreateTodoAction(this.title) : super(actionKey: key);

  final String? title;

  static const key = 'create-todo-action';

  @override
  Future<AppState> reduce() async {
    final newItem = TodoItem(
      id: UniqueKey().hashCode,
      title: title,
      checked: false,
    );

    final todoList = [...state.todoList, newItem];

    return state.copyWith(todoList: todoList);
  }
}

class UpdateTodoByIdAction extends LoadingAction {
  UpdateTodoByIdAction(this.id) : super(actionKey: key);

  final int? id;

  static const key = 'update-todo-by-id-action';

  @override
  Future<AppState> reduce() async {
    final todoList = state.todoList
        .map((todo) => todo.id == id
            ? todo.copyWith(checked: todo.checked == false)
            : todo)
        .toList();

    return state.copyWith(todoList: todoList);
  }
}

class RemoveTodoByIdAction extends LoadingAction {
  RemoveTodoByIdAction(this.id) : super(actionKey: key);

  final int? id;

  static const key = 'remove-todo-by-id-action';

  @override
  Future<AppState> reduce() async {
    final todoList = state.todoList.toSet()
      ..removeWhere((todo) => todo.id == id);

    return state.copyWith(todoList: todoList.toList());
  }
}

/// Get more todos paginated request action
// class LoadMoreDataAction extends LoadingAction {
//   LoadMoreDataAction() : super(actionKey: key);
//
//   static const key = 'load-more-data-action';
//
//   @override
//   Future<AppState> reduce() async {
//     final data = await getIt<ApiService>().todosApi.todoApi.getData(paginationSkip: (state.data.skip ?? 0) + 10);
//     final updatedData = data.copyWith(todos: [...state.data.todos, ...data.todos]);
//
//     return state.copyWith(data: updatedData);
//   }
// }

/// Get todo details by id request action
// class GetTodoDetailsByIdAction extends LoadingAction {
//   GetTodoDetailsByIdAction(this.id) : super(actionKey: key);
//
//   final int id;
//
//   static const key = 'get-todo-details-by-id-action';
//
//   @override
//   Future<AppState> reduce() async {
//     final todo = await getIt<ApiService>().todosApi.todoApi.getById(id);
//
//     return state.copyWith(selectedTodo: todo);
//   }
// }

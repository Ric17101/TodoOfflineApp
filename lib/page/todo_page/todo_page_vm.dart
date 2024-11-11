import 'package:async_redux/async_redux.dart';
import 'package:expense_tracker_app/page/todo_page/todo_page.dart';
import 'package:expense_tracker_app/state/action/actions.dart';
import 'package:expense_tracker_app/state/app_state.dart';
import 'package:expense_tracker_app/state/async_result.dart';
import 'package:expense_tracker_app/state/todo/todo_item_ui.dart';

class TodoPageVmFactory extends VmFactory<AppState, TodoPage, TodoPageVm> {
  @override
  TodoPageVm fromStore() => TodoPageVm(
        todoItemUiList: _todoItemUiList,
        addTodoItemCallback: _addTodoItemCallback,
        toggleTodoItemCallback: _toggleTodoItemCallback,
        deleteTodoItemCallback: _deleteTodoItemCallback,
        // loadMoreCallback: _loadMoreCallback,
      );

  AsyncResult<List<TodoItemUi>> get _todoItemUiList {
    final todoList = state.todoList
        .map((todo) => TodoItemUi(
              id: todo.id,
              title: todo.title ?? '',
              checked: todo.checked ?? false,
            ))
        .toList();

    if (isPageLoading(_pageKeys)) return AsyncResult.loading(todoList);

    return AsyncResult.success(todoList);
  }

  // void _loadMoreCallback() => dispatch(LoadMoreDataAction());
  void _addTodoItemCallback(String? title) => dispatch(CreateTodoAction(title));

  void _toggleTodoItemCallback(int? id) => dispatch(UpdateTodoByIdAction(id));

  void _deleteTodoItemCallback(int? id) => dispatch(RemoveTodoByIdAction(id));

  bool isPageLoading(List<String> keys) => _isWaitingForKeys(keys);

  bool _isWaitingForKeys(List<String> keys) =>
      keys.any((k) => state.wait.isWaiting(k));

  static const _pageKeys = <String>[
    GetDataAction.key,
    CreateTodoAction.key,
    UpdateTodoByIdAction.key,
    RemoveTodoByIdAction.key,
    // LoadMoreDataAction.key,
  ];
}

class TodoPageVm extends Vm {
  TodoPageVm({
    required this.todoItemUiList,
    required this.addTodoItemCallback,
    required this.toggleTodoItemCallback,
    required this.deleteTodoItemCallback,
    // required this.loadMoreCallback,
  }) : super(equals: [todoItemUiList]);

  final AsyncResult<List<TodoItemUi>> todoItemUiList;
  final Function(String?) addTodoItemCallback;
  final Function(int?) toggleTodoItemCallback;
  final Function(int?) deleteTodoItemCallback;
// final VoidCallback loadMoreCallback;
}

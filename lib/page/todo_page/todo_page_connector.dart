import 'package:async_redux/async_redux.dart';
import 'package:expense_tracker_app/page/todo_page/todo_page.dart';
import 'package:expense_tracker_app/page/todo_page/todo_page_vm.dart';
import 'package:expense_tracker_app/state/action/actions.dart';
import 'package:expense_tracker_app/state/app_state.dart';
import 'package:flutter/material.dart';

class TodoPageConnector extends StatelessWidget {
  const TodoPageConnector({super.key});

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, TodoPageVm>(
        vm: () => TodoPageVmFactory(),
        // TODO: can be used when no need to access state
        // E.g. run the dispatch action
        // converter: (store) => TodoPageVm(
        //   loadMoreCallback: () {},
        //   todoItemUiList: const AsyncResult.success([]),
        // ),
        onInitialBuild: (_, store, __) => store.dispatch(GetDataAction()),
        builder: (context, vm) => TodoPage(
          todoItemUiList: vm.todoItemUiList,
          addTodoItemCallback: vm.addTodoItemCallback,
          toggleTodoItemCallback: vm.toggleTodoItemCallback,
          deleteTodoItemCallback: vm.deleteTodoItemCallback,
          // loadMoreCallback: vm.loadMoreCallback,
        ),
      );
}

import 'package:todo_offline_app/page/widget/todo_item_widget.dart';
import 'package:todo_offline_app/state/async_result.dart';
import 'package:todo_offline_app/state/todo/todo_item_ui.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({
    required this.todoItemUiList,
    required this.addTodoItemCallback,
    required this.toggleTodoItemCallback,
    required this.deleteTodoItemCallback,
    super.key,
  });

  final AsyncResult<List<TodoItemUi>> todoItemUiList;
  final Function(String?) addTodoItemCallback;
  final Function(int?) toggleTodoItemCallback;
  final Function(int?) deleteTodoItemCallback;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();

  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      widget.addTodoItemCallback(_controller.text);
      return _controller.clear();
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('No title input.'),
    ));
  }

  bool get loading => widget.todoItemUiList
      .maybeWhen(loading: (_) => true, orElse: () => false);

  @override
  Widget build(BuildContext context) {
    final items = widget.todoItemUiList.maybeWhen(
      success: (todoItems) =>
          todoItems
              ?.map((item) => TodoItemWidget(
                    taskName: item.title ?? "",
                    taskCompleted: item.checked ?? false,
                    onChanged: () => widget.toggleTodoItemCallback(item.id),
                    deleteFunction: (context) =>
                        widget.deleteTodoItemCallback(item.id),
                  ))
              .toList() ??
          List.empty(),
      loading: (items) => List.empty(),
      orElse: () => List.empty(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Todo'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => ListView(
          children: [
            ...items,
            if (loading) ...[
              Positioned(
                left: 0,
                bottom: 0,
                child: SizedBox(
                  width: constraint.maxWidth,
                  height: 80.0,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Add a new todo items',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.blueAccent.shade200,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: saveNewTask,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

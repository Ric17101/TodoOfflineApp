import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_item_ui.freezed.dart';

part 'todo_item_ui.g.dart';

/// Types of defects
@freezed
class TodoItemUi with _$TodoItemUi {
  /// Initializes a new instance of the [TodoItemUi] class
  factory TodoItemUi({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'checked') bool? checked,
  }) = _TodoItemUi;

  factory TodoItemUi.fromJson(Map<String, dynamic> json) =>
      _$TodoItemUiFromJson(json);
}

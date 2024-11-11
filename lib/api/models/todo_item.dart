import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_item.freezed.dart';

part 'todo_item.g.dart';

/// Types of defects
@freezed
class TodoItem with _$TodoItem {
  /// Initializes a new instance of the [TodoItem] class
  factory TodoItem({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'checked') bool? checked,
  }) = _TodoItem;

  factory TodoItem.fromJson(Map<String, dynamic> json) =>
      _$TodoItemFromJson(json);
}

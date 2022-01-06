import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    String? title,
    String? desc,
    @Default('1') String duration,
  }) = _Default;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quicktodo/db/hive_adapter/todo_type_define.dart';
//import 'package:quicktodo/models/todo.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default(false) bool isGrid,
    @Default('1') String duration,
    @Default([]) List<Todo> list,
  }) = _Default;
}

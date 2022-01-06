import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quicktodo/db/db.dart';
import 'package:quicktodo/db/hive_adapter/todo_type_define.dart';
import 'package:quicktodo/providers/providers.dart';

import 'home_state.dart';

class HomeStateNotifier extends StateNotifier<HomeState> {
  final Ref ref;
  HomeStateNotifier(this.ref) : super(const HomeState());

  DB get db {
    return ref.read(dbProvider);
  }

  void loadTodos() {
    state = state.copyWith.call(isLoading: true);
    //Future.delayed(const Duration(seconds: 1));
    final newlist = db.getAllTodos();
    state = state.copyWith.call(list: [...newlist]);
    state = state.copyWith.call(isLoading: false);
  }

  void addTodo(String? title, String? description, double duration) async {
    final todo = Todo(
      title: title ?? '',
      desc: description ?? '',
      duration: duration,
    );
    state = state.copyWith.call(isLoading: true);
    await db.addTodo(todo);
    loadTodos();
    state = state.copyWith.call(isLoading: false);
    // state = state.copyWith.call(list: [...state.list, todo]);
  }

  void deleteTodos(int index) async {
    state = state.copyWith.call(isLoading: true);
    await db.deleteTodo(index);
    loadTodos();
    state = state.copyWith.call(isLoading: false);
  }

  void view(bool Grid) {
    state = state.copyWith.call(isGrid: Grid);
  }

  void handleTimer(bool isPaused, int index) {
    late Timer _timer;
    var duration = state.list[index].duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration <= 0 || isPaused == true) {
        timer.cancel();
        if (duration <= 0) {
          db.editTodo(index, isPaused, status: 'DONE', duration: 0);
        }
        if (isPaused == true) {
          db.editTodo(index, isPaused, status: 'ON-GOING');
        }
        loadTodos();
      } else {
        //Future.delayed(Duration(milliseconds: 500));
        db.editTodo(index, isPaused, duration: duration, status: 'ON-GOING');
        loadTodos();
        duration--;
      }
    });
  }

  void todoEdit(int index, bool isOpen, bool isPaused) async {
    await db.editTodo(index, isPaused, isOpen: isOpen);
    loadTodos();
  }
}

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'hive_adapter/todo_type_define.dart';

class DB {
  static late final Box<Todo> todoBox;
  static late final Box todoLogin;
  Future<void> initDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    const secureStorage = FlutterSecureStorage();
    var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: 'key', value: base64UrlEncode(key));
    }

    var encryptionKey =
        base64Url.decode((await secureStorage.read(key: 'key'))!);
    todoBox = await Hive.openBox(
      'todo',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    todoLogin = await Hive.openBox(
      'Login',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  void closeDatabase() async {
    await todoBox.compact();
    await todoBox.close();
  }

  void clearDatabase() async {
    await todoBox.clear();
  }

  Future<void> storeUserCredentials(String? phoneNumber, String? passwd) async {
    await todoLogin.putAll({'phNoLogin': phoneNumber, 'passwd': passwd});
  }

  Future<bool> isLogin() async {
    final output = todoLogin.get('phNoLogin') != null;
    return output;
  }

  List<Todo> getAllTodos() {
    final List<Todo> todos = todoBox.values.toList();

    return todos;
  }

  Future<void> addTodo(Todo todo) async {
    await todoBox.add(todo);
  }

  Future<void> editTodo(int index, bool isPaused,
      {double? duration, bool? isOpen, String? status}) async {
    final todo = todoBox.getAt(index);
    todoBox.putAt(
        index,
        Todo(
          title: todo?.title ?? '',
          desc: todo?.desc ?? '',
          duration: duration ?? todo?.duration ?? 1.0,
          isPause: isPaused,
          isOp: isOpen ?? todo?.isOpen ?? false,
          sts: status ?? todo?.status ?? 'TODO',
        ));
    // await todo.save();
  }

  Future<void> deleteTodo(int index) async {
    await todoBox.deleteAt(index);
  }

  Future<void> updateDuration(
    double duration,
    int index,
  ) async {
    final todo = todoBox.getAt(index);
    await todoBox.putAt(
        index,
        Todo(
          title: todo?.title ?? '',
          desc: todo?.desc ?? '',
          duration: duration,
          isPause: todo?.isPaused ?? false,
        ));
  }
}

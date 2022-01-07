import 'package:hive/hive.dart';
part 'todo_type_define.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String desc;

  @HiveField(2)
  final double duration;

  @HiveField(3)
  bool isPaused = true;

  @HiveField(4)
  bool isOpen = false;

  @HiveField(5)
  String status = 'TODO';

  Todo({
    required this.title,
    required this.desc,
    required this.duration,
    bool isPause = true,
    bool isOp = false,
    String sts = 'TODO',
  }) {
    isPaused = isPause;
    isOpen = isOp;
    status = sts;
  }
}

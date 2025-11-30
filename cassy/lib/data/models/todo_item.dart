import 'package:hive/hive.dart';

// part 'todo_item.g.dart'; // not used for codegen but keeps convention (optional)

// We define a simple model and a manual TypeAdapter
class TodoItem {
  String id;
  String title;
  String? description;
  bool completed;
  DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    this.description,
    this.completed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // convenience copyWith
  TodoItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Manual TypeAdapter for TodoItem
class TodoItemAdapter extends TypeAdapter<TodoItem> {
  @override
  final int typeId = 0;

  @override
  TodoItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      fields[key] = reader.read();
    }
    return TodoItem(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      completed: fields[3] as bool,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TodoItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.createdAt);
  }
}

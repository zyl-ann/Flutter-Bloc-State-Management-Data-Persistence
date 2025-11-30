import 'package:hive/hive.dart';
// ignore: unused_import
import '../../core/constants.dart';
import '../models/todo_item.dart';

class TodoRepository {
  final Box _box;

  TodoRepository(this._box);

  List<TodoItem> loadItems() {
    return _box.values.cast<TodoItem>().toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addItem(TodoItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> updateItem(TodoItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }
}

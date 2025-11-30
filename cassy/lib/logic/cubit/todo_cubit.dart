import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/models/todo_item.dart';
import '../../data/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository repository;
  final Uuid _uuid = Uuid();

  TodoCubit({required this.repository}) : super(const TodoState.initial()) {
    load();
  }

  void load() {
    try {
      final items = repository.loadItems();
      emit(state.copyWith(items: items, status: TodoStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(status: TodoStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> add(String title, {String? description}) async {
    final item = TodoItem(
      id: _uuid.v4(),
      title: title,
      description: description,
    );
    final newList = [item, ...state.items];
    emit(state.copyWith(items: newList, status: TodoStatus.loaded));
    await repository.addItem(item);
  }

  Future<void> toggleComplete(String id) async {
    final idx = state.items.indexWhere((i) => i.id == id);
    if (idx == -1) return;
    final item = state.items[idx];
    final updated = item.copyWith(completed: !item.completed);
    final newList = List<TodoItem>.from(state.items);
    newList[idx] = updated;
    emit(state.copyWith(items: newList));
    await repository.updateItem(updated);
  }

  Future<void> update(
    String id, {
    required String title,
    String? description,
  }) async {
    final idx = state.items.indexWhere((i) => i.id == id);
    if (idx == -1) return;
    final item = state.items[idx];
    final updated = item.copyWith(title: title, description: description);
    final newList = List<TodoItem>.from(state.items);
    newList[idx] = updated;
    emit(state.copyWith(items: newList));
    await repository.updateItem(updated);
  }

  Future<void> delete(String id) async {
    final newList = state.items.where((i) => i.id != id).toList();
    emit(state.copyWith(items: newList));
    await repository.deleteItem(id);
  }
}

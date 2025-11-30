part of 'todo_cubit.dart';

enum TodoStatus { initial, loading, loaded, error }

@immutable
class TodoState {
  final List<TodoItem> items;
  final TodoStatus status;
  final String? errorMessage;

  const TodoState({
    required this.items,
    required this.status,
    this.errorMessage,
  });

  const TodoState.initial()
    : items = const [],
      status = TodoStatus.initial,
      errorMessage = null;

  TodoState copyWith({
    List<TodoItem>? items,
    TodoStatus? status,
    String? errorMessage,
  }) {
    return TodoState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

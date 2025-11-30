import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/todo_cubit.dart';
import '../../logic/cubit/theme_cubit.dart'; // <-- Add this
import '../widgets/add_edit_dialog.dart';
import '../../data/models/todo_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _showAdd(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (c) => const AddEditDialog(title: 'Add Item'),
    );
    if (result != null) {
      await context.read<TodoCubit>().add(
        result['title'] as String,
        description: result['description'] as String?,
      );
    }
  }

  Future<void> _showEdit(BuildContext context, TodoItem item) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (c) => AddEditDialog(item: item, title: 'Edit Item'),
    );
    if (result != null) {
      await context.read<TodoCubit>().update(
        item.id,
        title: result['title'] as String,
        description: result['description'] as String?,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cassy Todo List'),
        actions: [
          IconButton(
            // Dynamic icon depending on current theme
            icon: Icon(
              context.watch<ThemeCubit>().state == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == TodoStatus.error) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            final items = state.items;
            if (items.isEmpty) {
              return const Center(child: Text('No items yet. Tap + to add.'));
            }

            return RefreshIndicator(
              onRefresh: () async => context.read<TodoCubit>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) =>
                        context.read<TodoCubit>().delete(item.id),
                    child: Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: item.completed,
                          onChanged: (_) =>
                              context.read<TodoCubit>().toggleComplete(item.id),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            decoration: item.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: item.description != null
                            ? Text(item.description!)
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEdit(context, item),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAdd(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

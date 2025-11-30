import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants.dart';
import 'data/models/todo_item.dart';
import 'data/repositories/todo_repository.dart';
import 'logic/cubit/todo_cubit.dart';
import 'logic/cubit/theme_cubit.dart';
import 'presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapter
  Hive.registerAdapter(TodoItemAdapter());

  // Open boxes
  final todoBox = await Hive.openBox<TodoItem>(Constants.hiveTodoBox);
  final themeBox = await Hive.openBox(Constants.hiveThemeBox);

  final repo = TodoRepository(todoBox);

  runApp(MyApp(repository: repo, themeBox: themeBox));
}

class MyApp extends StatelessWidget {
  final TodoRepository repository;
  final Box themeBox;

  const MyApp({Key? key, required this.repository, required this.themeBox})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TodoCubit(repository: repository)),
        BlocProvider(create: (_) => ThemeCubit(themeBox)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Cassy Todo List',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.indigo,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: const ColorScheme.dark(primary: Colors.indigo),
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

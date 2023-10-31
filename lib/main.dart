import 'package:flutter/material.dart';
import 'package:flutter_application_3/bloc/bloc/task_bloc.dart';
import 'package:flutter_application_3/screens/task_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBloc.storage = storage;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'task App',
        home: TaskScreen(),
      ),
    );
  }
}

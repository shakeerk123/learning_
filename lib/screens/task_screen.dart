import 'package:flutter/material.dart';
import 'package:flutter_application_3/bloc/bloc/task_bloc.dart';
import 'package:flutter_application_3/model/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class TaskScreen extends StatefulWidget {
 const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController textEditingController = TextEditingController();

  final _uuid = const Uuid();

  void addTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Add task :',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextField(
                  autofocus: true,
                  controller: textEditingController,
                  decoration: const InputDecoration(
                      label: Text('Title'), border: OutlineInputBorder()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('cancel')),
                    ElevatedButton(
                        onPressed: () {
                          var task = Task(
                            id: _uuid.v4(),
                            title: textEditingController.text,
                          );
                          context.read<TaskBloc>().add(AddTask(task: task));
                          textEditingController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('save'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        List<Task> taskList = state.allTasks;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Task Screen"),
            actions: [
              IconButton(
                  onPressed: () => addTask(context),
                  icon: const Icon(Icons.add)),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Chip(label: Text("Tasks")),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    var task = taskList[index];
                    return ListTile(
                      title: Text(task.title),
                      trailing: Checkbox(
                        value: task.isDone,
                        onChanged: (value) {
                          context.read<TaskBloc>().add(UpdateTask(task: task));
                        },
                      ),
                      onLongPress: () =>
                          context.read<TaskBloc>().add(DeleteTask(task: task)),
                    );
                  },
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => addTask(context),
          ),
        );
      },
    );
  }
}

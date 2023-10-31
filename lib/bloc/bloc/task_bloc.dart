import 'dart:async';
// ignore: unnecessary_import
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_3/model/task.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends HydratedBloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskState()) {
    on<AddTask>(addTask);
    on<UpdateTask>(updateTask);
    on<DeleteTask>(deleteTask);
  }

  FutureOr<void> addTask(AddTask event, Emitter<TaskState> emit) {
    emit(TaskState(
      allTasks: List.from(state.allTasks)..add(event.task),
    ));
  }

  FutureOr<void> updateTask(UpdateTask event, Emitter<TaskState> emit) {
    final task = event.task;
    final int index = state.allTasks.indexOf(task);
    List<Task> allTasks = List.from(state.allTasks)..remove(task);
    task.isDone == false
        ? allTasks.insert(index, task.copyWith(isDone: true))
        : allTasks.insert(index, task.copyWith(isDone: false));
    emit(TaskState(allTasks: allTasks));
  }

  FutureOr<void> deleteTask(DeleteTask event, Emitter<TaskState> emit) {
    emit(TaskState(allTasks: List.from(state.allTasks)..remove(event.task)));
  }

  @override
  TaskState? fromJson(Map<String, dynamic> json) {
    return TaskState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TaskState state) {
    return state.toMap();
  }
}

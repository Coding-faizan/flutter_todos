import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/logger.dart';
import '../models/todo.dart';

abstract class TodosDatasource {
  static const String collectionName = 'todos';

  Stream<List<Todo>> getTodos();

  Future<void> saveTodo(Todo todo);

  Future<void> deleteTodo(String id);

  Future<int> clearCompleted();

  Future<int> completeAll({required bool areAllCompleted});
}

class TodosDatasourceImpl implements TodosDatasource {
  final FirebaseFirestore _firestore;

  TodosDatasourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _todosRef =>
      _firestore.collection(TodosDatasource.collectionName);

  @override
  Stream<List<Todo>> getTodos() => _todosRef.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) {
          final Map<String, dynamic> data = doc.data();
          return Todo.fromJson(data);
        }).toList(),
      );

  @override
  Future<void> saveTodo(Todo todo) async {
    final doc = _todosRef.doc(todo.id);
    await doc.set(todo.toJson());
    return;
  }

  @override
  Future<void> deleteTodo(String id) async {
    final doc = _todosRef.doc(id);
    await doc.delete();
  }

  @override
  Future<int> clearCompleted() async {
    final snapshot =
        await _todosRef.where('isCompleted', isEqualTo: true).get();
    final completedTodos = snapshot.docs;
    final completedTodosAmount = completedTodos.length;

    final deleteFutures = <Future<void>>[];

    for (final todo in completedTodos) {
      deleteFutures.add(todo.reference.delete());
    }

    await Future.wait(deleteFutures);
    return completedTodosAmount;
  }

  Future<int> completeAll({required bool areAllCompleted}) async {
    final snapshot = await _todosRef.get();
    final todos = snapshot.docs;

    final updates = <Future<void>>[];

    for (final todo in todos) {
      final data = todo.data();
      final currentTodo = Todo.fromJson(data);

      if (currentTodo.isCompleted != areAllCompleted) {
        final updatedTodo = currentTodo.copyWith(isCompleted: areAllCompleted);
        updates.add(todo.reference.set(updatedTodo.toJson()));
      }
    }

    await Future.wait(updates); // ⏱️ Runs all updates in parallel
    return updates.length;
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../data/models/todo.dart';
import '../../../data/repository/todos_repository_impl.dart';
import '../../extensions/todos_view_filter.dart';

part 'todos_overview_state.dart';

class TodosOverviewCubit extends Cubit<TodosOverviewState> {
  TodosOverviewCubit({
    required TodosRepositoryImpl todosRepository,
  })  : _todosRepository = todosRepository,
        super(const TodosOverviewInitial()) {
    _onSubscriptionRequested();
  }

  final TodosRepositoryImpl _todosRepository;
  late final StreamSubscription<List<Todo>> _todosSubscription;

  Future<void> _onSubscriptionRequested() async {
    emit(const TodosOverviewLoading());

    _todosSubscription = _todosRepository.getTodos().listen((List<Todo> todos) {
      emit(state.copyWith(todos: () => todos));
    }, onError: (_) {
      emit(const TodosOverviewFailure());
    });
  }

  @override
  Future<void> close() {
    _todosSubscription.cancel();
    return super.close();
  }

  Future<void> onTodoCompletionToggled(
    Todo todo,
  ) async {
    final Todo newTodo = state.todos
        .firstWhere((t) => t.id == todo.id)
        .copyWith(isCompleted: !todo.isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  Future<void> onTodoDeleted(
    Todo todo,
  ) async {
    emit(state.copyWith(lastDeletedTodo: () => todo));
    await _todosRepository.deleteTodo(todo.id);
  }

  Future<void> onUndoDeletionRequested() async {
    assert(
      state.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );

    final Todo todo = state.lastDeletedTodo!;
    emit(state.copyWith(lastDeletedTodo: () => null));
    await _todosRepository.saveTodo(todo);
  }

  void onFilterChanged(TodosViewFilter filter) {
    emit(state.copyWith(filter: () => filter));
  }

  Future<void> onToggleAllRequested() async {
    final bool areAllCompleted =
        state.todos.every((Todo todo) => todo.isCompleted);
    await _todosRepository.completeAll(isCompleted: !areAllCompleted);
  }

  Future<void> onClearCompletedRequested() async {
    await _todosRepository.clearCompleted();
  }
}

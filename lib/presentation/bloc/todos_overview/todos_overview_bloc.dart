import 'package:bloc/bloc.dart';

import '../../../data/models/todo.dart';
import '../../../domain/repository/todos_repository.dart';
import '../../extensions/todos_view_filter.dart';

part 'todos_overview_state.dart';

class TodosOverviewCubit extends Cubit<TodosOverviewState> {
  TodosOverviewCubit({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const TodosOverviewInitial());

  final TodosRepository _todosRepository;

  Future<void> onSubscriptionRequested(
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(const TodosOverviewLoading());

    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (List<Todo> todos) => state.copyWith(
        todos: () => todos,
      ),
      onError: (_, __) => const TodosOverviewFailure(),
    );
  }

  Future<void> onTodoCompletionToggled(
    Todo todo,
  ) async {
    final Todo newTodo = state.todos
        .firstWhere((Todo todo) => todo.id == todo.id)
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

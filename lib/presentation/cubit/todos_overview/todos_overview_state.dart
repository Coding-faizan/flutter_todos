part of 'todos_overview_bloc.dart';

sealed class TodosOverviewState {
  const TodosOverviewState({
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
  });

  final List<Todo> todos;
  final TodosViewFilter filter;
  final Todo? lastDeletedTodo;

  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  TodosOverviewState copyWith({
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  });
}

final class TodosOverviewInitial extends TodosOverviewState {
  const TodosOverviewInitial({
    super.todos,
    super.filter,
    super.lastDeletedTodo,
  });

  @override
  TodosOverviewState copyWith({
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  }) {
    return TodosOverviewInitial(
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }
}

final class TodosOverviewLoading extends TodosOverviewState {
  const TodosOverviewLoading({
    super.todos,
    super.filter,
    super.lastDeletedTodo,
  });

  @override
  TodosOverviewState copyWith({
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  }) {
    return TodosOverviewLoading(
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }
}

final class TodosOverviewSuccess extends TodosOverviewState {
  const TodosOverviewSuccess({
    super.todos,
    super.filter,
    super.lastDeletedTodo,
  });

  @override
  TodosOverviewState copyWith({
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  }) {
    return TodosOverviewSuccess(
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }
}

final class TodosOverviewFailure extends TodosOverviewState {
  const TodosOverviewFailure({
    super.todos,
    super.filter,
    super.lastDeletedTodo,
  });

  @override
  TodosOverviewState copyWith({
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  }) {
    return TodosOverviewFailure(
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }
}

part of 'edit_todo_cubit.dart';

sealed class EditTodoState {
  const EditTodoState({
    this.initialTodo,
    this.title = '',
    this.description = '',
  });

  EditTodoState copyWith({
    Todo? initialTodo,
    String? title,
    String? description,
  });

  final Todo? initialTodo;
  final String title;
  final String description;

  bool get isNewTodo => initialTodo == null;
}

final class EditTodoInitial extends EditTodoState {
  const EditTodoInitial({
    super.initialTodo,
    super.title,
    super.description,
  });

  @override
  EditTodoState copyWith(
      {Todo? initialTodo, String? title, String? description}) {
    return EditTodoInitial(
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

final class EditTodoLoading extends EditTodoState {
  const EditTodoLoading({
    super.initialTodo,
    super.title,
    super.description,
  });

  @override
  EditTodoState copyWith(
      {Todo? initialTodo, String? title, String? description}) {
    return EditTodoLoading(
      initialTodo: initialTodo ?? this.initialTodo,
    );
  }
}

final class EditTodoSuccess extends EditTodoState {
  const EditTodoSuccess({
    super.initialTodo,
    super.title,
    super.description,
  });

  @override
  EditTodoState copyWith(
      {Todo? initialTodo, String? title, String? description}) {
    return EditTodoSuccess(
      initialTodo: initialTodo ?? this.initialTodo,
    );
  }
}

final class EditTodoFailure extends EditTodoState {
  const EditTodoFailure({
    super.initialTodo,
    super.title,
    super.description,
  });

  @override
  EditTodoState copyWith(
      {Todo? initialTodo, String? title, String? description}) {
    return EditTodoFailure(
      initialTodo: initialTodo ?? this.initialTodo,
    );
  }
}

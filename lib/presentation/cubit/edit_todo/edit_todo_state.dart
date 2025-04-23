part of 'edit_todo_cubit.dart';

sealed class EditTodoState {
  const EditTodoState({
    this.initialTodo,
    required this.form,
  });

  final Todo? initialTodo;

  final FormGroup form;

  bool get isNewTodo => initialTodo == null;
}

final class EditTodoInitial extends EditTodoState {
  const EditTodoInitial({
    super.initialTodo,
    required super.form,
  });
}

final class EditTodoLoading extends EditTodoState {
  const EditTodoLoading({
    super.initialTodo,
    required super.form,
  });
}

final class EditTodoSuccess extends EditTodoState {
  const EditTodoSuccess({
    super.initialTodo,
    required super.form,
  });
}

final class EditTodoFailure extends EditTodoState {
  const EditTodoFailure({
    super.initialTodo,
    required super.form,
  });
}

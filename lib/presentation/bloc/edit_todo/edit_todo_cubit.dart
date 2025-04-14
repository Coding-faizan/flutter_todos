import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/todo.dart';
import '../../../domain/repository/todos_repository.dart';

part 'edit_todo_state.dart';

class EditTodoCubit extends Cubit<EditTodoState> {
  EditTodoCubit({
    required TodosRepository todosRepository,
    required Todo? initialTodo,
  })  : _todosRepository = todosRepository,
        super(
          EditTodoInitial(
            initialTodo: initialTodo,
            title: initialTodo?.title ?? '',
            description: initialTodo?.description ?? '',
          ),
        );

  final TodosRepository _todosRepository;

  // Helper method to create a new state of the same type with updated values
  EditTodoState _updateState({
    String? title,
    String? description,
  }) {
    return state.copyWith(
      title: title,
      description: description,
    );
  }

  void titleChanged(String title) {
    emit(_updateState(title: title));
  }

  void descriptionChanged(String description) {
    emit(_updateState(description: description));
  }

  Future<void> submitted() async {
    emit(
      EditTodoLoading(
        initialTodo: state.initialTodo,
        title: state.title,
        description: state.description,
      ),
    );

    final Todo todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
    );

    try {
      await _todosRepository.saveTodo(todo);
      emit(
        EditTodoSuccess(
          initialTodo: state.initialTodo,
          title: state.title,
          description: state.description,
        ),
      );
    } catch (e) {
      emit(
        EditTodoFailure(
          initialTodo: state.initialTodo,
          title: state.title,
          description: state.description,
        ),
      );
    }
  }
}

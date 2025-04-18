import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../data/models/todo.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/form_control_model.dart';
import '../../../domain/repository/todos_repository.dart';
import '../../extensions/form_group_extension.dart';

part 'edit_todo_state.dart';

class EditTodoCubit extends Cubit<EditTodoState> {
  EditTodoCubit({
    required TodosRepository todosRepository,
    required Todo? initialTodo,
  })  : _todosRepository = todosRepository,
        super(
          EditTodoInitial(
            initialTodo: initialTodo,
            form: FormGroup({
              FormControlName.title.name: FormControlModel.title(
                value: initialTodo?.title,
              ).control,
              FormControlName.description.name: FormControlModel.description(
                value: initialTodo?.description,
              ).control,
            }),
          ),
        );

  final TodosRepository _todosRepository;

  Future<void> submitted() async {
    if (!state.form.validateAndFocus) {
      return;
    }
    emit(
      EditTodoLoading(
        initialTodo: state.initialTodo,
        form: state.form,
      ),
    );

    final Todo todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.form.value['title'].toString(),
      description: state.form.value['description'].toString(),
    );

    try {
      await _todosRepository.saveTodo(todo);
      emit(
        EditTodoSuccess(
          initialTodo: state.initialTodo,
          form: state.form,
        ),
      );
    } catch (e) {
      emit(
        EditTodoFailure(
          initialTodo: state.initialTodo,
          form: state.form,
        ),
      );
    }
  }
}

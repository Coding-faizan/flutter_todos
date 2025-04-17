import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../data/models/todo.dart';
import '../../../domain/repository/todos_repository.dart';
part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const StatsInitial()) {
    _onSubscriptionRequested();
  }

  final TodosRepository _todosRepository;
  late final StreamSubscription<List<Todo>> _todosSubscription;

  Future<void> _onSubscriptionRequested() async {
    emit(const StatsLoading());

    _todosSubscription = _todosRepository.getTodos().listen((List<Todo> todos) {
      emit(StatsSuccess(
        completedTodos: todos.where((Todo todo) => todo.isCompleted).length,
        activeTodos: todos.where((Todo todo) => !todo.isCompleted).length,
      ));
    }, onError: (_) {
      emit(const StatsFailure());
    });
  }

  @override
  Future<void> close() {
    _todosSubscription.cancel();
    return super.close();
  }
}

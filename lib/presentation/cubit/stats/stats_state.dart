part of 'stats_bloc.dart';

sealed class StatsState {
  const StatsState({
    this.completedTodos = 0,
    this.activeTodos = 0,
  });

  final int completedTodos;
  final int activeTodos;

  StatsState copyWith({
    int? completedTodos,
    int? activeTodos,
  });
}

final class StatsInitial extends StatsState {
  const StatsInitial({
    super.completedTodos,
    super.activeTodos,
  });

  @override
  StatsState copyWith({int? completedTodos, int? activeTodos}) {
    return StatsInitial(
      completedTodos: completedTodos ?? this.completedTodos,
      activeTodos: activeTodos ?? this.activeTodos,
    );
  }
}

final class StatsLoading extends StatsState {
  const StatsLoading({
    super.completedTodos,
    super.activeTodos,
  });

  @override
  StatsState copyWith({int? completedTodos, int? activeTodos}) {
    return StatsLoading(
      completedTodos: completedTodos ?? this.completedTodos,
      activeTodos: activeTodos ?? this.activeTodos,
    );
  }
}

final class StatsSuccess extends StatsState {
  const StatsSuccess({
    super.completedTodos,
    super.activeTodos,
  });

  @override
  StatsState copyWith({int? completedTodos, int? activeTodos}) {
    return StatsSuccess(
      completedTodos: completedTodos ?? this.completedTodos,
      activeTodos: activeTodos ?? this.activeTodos,
    );
  }
}

final class StatsFailure extends StatsState {
  const StatsFailure({
    super.completedTodos,
    super.activeTodos,
  });

  @override
  StatsState copyWith({int? completedTodos, int? activeTodos}) {
    return StatsFailure(
      completedTodos: completedTodos ?? this.completedTodos,
      activeTodos: activeTodos ?? this.activeTodos,
    );
  }
}

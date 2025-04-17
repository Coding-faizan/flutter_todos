import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/todos_overview/todos_overview_bloc.dart';
import '../extensions/todos_view_filter.dart';
import 'localized_text.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter =
        context.select((TodosOverviewCubit bloc) => bloc.state.filter);

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: 'todosOverviewFilterTooltip',
      onSelected: (filter) {
        context.read<TodosOverviewCubit>().onFilterChanged(filter);
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: TodosViewFilter.all,
            child: LocalizedText('todosOverviewFilterAll'),
          ),
          PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: const LocalizedText('todosOverviewFilterActiveOnly'),
          ),
          PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: const LocalizedText('todosOverviewFilterCompletedOnly'),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}

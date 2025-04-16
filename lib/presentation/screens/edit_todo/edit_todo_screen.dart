import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/todo.dart';
import '../../../domain/repository/todos_repository.dart';
import '../../cubit/edit_todo/edit_todo_cubit.dart';
import '../../shared_widgets/localized_text.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoCubit, EditTodoState>(
      listenWhen: (previous, current) =>
          previous is! EditTodoSuccess && current is EditTodoSuccess,
      listener: (BuildContext context, EditTodoState state) =>
          Navigator.of(context).pop(),
      child: const EditTodoView(),
    );
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.select(
      (EditTodoCubit cubit) => cubit.state is EditTodoLoading,
    );
    final bool isNewTodo = context.select(
      (EditTodoCubit cubit) => cubit.state.isNewTodo,
    );

    return Scaffold(
      appBar: AppBar(
        title: LocalizedText(
          isNewTodo ? 'editTodoAddAppBarTitle' : 'editTodoEditAppBarTitle',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed:
            isLoading ? null : () => context.read<EditTodoCubit>().submitted(),
        child: isLoading
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[_TitleField(), _DescriptionField()],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final EditTodoState state = context.watch<EditTodoCubit>().state;
    final String hintText = state.initialTodo?.title ?? '';
    final bool isLoading = state is EditTodoLoading;

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !isLoading,
        labelText: 'editTodoTitleLabel',
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (String value) {
        context.read<EditTodoCubit>().titleChanged(value);
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final EditTodoState state = context.watch<EditTodoCubit>().state;
    final String hintText = state.initialTodo?.description ?? '';
    final bool isLoading = state is EditTodoLoading;

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !isLoading,
        labelText: 'editTodoDescriptionLabel',
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (String value) {
        context.read<EditTodoCubit>().descriptionChanged(value);
      },
    );
  }
}

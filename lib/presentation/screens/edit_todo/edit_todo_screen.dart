import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../cubit/edit_todo/edit_todo_cubit.dart';
import '../../shared_widgets/localized_text.dart';
import '../../shared_widgets/text_form_field_widget.dart';

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
        onPressed: () => context.read<EditTodoCubit>().submitted(),
        child: context.select(
          (EditTodoCubit cubit) => cubit.state is EditTodoLoading,
        )
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ReactiveForm(
              formGroup: context.read<EditTodoCubit>().state.form,
              child: Column(
                children: <Widget>[
                  TextFormFieldWidget.title(),
                  SizedBox(height: 16),
                  TextFormFieldWidget.description(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:blocsqlitecrud/cubits/note_validation_cubit.dart';
import 'package:blocsqlitecrud/cubits/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blocsqlitecrud/models/note.dart';

class NoteEditPage extends StatelessWidget {
  const NoteEditPage({Key? key, this.note}) : super(key: key);
  final Note? note;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<NotesCubit>(context),
        ),
        BlocProvider(
          create: (context) => NoteValidationCubit(),
        ),
      ],
      child: NotesEditView(note: note),
    );
  }
}

class NotesEditView extends StatelessWidget {
  NotesEditView({
    Key? key,
    this.note,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final Note? note;

  @override
  Widget build(BuildContext context) {
    if (note == null) {
      _titleController.text = '';
      _contentController.text = '';
    } else {
      _titleController.text = note!.name;
      _contentController.text = note!.price as String;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить/изменить товар'),
      ),
      body: BlocListener<NotesCubit, NotesState>(
        listener: (context, state) {
          if (state is NotesInitial) {
            const SizedBox();
          } else if (state is NotesLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                });
          } else if (state is NotesSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Операция успешна'),
              ));
            Navigator.pop(context);
            context.read<NotesCubit>().buscarNotas();
          } else if (state is NotesLoaded) {
            Navigator.pop(context);
          } else if (state is NotesFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Ошибка'),
              ));
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<NoteValidationCubit, NoteValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Цена товара',
                      ),
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _contentFocusNode.requestFocus,
                      onChanged: (text) {
                        context.read<NoteValidationCubit>().validaForm(
                            _titleController.text, _contentController.text);
                      },
                      onFieldSubmitted: (String value) {},
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (state is NoteValidating) {
                          if (state.tituloMessage == '') {
                            return null;
                          } else {
                            return state.tituloMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<NoteValidationCubit, NoteValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Название товара',
                      ),
                      controller: _contentController,
                      focusNode: _contentFocusNode,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        context.read<NoteValidationCubit>().validaForm(
                            _titleController.text, _contentController.text);
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          context.read<NotesCubit>().salvarNota(note?.id,
                              _titleController.text, _contentController.text);
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (state is NoteValidating) {
                          if (state.conteudoMessage == '') {
                            return null;
                          } else {
                            return state.conteudoMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child:
                        BlocBuilder<NoteValidationCubit, NoteValidationState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is NoteValidated
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    context.read<NotesCubit>().salvarNota(
                                        note?.id,
                                        _titleController.text,
                                        _contentController.text);
                                  }
                                }
                              : null,
                          child: const Text('Сохранить'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

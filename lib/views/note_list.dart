import 'package:blocsqlitecrud/cubits/notes_cubit.dart';
import 'package:blocsqlitecrud/models/note.dart';
import 'package:blocsqlitecrud/views/note_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<NotesCubit>(context)..buscarNotas(),
      child: const DocumentosView(),
    );
  }
}

class DocumentosView extends StatelessWidget {
  const DocumentosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список товаров'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Удалить все товары?'),
                  content: const Text('Вы действительно хотите этого?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Нет'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<NotesCubit>().excluirNotas();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                            content: Text('Все удалено успешно'),
                          ));
                      },
                      child: const Text('Да'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: const _Content(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NoteEditPage(note: null)),
          );
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotesCubit>().state;
    if (state is NotesInitial) {
      return const SizedBox();
    } else if (state is NotesLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (state is NotesLoaded) {
      if (state.notes!.isEmpty) {
        return const Center(
          child: Text('Нету товаров. Что бы добавить, нажмите на плюс'),
        );
      } else {
        return _NotesList(state.notes);
      }
    } else {
      return const Center(
        child: Text('Ошибка при создании товара.'),
      );
    }
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList(this.notes, {Key? key}) : super(key: key);
  final List<Note>? notes;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final note in notes!) ...[
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(note.name),
              subtitle: Text(
                note.price,
              ),
              trailing: Wrap(children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteEditPage(note: note)),
                    );
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Удалить товар?'),
                          content: const Text('Вы действительно этого хотите?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Нет'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<NotesCubit>().excluirNota(note.id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    content: Text('Операция успешна'),
                                  ));
                              },
                              child: const Text('Да'),
                            ),
                          ],
                        ),
                      );
                    }),
              ]),
            ),
          ),
          // const Divider(
          //   height: 2,
          // ),
        ],
      ],
    );
  }
}

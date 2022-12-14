import 'package:blocsqlitecrud/cubits/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'db/database_provider.dart';
import 'views/note_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DatabaseProvider.instance,
      child: BlocProvider(
        create: (context) =>
            NotesCubit(databaseProvider: DatabaseProvider.instance),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CRUD App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const NoteListPage(),
        ),
      ),
    );
  }
}

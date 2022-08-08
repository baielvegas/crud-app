part of 'notes_cubit.dart';

abstract class NotesState extends Equatable {
  const NotesState();
}

class NotesInitial extends NotesState {
  const NotesInitial();

  @override
  List<Object?> get props => [];
}

class NotesLoading extends NotesState {
  const NotesLoading();

  @override
  List<Object?> get props => [];
}

class NotesLoaded extends NotesState {
  const NotesLoaded({
    this.notes,
  });

  final List<Note>? notes;

  NotesLoaded copyWith({
    List<Note>? notes,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [notes];
}

class NotesFailure extends NotesState {
  const NotesFailure();

  @override
  List<Object?> get props => [];
}

class NotesSuccess extends NotesState {
  const NotesSuccess();

  @override
  List<Object?> get props => [];
}

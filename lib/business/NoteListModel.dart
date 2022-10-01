class NotesListModel {
  final List<Note> _list = [];

  void saveNote(Note note) {
    _list.add(note);
  }

  List<Note> getNotes() => _list;
}

class Note {
  final double noteId;
  final String productName;
  final String description;
  final DateTime purchasedOn;
  final DateTime expiresOn;

  Note(
      {required this.noteId,
      required this.productName,
      required this.description,
      required this.purchasedOn,
      required this.expiresOn});
}

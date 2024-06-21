import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get notes from database
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

//create:  adding a new note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

//read: getting the content of note from database
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

//update: changing the content of note
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

//delete: removing the note
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}

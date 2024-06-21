import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//firestore
  final FirestoreService firestoreService = FirestoreService();

//text controller
  final TextEditingController textController = TextEditingController();

//open a dialog box for text input
  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          //button to save
          ElevatedButton(
            onPressed: () {
              //add a new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }
              //update a pre note
              else {
                firestoreService.updateNote(docID, textController.text);
              }

              //clear text controller
              textController.clear();

              //close dialog box
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // Check if snapshot has data and is not null
          if (snapshot.hasData && snapshot.data != null) {
            // Extract list of documents from snapshot
            List<DocumentSnapshot> notesList = snapshot.data!.docs;

            // Display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // Get each individual document
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // Get notes from each document
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText =
                    data['note']; // Assuming 'note' is a field in your document

                // Display as a list tile
                return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          //update button
                          onPressed: () => openNoteBox(docID: docID),
                          icon: const Icon(Icons.edit),
                        ),

                        //delete button
                        IconButton(
                          onPressed: () => firestoreService.deleteNote(docID),
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    ));
              },
            );
          }
          // If there is no data or data is null, return a message
          else {
            return const Center(
              child: const Text("Nothing here!"),
            );
          }
        },
      ),
    );
  }
}

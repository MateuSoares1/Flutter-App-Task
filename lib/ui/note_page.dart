import 'package:flutter/material.dart';
import 'package:flutterNotes/helpers/note_helper.dart';

class NotePage extends StatefulWidget {
  final Note note;
  NotePage({this.note});
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final tituloController = TextEditingController();
  final textoController = TextEditingController();


  final tituloFocus = FocusNode();


  bool userEdit = false;

  Note editNote;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note == null) {
      editNote = Note();
    } else {
      editNote = Note.fromMap(widget.note.toMap());
      tituloController.text = editNote.titulo;
      textoController.text = editNote.texto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Titulo'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
                controller: tituloController,
                focusNode: tituloFocus,
                onChanged: (text) {
                  userEdit = true;
                  setState(() {
                    editNote.titulo = text;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Titulo User",
                    labelStyle: TextStyle(color: Colors.blueAccent))),
            TextFormField(
                controller: textoController,
                onChanged: (text) {
                  userEdit = true;
                  setState(() {
                    editNote.texto = text;
                  });
                },
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Escreva aqui...",
                    labelStyle: TextStyle(color: Colors.blueAccent))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (editNote.titulo.isNotEmpty && editNote.titulo != null) {
            Navigator.pop(context, editNote);
          } else {
            FocusScope.of(context).requestFocus(tituloFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
    );
  }
}

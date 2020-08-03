import 'package:flutter/material.dart';
import 'package:flutterNotes/helpers/note_helper.dart';
import 'package:flutterNotes/ui/note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NoteHelper helper = NoteHelper();
  List<Note> notes = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Notes"),
        backgroundColor: Colors.blueGrey[50],
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNotePage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 3, mainAxisSpacing: 3),
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(10),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return noteCard(context, index);
        },
      ),
    );
  }

  Widget noteCard(BuildContext context, int index) {
    return SizedBox(
      height: 150,
      width: 80,
      child: GestureDetector(
        onTap: () {
          showNotePage(note: notes[index]);
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: _AnotacaoTexto(notes[index].texto),
          ),
        ),
      ),
    );
  }

  void showNotePage({Note note}) async {
    final recNote = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotePage(
                  note: note,
                )));
    if (recNote != null) {
      if (note != null) {
        await helper.updateNote(recNote);
        getAllNotes();
      } else {
        await helper.saveNote(recNote);
      }
      getAllNotes();
    }
  }

  void getAllNotes() {
    helper.getAllNote().then((list) {
      setState(() {
        notes = list;
      });
    });
  }
}

class _AnotacaoTexto extends StatelessWidget {
  final String _texto;
  _AnotacaoTexto(this._texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      _texto,
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );
  }
}

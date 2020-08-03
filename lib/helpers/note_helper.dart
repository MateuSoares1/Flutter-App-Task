import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String noteTable = "noteTable";
final String idColumn = "idColumn";
final String tituloColumn = "tituloColumn";
final String textoColumn = "textoColumn";
final String dataCriacaoColumn = "dataCriacaoColumn";
final String dataModificacaoColumn = "dataModificacaoColumn";

class NoteHelper {
  static final NoteHelper _instance = NoteHelper.internal();

  factory NoteHelper() => _instance;
  NoteHelper.internal();

  Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "notes.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $noteTable($idColumn INTEGER PRIMARY KEY, $tituloColumn TEXT, $textoColumn TEXT, $dataCriacaoColumn TEXT, $dataModificacaoColumn TEXT)");
    });
  }

  Future<Note> saveNote(Note note) async {
    Database dbNote = await db;
    note.id = await dbNote.insert(noteTable, note.toMap());
    return note;
  }

  Future<Note> getNote(int id) async {
    Database dbNote = await db;
    List<Map> maps = await dbNote.query(noteTable,
        columns: [
          idColumn,
          tituloColumn,
          textoColumn,
          dataCriacaoColumn,
          dataModificacaoColumn
        ],
        where: "$idColumn= ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Note.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteNote(int id) async {
    Database dbNote = await db;
    return dbNote.delete(noteTable, where: "$idColumn= ?", whereArgs: [id]);
  }

  Future<int> updateNote(Note note) async {
    Database dbNote = await db;
    return dbNote.update(noteTable, note.toMap(),
        where: "$idColumn= ?", whereArgs: [note.id]);
  }

  getAllNote() async {
    Database dbNote = await db;
    List listMap = await dbNote.rawQuery("SELECT * FROM $noteTable");
    List<Note> listNote = List();
    for (Map m in listMap) {
      listNote.add(Note.fromMap(m));
    }
    return listNote;
  }

  Future close() async {
    Database dbNote = await db;
    dbNote.close();
  }
}

class Note {
  int id;
  String texto;
  String titulo;
  String dataCriacao;
  String dataModificacao;

  Note();
  
  Note.fromMap(Map map) {
    id = map[idColumn];
    titulo = map[tituloColumn];
    texto = map[textoColumn];
    dataCriacao = map[dataCriacaoColumn];
    dataModificacao = map[dataModificacaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      textoColumn: texto,
      dataCriacaoColumn: dataCriacao,
      dataModificacaoColumn: dataModificacao
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}

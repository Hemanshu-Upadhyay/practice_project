import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteProvider(),
      child: MaterialApp(
        title: 'Notes App',
        theme: ThemeData.dark().copyWith(
          hintColor: Colors.white,
          scaffoldBackgroundColor: Colors.grey[900],
          textTheme: ThemeData.dark().textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        home: NotesHomePage(),
      ),
    );
  }
}

class NotesHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  provider.notes[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(provider.notes[index].text),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailPage(index: index),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    provider.deleteNote(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteDetailPage extends StatelessWidget {
  final int index;

  NoteDetailPage({required this.index});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context);
    TextEditingController _titleController =
        TextEditingController(text: provider.notes[index].title);
    TextEditingController _textEditingController =
        TextEditingController(text: provider.notes[index].text);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              provider.editNote(
                index,
                _titleController.text,
                _textEditingController.text,
              );
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Note',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddNotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context);
    TextEditingController _titleController = TextEditingController();
    TextEditingController _textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              provider.addNote(
                _titleController.text,
                _textEditingController.text,
              );
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Note',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          provider.addNote(
            _titleController.text,
            _textEditingController.text,
          );
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class NoteProvider with ChangeNotifier {
  List<Note> notes = [];

  void addNote(String title, String text) {
    notes.add(Note(
      title: title,
      text: text,
    ));
    notifyListeners();
  }

  void deleteNote(int index) {
    notes.removeAt(index);
    notifyListeners();
  }

  void editNote(int index, String newTitle, String newText) {
    notes[index].title = newTitle;
    notes[index].text = newText;
    notifyListeners();
  }
}

class Note {
  String title;
  String text;

  Note({
    required this.title,
    required this.text,
  });
}

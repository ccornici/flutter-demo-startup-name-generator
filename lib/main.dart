import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Startup Name Generator',
        home: RandomWords(),
      );
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  void _pushSaved() {
    final tiles = _saved.map((pair) => ListTile(title: Text(pair.asPascalCase, style: _biggerFont)));
    final divided = tiles.isNotEmpty ? ListTile.divideTiles(context: context, tiles: tiles).toList() : <Widget>[];

    final route = MaterialPageRoute<void>(
        builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Saved Suggestions')),
              body: ListView(children: divided),
            ));

    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider();
          }

          // Note: The syntax i ~/ 2 divides i by 2 and returns an integer result.
          // For example, the list [1,2,3,4,5] becomes [0,1,1,2,2].
          // This calculates the actual number of word pairings in the ListView,minus the divider widgets.
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          return ListTile(
            title: Text(_suggestions[index].asPascalCase, style: _biggerFont),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? "Remote from saved" : "Save",
            ),
            onTap: () {
              setState(() {
                alreadySaved ? _saved.remove(_suggestions[index]) : _saved.add(_suggestions[index]);
              });
            },
          );
        },
      ),
    );
  }
}

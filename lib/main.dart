import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  // set集合储存用户喜欢的单词对
  final _saved = new Set<WordPair>();
  // 添加MaterialPageRoute及其builder
  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
              (pair) {
                return new ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              }
          );
          final divided = ListTile
            .divideTiles(
            context: context,
            tiles: tiles,
          )
          .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        }
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Widget _buildRow(WordPair pair) {
      final alreadySaved = _saved.contains(pair);
      return new ListTile(
        title: new Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: (){
          // 为state对象触发build方法
          setState(() {
            if(alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      );
    }
    // 构建显示单词对的ListView
    Widget _buildSuggestions() {
      return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词,都会调用一次itemBuilder,然后将单词对添加到ListTile行中
        // 在偶数行中,该函数会为单词添加一个ListTile row
        // 在奇数行,该函数添加一个分割线wight,来分割相邻的词对
        itemBuilder: (context, i) {
          if(i.isOdd) return new Divider();
          final index= i ~/ 2;
          // 如果是建议列表的最后一个单词对
          if( index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        },
      );
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          // 某些widget属性需要单个widget(child),而其他一些属性,如action,需要一组widget(children),用方括号[]表示
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

}

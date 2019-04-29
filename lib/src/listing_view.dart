import 'package:bored_it/src/image_view.dart';
import 'package:bored_it/src/reddit/models.dart';
import 'package:bored_it/src/reddit/reddit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const defaultSubreddit = '/';
const subredditsKey = 'subreddits';

class ListingView extends StatefulWidget {
  ListingView({
    Key key,
  }) : super(key: key);

  @override
  _ListingViewState createState() => _ListingViewState();
}

class _ListingViewState extends State<ListingView> {
  final List<Link> _links = <Link>[];

  String _subreddit;

  final List<String> _subreddits = <String>[];

  _ListingViewState() {
    _loadSubreddits();
    _refreshSubreddit();
  }

  Future<void> _switchSubreddit(String name) async {
    final listing = await fetchSubreddit(name);
    setState(() {
      _links
        ..clear()
        ..addAll(
          listing.links
              .where((link) => link.thumbnail != null)
              .where((link) => link.postHint == 'image'),
        );
      _subreddit = name;
    });
  }

  void _addSubreddit(String name) {
    if (name == null) {
      return;
    }

    setState(() {
      _subreddits.add(name);
    });
    _saveSubreddits();
  }

  Future<void> _saveSubreddits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(subredditsKey, _subreddits);
  }

  Future<void> _loadSubreddits() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _subreddits
        ..clear()
        ..addAll(prefs.getStringList(subredditsKey) ?? <String>[]);
    });
  }

  Widget _linkList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        final link = _links[index];
        return ListTile(
          key: Key(link.title),
          leading: _linkThumbnail(index),
          title: Text(link.title),
        );
      },
      itemCount: _links?.length ?? 0,
    );
  }

  Widget _linkThumbnail(int index) {
    final uri = _links[index].thumbnail;

    Widget image;
    if (uri == null) {
      image = Icon(
        Icons.image,
      );
    } else {
      image = Image.network(uri.toString());
    }

    return Container(
      child: GestureDetector(
        child: image,
        onTap: () {
          _showImage(index);
        },
      ),
      color: Colors.black12,
      height: 50.0,
      width: 50.0,
    );
  }

  void _showImage(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return ImageView(uri: _links[index].url);
      }),
    );
  }

  Future<void> _refreshSubreddit() async {
    await _switchSubreddit(_subreddit);
  }

  DropdownMenuItem<String> _titleItem([String subreddit]) {
    final title = subreddit == null ? defaultSubreddit : '/r/$subreddit';
    return DropdownMenuItem<String>(
      child: Text(title),
      key: Key(subreddit ?? defaultSubreddit),
      value: subreddit,
    );
  }

  Widget _title() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: Icon(
          Icons.keyboard_arrow_down,
        ),
        iconDisabledColor: Colors.black12,
        iconEnabledColor: Colors.black54,
        items: <DropdownMenuItem<String>>[
          _titleItem(),
        ]..addAll(_subreddits.map(_titleItem).toList()),
        onChanged: (value) {
          _switchSubreddit(value);
        },
        value: _subreddit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: Icon(Icons.grade),
        title: _title(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _handleAddSubreddit,
          ),
        ],
      ),
      body: _linkList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshSubreddit,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _handleAddSubreddit() async {
    final subreddit = await showDialog<String>(
      builder: (context) {
        return SimpleDialog(
          title: const Text('Add Subreddit'),
          contentPadding: EdgeInsets.all(0.0),
          children: <Widget>[
            //
            Row(
              children: <Widget>[
                FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
                FlatButton(
                  child: const Text('ADD'),
                  onPressed: () {
                    Navigator.of(context).pop('programming');
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ],
        );
      },
      context: context,
    );
    if (subreddit != null) {
      _addSubreddit(subreddit);
    }
  }
}

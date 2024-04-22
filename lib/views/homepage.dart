import 'dart:convert';
import 'package:battleships/views/loginpage.dart';
import 'package:battleships/views/hamburgermenu.dart';
import 'package:battleships/views/game.dart';
import 'package:battleships/views/gameview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:battleships/utils/authmanager.dart';

class HomePage extends StatefulWidget {
  final String mainUrl = 'http://165.227.117.48/games';

  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>>? futureGames;
  String userName='';

  int _selectedIndex = 0;
  bool _showComplete = false;

  void _changeSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleSelection() {
    setState(() {
      _showComplete = !_showComplete;
    });
    _refreshGames();
  }

  @override
  void initState() {
    super.initState();
    futureGames = _loadGames();
    _showComplete = false;
    _selectedIndex = 0;
  }

  Future<void> _getUserName() async {
    final name = await AuthManager.getUserName();
    setState(() {
      userName = name;
    });
  }

  Future<List<dynamic>> _loadGames() async {
    final response = await http.get(Uri.parse(widget.mainUrl),headers: {'Authorization' : 'Bearer ${await AuthManager.getToken()}'});
    final games = json.decode(response.body);
    return games['games'];
  }


  Future<void> _addGame(Set game,String ai) async {
    var body = (ai=='') ? jsonEncode({'ships': game.map((e) => e).toList(),}) : jsonEncode({
        'ships': game.map((e) => e).toList(),
        'ai' : ai
      });
    await http.post(Uri.parse(widget.mainUrl),body: body, headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${await AuthManager.getToken()}'
        });
    _refreshGames();
  }

  Future<void> _deleteGame(gameId) async {
    final response = await http.delete(Uri.parse('${widget.mainUrl}/$gameId'),headers: {'Authorization' : 'Bearer ${await AuthManager.getToken()}'});
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game forfeited')),
      );
    }
  }

  Future<void> _refreshGames() async {
    setState(() {
      futureGames = _loadGames();
    });
  }

  Future<void> _logOut() async {
    await AuthManager.clearUserData();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const LoginPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _getUserName();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Battleships",
        style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshGames(),
          ),
        ],
      ),
      drawer: HamburgerMenu(
        selected: _selectedIndex, 
        changeSelection: _changeSelection, 
        toggleSelection: _toggleSelection,
        logOut: _logOut,
        username: userName, showComplete: _showComplete,
        onTap: (String ai) {
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Game(addGame: _addGame,ai: ai);
            }
          ),
        );},
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureGames,
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var snapFilter = snapshot.data!.where((e) =>_showComplete ?  e['status']==1 || e['status']==2 : e['status']==0 || e['status']==3).toList();
            return ListView.builder(
              itemCount: snapFilter.length,
              itemBuilder: (context, index) {
                final post = snapFilter[index];
                return Dismissible(
                  direction: _showComplete ? DismissDirection.none : DismissDirection.horizontal,
                  key: Key(post['id'].toString()),
                  onDismissed: _showComplete ? null : (_) {
                    snapshot.data!.remove(snapFilter[index]);
                    snapFilter.removeAt(index);
                    _deleteGame(post['id']);
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  
                  child: ListTile(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return GameView(mainUrl: widget.mainUrl, onTap: (){
                              _refreshGames();
                            }, gameId: post['id'],);
                          }
                        ),
                      );
                    },
                    leading: Text(post['status'] == 0 ? '#${post['id']} Waiting for opponent' : '#${post['id']} ${post['player1']} vs ${post['player2']}', style: const TextStyle(fontSize: 15),),
                    trailing: Text(post['status'] == 0 ? 'matchmaking' : post['turn']==0 ? post['position'] == post['status'] ? 'gameWon' : 'gameLost' : post['turn'] == post['position'] ? 'myTurn' : 'opponentTurn'),
                  ),);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

}

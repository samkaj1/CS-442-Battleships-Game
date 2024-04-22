import 'dart:convert';
import 'package:battleships/models/gamemodel.dart';
import 'package:battleships/utils/authmanager.dart';
import 'package:battleships/views/square.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameView extends StatefulWidget{

  final VoidCallback onTap;
  final String mainUrl;
  final int gameId;

  const GameView({super.key, required this.mainUrl,required this.onTap, required this.gameId});


  Future<GameModel> getGame(gameId) async {
    final response = await http.get(Uri.parse('$mainUrl/$gameId'),headers: {'Authorization' : 'Bearer ${await AuthManager.getToken()}'});
    final game = json.decode(response.body);
    return GameModel.fromJson(game);
  }

  Future<dynamic> putGame(int gameId,String shot) async {
    final response = await http.put(Uri.parse('$mainUrl/$gameId'),body: jsonEncode({
      'shot': shot
    }),
    headers: {
      'Content-Type': 'application/json',
      'Authorization' : 'Bearer ${await AuthManager.getToken()}'});
    final games = json.decode(response.body);
    return games;
  }

  @override
  State createState() => GameView2();
}


class GameView2 extends State<GameView> {
  Future<GameModel>? futureGame;

  @override
  void initState() {
    super.initState();
    _getGame();
  }

  Future<void> _getGame() async {
    setState(() {
      futureGame = widget.getGame(widget.gameId);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Game',
        style: TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body : FutureBuilder<GameModel>(
        future: futureGame,
        initialData: null,
        builder: (context, snapshot) {
          var game = snapshot.data!;
          if (snapshot.hasData) {
            Set shot = {};
            return Column(
                children: [
                  Row(
                    children: List.generate(6, (index) => Square(isGame: false, isCount: game.battleships.toSet(), isSelected: false,index: index ==0 ? 0 : 48+index,) ),
                  ),
                  for(int i=0;i<5;i++)
                    Row(
                      children: List.generate(6, (index) => Square(wreck: game.wrecks.toSet(),sunks: game.sunk.toSet(),shots: game.shots.toSet(),shot: shot, isGame: false, alpha: 65+i, isCount: game.battleships.toSet(), isSelected: false,index: index==0 ? 65+i : index)),
                    ),
                  ElevatedButton(
                    onPressed: game.turn != game.position || game.status==1 || game.status==2 ? null : () async {
                      print("submit");
                      widget.onTap();
                      var games = await widget.putGame(game.id, shot.elementAt(0));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: games['sunk_ship'] ? const Text('Ship sunk!') : const Text('No Enemy Ship was Hit')),
                      );
                      _getGame();
                      widget.onTap();
                      if(game.sunk.length==4 && games['sunk_ship']) {
                        showDialog(
                          context: context, 
                          builder: (context)=>AlertDialog(
                            title: const Text('Game Over'),
                            content: const Text('You Win!'),
                            actions: [
                              TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('OK'))
                            ],
                          ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Submit'),
                  ),
                      
                ],
              );
          }else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
    );
  }
}
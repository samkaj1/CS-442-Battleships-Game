import 'package:battleships/views/square.dart';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {

  final void Function(Set battleships,String ai) addGame;
  final String ai;

  const Game({super.key, required this.addGame, required this.ai});

  @override
  State createState() => Game2();
}


class Game2 extends State<Game> {

  var colors = List.generate(6, (_) => List.generate(6,(_) => false));
  var isSelected = List.generate(6, (_) => List.generate(6,(_) => false));
  var isCount = <dynamic>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place ships'),
      ),
      body: Column(
        children: [
          Row(
            children: List.generate(6, (index) => Square(isGame: true, isCount: isCount, isSelected: isSelected[0][index],index: index ==0 ? 0 : 48+index,) ),
          ),
          Row(
            children: List.generate(6, (index) => Square(isGame: true, alpha: 65, isCount: isCount, isSelected: isSelected[1][index],index: index==0 ? 65 : index)),
          ),
          Row(
            children: List.generate(6, (index) => Square(isGame: true, alpha: 66, isCount: isCount, isSelected: isSelected[2][index],index: index==0 ? 66 : index)),
          ),
          Row(
            children: List.generate(6, (index) => Square(isGame: true, alpha: 67, isCount: isCount, isSelected: isSelected[3][index],index: index==0 ? 67 : index)),
          ),
          Row(
            children: List.generate(6, (index) => Square(isGame: true, alpha: 68, isCount: isCount, isSelected: isSelected[4][index],index: index==0 ? 68 : index)),
          ),
          Row(
            children: List.generate(6, (index) => Square(isGame: true, alpha: 69, isCount: isCount, isSelected: isSelected[5][index],index: index==0 ? 69 : index)),
          ),
          ElevatedButton(
            onPressed: () {
             if(isCount.length<5){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You must place five ships')),
              );
             }else {
              Navigator.pop(context);
              String k = "[\"${isCount.join("\", \"")}\"]";
              print(k);
              widget.addGame(isCount,widget.ai);
             }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          )
          
        ],
      ),
    );
  }

}
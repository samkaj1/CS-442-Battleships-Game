import 'package:flutter/material.dart';

class Square extends StatefulWidget {
  
  bool isSelected;
  int index;
  Set isCount;
  int? alpha;
  bool isGame;
  Set? shot;
  Set? shots;
  Set? sunks;
  Set? wreck;

  Square({
    super.key,
    this.shots,
    this.sunks,
    this.wreck,
    required this.isSelected,
    required this.index,
    required this.isCount,
    this.alpha,
    required this.isGame,
    this.shot});

  @override
  State createState() => SquareUnit();
}

class SquareUnit extends State<Square> {

  bool color = false;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
              onHover: (isHover){
                if(widget.index<6) {
                  setState(() {
                    color = !color;
                  });
                }
              },
              onTap: (){
                if(widget.index<6 && (widget.sunks==null || widget.sunks!.length < 5 && widget.wreck!.length < 5 && !widget.shots!.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))){
                  setState(() {
                    if(widget.isSelected == true){
                      widget.isSelected = !widget.isSelected;
                      widget.isGame ?
                      widget.isCount.remove(String.fromCharCode(widget.alpha!)+widget.index.toString()) :
                      widget.shot!.remove(String.fromCharCode(widget.alpha!)+widget.index.toString());
                    }else if((widget.isGame && widget.isCount.length<5 )||( !widget.isGame && widget.shot!.isEmpty)) {
                      widget.isSelected = !widget.isSelected;
                      widget.isGame ?
                      widget.isCount.add(String.fromCharCode(widget.alpha!)+widget.index.toString()) :
                      widget.shot!.add(String.fromCharCode(widget.alpha!)+widget.index.toString());
                    }
                  });
                }
              },
              child: Container(
                color: color ? widget.isSelected ? widget.isGame ? Colors.yellow[400] : Colors.red[500] : Colors.grey[300]: widget.isSelected ? widget.isGame? Colors.blue : Colors.red[300] : Colors.grey[50],
                height:  ((MediaQuery.of(context).size.height ~/ 7) - 7).toDouble(),
                width:  ((MediaQuery.of(context).size.width ~/ 6)).toDouble(),
                child: Center( child : (widget.alpha!=null && !widget.isGame) ? Row ( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(widget.index>6)
                      Text(String.fromCharCode(widget.index)),
                    if(widget.isCount.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))
                      const Icon(IconData(0xefc2, fontFamily: 'MaterialIcons'))
                    else if(widget.wreck!.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))
                      const ImageIcon(AssetImage('assets/bubbles.png')),
                    if(widget.sunks!.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))
                      const ImageIcon(AssetImage('assets/explosion.png'))
                    else if(widget.shots!.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))
                      const ImageIcon(AssetImage('assets/bomb.png')),
                  ]) : 
                Text(widget.index<6 ?  "" : String.fromCharCode(widget.index))),
              ),
            ) ;
  }
  
}
class GameModel {
  int id;
  String player1;
  String player2;
  int position;
  List<String> battleships;
  List<String> shots;
  int status;
  List<String> sunk;
  int turn;
  List<String> wrecks;

  GameModel({
    required this.id,
    required this.player1,
    required this.player2,
    required this.position,
    required this.battleships,
    required this.shots,
    required this.status,
    required this.sunk,
    required this.turn,
    required this.wrecks,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return GameModel(
      id: json['id'],
      player1: json['player1'],
      player2: json['player2'],
      position: json['position'],
      battleships: List<String>.from(json['ships']),
      shots: List<String>.from(json['shots']),
      status: json['status'],
      sunk: List<String>.from(json['sunk']),
      turn: json['turn'],
      wrecks: List<String>.from(json['wrecks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player1': player1,
      'player2': player2,
      'position': position,
      'battleships': battleships,
      'shots': shots,
      'status': status,
      'sunk': sunk,
      'turn': turn,
      'wrecks': wrecks,
    };
  }
}

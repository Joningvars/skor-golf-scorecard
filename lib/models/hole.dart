class Hole {
  final int number;
  final int par;
  final int whiteTee;
  final int yellowTee;
  final int blueTee;
  final int redTee;
  final int handicap;

  Hole({
    required this.yellowTee,
    required this.handicap,
    required this.blueTee,
    required this.redTee,
    required this.whiteTee,
    required this.number,
    required this.par,
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'par': par,
      'whiteTee': whiteTee,
      'yellowTee': yellowTee,
      'blueTee': blueTee,
      'redTee': redTee,
      'handicap': handicap,
    };
  }

  factory Hole.fromJson(Map<String, dynamic> json) {
    return Hole(
      number: json['number'],
      par: json['par'],
      whiteTee: json['whiteTee'],
      yellowTee: json['yellowTee'],
      blueTee: json['blueTee'],
      redTee: json['redTee'],
      handicap: json['handicap'],
    );
  }
}

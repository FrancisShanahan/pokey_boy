class PokerCard {
  final CardSuit suit;
  final CardRank rank;

  const PokerCard({required this.suit, required this.rank});

  @override
  String toString() {
    return '${rank.symbol}${suit.symbol}';
  }

  // Get card image file name
  String get imageName {
    String rankStr = rank.toString().split('.').last.toLowerCase();
    String suitStr = suit.toString().split('.').last.toLowerCase();
    return '${rankStr}_of_$suitStr';
  }
}

enum CardSuit {
  hearts('♥'),
  diamonds('♦'),
  clubs('♣'),
  spades('♠');

  final String symbol;
  const CardSuit(this.symbol);
}

enum CardRank {
  two('2'),
  three('3'),
  four('4'),
  five('5'),
  six('6'),
  seven('7'),
  eight('8'),
  nine('9'),
  ten('10'),
  jack('J'),
  queen('Q'),
  king('K'),
  ace('A');

  final String symbol;
  const CardRank(this.symbol);
  
  int get value {
    switch (this) {
      case CardRank.two: return 2;
      case CardRank.three: return 3;
      case CardRank.four: return 4;
      case CardRank.five: return 5;
      case CardRank.six: return 6;
      case CardRank.seven: return 7;
      case CardRank.eight: return 8;
      case CardRank.nine: return 9;
      case CardRank.ten: return 10;
      case CardRank.jack: return 11;
      case CardRank.queen: return 12;
      case CardRank.king: return 13;
      case CardRank.ace: return 14;
    }
  }
}

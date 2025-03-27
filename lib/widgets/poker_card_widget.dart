import 'package:flutter/material.dart';
import '../models/card.dart';

class PokerCardWidget extends StatelessWidget {
  final PokerCard card;
  final double width;
  final double height;

  const PokerCardWidget({
    super.key,
    required this.card,
    this.width = 60,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRed = card.suit == CardSuit.hearts || card.suit == CardSuit.diamonds;
    final Color cardColor = isRed ? Colors.red : Colors.black;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51), // 0.2 opacity = 51 alpha
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          // Top left rank and suit
          Positioned(
            top: 4,
            left: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.rank.symbol,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cardColor,
                  ),
                ),
                Text(
                  card.suit.symbol,
                  style: TextStyle(
                    fontSize: 16,
                    color: cardColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Center suit
          Center(
            child: Text(
              card.suit.symbol,
              style: TextStyle(
                fontSize: 32,
                color: cardColor,
              ),
            ),
          ),
          
          // Bottom right rank and suit (upside down)
          Positioned(
            bottom: 4,
            right: 4,
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees in radians
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.rank.symbol,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cardColor,
                    ),
                  ),
                  Text(
                    card.suit.symbol,
                    style: TextStyle(
                      fontSize: 16,
                      color: cardColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PokerHandWidget extends StatelessWidget {
  final List<PokerCard> cards;
  final double cardWidth;
  final double cardHeight;
  final double cardSpacing;

  const PokerHandWidget({
    super.key,
    required this.cards,
    this.cardWidth = 60,
    this.cardHeight = 90,
    this.cardSpacing = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(cards.length, (index) {
        return Padding(
          padding: EdgeInsets.only(right: index < cards.length - 1 ? cardSpacing : 0),
          child: PokerCardWidget(
            card: cards[index],
            width: cardWidth,
            height: cardHeight,
          ),
        );
      }),
    );
  }
}

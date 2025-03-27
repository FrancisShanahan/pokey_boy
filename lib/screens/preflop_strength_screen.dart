import 'package:flutter/material.dart';
import '../models/hand_ranking.dart';
import '../models/card.dart';
import '../widgets/poker_card_widget.dart';

class PreflopStrengthScreen extends StatefulWidget {
  const PreflopStrengthScreen({super.key});

  @override
  State<PreflopStrengthScreen> createState() => _PreflopStrengthScreenState();
}

class _PreflopStrengthScreenState extends State<PreflopStrengthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<int, List<StartingHand>> _handsByTier = getHandsByTier();
  int _selectedTier = 1;

  @override
  void initState() {
    super.initState();
    // Get the number of tiers
    final tierCount = _handsByTier.keys.length;
    _tabController = TabController(length: tierCount, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTier = _handsByTier.keys.elementAt(_tabController.index);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sort the tier keys
    final sortedTiers = _handsByTier.keys.toList()..sort();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-Flop Hand Strength'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: sortedTiers.map((tier) {
            return Tab(
              text: 'Tier $tier${tier == 1 ? ' (Best)' : tier == sortedTiers.last ? ' (Worst)' : ''}',
            );
          }).toList(),
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withAlpha(179), // 0.7 opacity = 179 alpha
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: sortedTiers.map((tier) {
          final hands = _handsByTier[tier]!;
          return ListView.builder(
            itemCount: hands.length,
            itemBuilder: (context, index) {
              final hand = hands[index];
              return HandCard(hand: hand);
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Tier $_selectedTier Hands: ${_getTierDescription(_selectedTier)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  String _getTierDescription(int tier) {
    switch (tier) {
      case 1:
        return 'Premium hands - play from any position';
      case 2:
        return 'Strong hands - play from most positions';
      case 3:
        return 'Playable hands - better from middle/late positions';
      case 4:
        return 'Speculative hands - best from late position';
      default:
        if (tier >= 5 && tier <= 7) {
          return 'Marginal hands - play cautiously from late position only';
        } else {
          return 'Weak hands - generally fold these pre-flop';
        }
    }
  }
}

class HandCard extends StatelessWidget {
  final StartingHand hand;

  const HandCard({super.key, required this.hand});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(
          hand.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          'Win Rate: ${hand.winPercentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: _getColorForWinRate(hand.winPercentage),
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _buildHandVisualization(hand.name),
                ),
                const SizedBox(height: 16),
                Text(
                  hand.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recommended Strategy:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hand.strategy,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildPositionAdvice(hand.tier),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandVisualization(String handName) {
    // Parse the hand name to determine the cards to display
    List<PokerCard> cards = [];
    
    if (handName.contains('Pocket')) {
      // Handle pocket pairs
      String rankSymbol = '';
      if (handName.contains('Aces')) {
        rankSymbol = 'A';
      } else if (handName.contains('Kings')) {
        rankSymbol = 'K';
      } else if (handName.contains('Queens')) {
        rankSymbol = 'Q';
      } else if (handName.contains('Jacks')) {
        rankSymbol = 'J';
      } else if (handName.contains('Tens')) {
        rankSymbol = 'T';
      } else {
        // Extract number from the name (e.g., "Pocket Nines" -> 9)
        final numbers = {
          'Twos': '2', 'Threes': '3', 'Fours': '4', 'Fives': '5',
          'Sixes': '6', 'Sevens': '7', 'Eights': '8', 'Nines': '9'
        };
        
        for (var entry in numbers.entries) {
          if (handName.contains(entry.key)) {
            rankSymbol = entry.value;
            break;
          }
        }
      }
      
      if (rankSymbol.isNotEmpty) {
        CardRank rank = _getCardRankFromSymbol(rankSymbol);
        cards = [
          PokerCard(suit: CardSuit.spades, rank: rank),
          PokerCard(suit: CardSuit.hearts, rank: rank),
        ];
      }
    } else if (handName.contains('-')) {
      // Handle non-pair hands like "Ace-King Suited"
      final parts = handName.split('-');
      if (parts.length >= 2) {
        String firstRankSymbol = _getFirstLetterOrDigit(parts[0]);
        String secondRankSymbol = _getFirstLetterOrDigit(parts[1]);
        
        CardRank firstRank = _getCardRankFromSymbol(firstRankSymbol);
        CardRank secondRank = _getCardRankFromSymbol(secondRankSymbol);
        
        if (handName.contains('Suited')) {
          // Both cards have the same suit
          cards = [
            PokerCard(suit: CardSuit.spades, rank: firstRank),
            PokerCard(suit: CardSuit.spades, rank: secondRank),
          ];
        } else {
          // Different suits for offsuit hands
          cards = [
            PokerCard(suit: CardSuit.spades, rank: firstRank),
            PokerCard(suit: CardSuit.hearts, rank: secondRank),
          ];
        }
      }
    } else if (handName.contains('7-2 Offsuit')) {
      // Special case for 7-2 offsuit
      cards = [
        PokerCard(suit: CardSuit.spades, rank: CardRank.seven),
        PokerCard(suit: CardSuit.hearts, rank: CardRank.two),
      ];
    }
    
    if (cards.isEmpty) {
      return const Text('Card visualization not available');
    }
    
    return PokerHandWidget(cards: cards);
  }
  
  String _getFirstLetterOrDigit(String text) {
    if (text.contains('Ace')) {
      return 'A';
    } else if (text.contains('King')) {
      return 'K';
    } else if (text.contains('Queen')) {
      return 'Q';
    } else if (text.contains('Jack')) {
      return 'J';
    } else if (text.contains('Ten')) {
      return 'T';
    }
    
    // Try to find a digit
    final RegExp digitRegex = RegExp(r'\d');
    final match = digitRegex.firstMatch(text);
    if (match != null) {
      return match.group(0)!;
    }
    
    return '';
  }
  
  CardRank _getCardRankFromSymbol(String symbol) {
    switch (symbol) {
      case 'A': return CardRank.ace;
      case 'K': return CardRank.king;
      case 'Q': return CardRank.queen;
      case 'J': return CardRank.jack;
      case 'T': return CardRank.ten;
      case '9': return CardRank.nine;
      case '8': return CardRank.eight;
      case '7': return CardRank.seven;
      case '6': return CardRank.six;
      case '5': return CardRank.five;
      case '4': return CardRank.four;
      case '3': return CardRank.three;
      case '2': return CardRank.two;
      default: return CardRank.ace; // Default to ace
    }
  }

  Color _getColorForWinRate(double winRate) {
    if (winRate >= 75) {
      return Colors.green.shade800;
    } else if (winRate >= 65) {
      return Colors.green.shade600;
    } else if (winRate >= 55) {
      return Colors.amber.shade700;
    } else if (winRate >= 45) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildPositionAdvice(int tier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Position Advice:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPositionIndicator('Early', tier <= 2),
            const SizedBox(width: 8),
            _buildPositionIndicator('Middle', tier <= 3),
            const SizedBox(width: 8),
            _buildPositionIndicator('Late', tier <= 5),
          ],
        ),
      ],
    );
  }

  Widget _buildPositionIndicator(String position, bool isPlayable) {
    return Chip(
      label: Text(position),
      backgroundColor: isPlayable ? Colors.green.shade100 : Colors.red.shade100,
      labelStyle: TextStyle(
        color: isPlayable ? Colors.green.shade800 : Colors.red.shade800,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

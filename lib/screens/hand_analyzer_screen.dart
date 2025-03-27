import 'package:flutter/material.dart';
import '../models/card.dart';
import '../widgets/poker_card_widget.dart';

class HandAnalyzerScreen extends StatefulWidget {
  const HandAnalyzerScreen({super.key});

  @override
  State<HandAnalyzerScreen> createState() => _HandAnalyzerScreenState();
}

class _HandAnalyzerScreenState extends State<HandAnalyzerScreen> {
  PokerCard? _firstCard;
  PokerCard? _secondCard;
  bool _showResults = false;
  
  // Track which card is being selected (0 for first, 1 for second)
  int _currentSelectionIndex = 0;
  
  // Track which properties have been selected for the current card
  CardRank? _selectedRank;
  CardSuit? _selectedSuit;

  void _selectRank(CardRank rank) {
    setState(() {
      _selectedRank = rank;
      
      // If both rank and suit are selected, confirm the card
      if (_selectedSuit != null) {
        _confirmCardSelection();
      }
    });
  }

  void _selectSuit(CardSuit suit) {
    setState(() {
      _selectedSuit = suit;
      
      // If both rank and suit are selected, confirm the card
      if (_selectedRank != null) {
        _confirmCardSelection();
      }
    });
  }

  void _confirmCardSelection() {
    if (_selectedRank == null || _selectedSuit == null) {
      return;
    }
    
    setState(() {
      final newCard = PokerCard(rank: _selectedRank!, suit: _selectedSuit!);
      
      if (_currentSelectionIndex == 0) {
        _firstCard = newCard;
        _currentSelectionIndex = 1;
      } else {
        _secondCard = newCard;
        // Automatically show analysis when second card is complete
        _showResults = true;
      }
      
      // Reset selection for next card
      _selectedRank = null;
      _selectedSuit = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with instructions - only show when not in results mode
                if (!_showResults)
                  Text(
                    _currentSelectionIndex == 0 
                        ? 'Select your first card:' 
                        : 'Select your second card:',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (!_showResults)
                  const SizedBox(height: 16),
                
                // Selected cards display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCardPlaceholder(0),
                    const SizedBox(width: 16),
                    _buildCardPlaceholder(1),
                  ],
                ),
                
                // Reset button when analysis is shown
                if (_showResults)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showResults = false;
                            _firstCard = null;
                            _secondCard = null;
                            _currentSelectionIndex = 0;
                            _selectedRank = null;
                            _selectedSuit = null;
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Select Different Cards'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Card selection area
                if (!_showResults) ...[
                  const Text(
                    'Select Card Rank:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRankSelector(),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Select Card Suit:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSuitSelector(),
                ],
                
                const SizedBox(height: 24),
                
                if (_showResults) _buildAnalysisResults(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardPlaceholder(int index) {
    final card = index == 0 ? _firstCard : _secondCard;
    final isCurrentSelection = _currentSelectionIndex == index && !_showResults;
    
    if (card != null) {
      return PokerCardWidget(
        card: card,
        width: 125,
        height: 187,
      );
    }
    
    return GestureDetector(
      onTap: () {
        if (!_showResults && _firstCard != null && index == 1) {
          // Allow tapping on second card only if first card is selected
          setState(() {
            _currentSelectionIndex = 1;
          });
        } else if (!_showResults && index == 0) {
          // Always allow tapping on first card when not in results mode
          setState(() {
            _currentSelectionIndex = 0;
          });
        }
      },
      child: Container(
        width: 125,
        height: 187,
        decoration: BoxDecoration(
          color: isCurrentSelection ? Colors.grey.shade200 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isCurrentSelection ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: isCurrentSelection ? 2 : 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.style, 
                size: 36,
                color: isCurrentSelection 
                    ? (index == 0 ? Colors.red.shade700 : Colors.blue.shade700)
                    : Colors.grey.shade600,
              ),
              const SizedBox(height: 8),
              Text(
                index == 0 ? 'First Card' : 'Second Card',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isCurrentSelection 
                      ? (index == 0 ? Colors.red.shade700 : Colors.blue.shade700)
                      : Colors.grey.shade800,
                  fontSize: isCurrentSelection ? 18 : 16,
                  fontWeight: isCurrentSelection ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              if (isCurrentSelection)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isCurrentSelection && index == 0)
                        ? Colors.red.shade50
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Select Below',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: (isCurrentSelection && index == 0)
                          ? Colors.red.shade700
                          : Colors.blue.shade700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CardRank.values.map((rank) {
        return _buildRankButton(rank);
      }).toList(),
    );
  }

  Widget _buildRankButton(CardRank rank) {
    final isSelected = _selectedRank == rank;
    
    return ElevatedButton(
      onPressed: () {
        _selectRank(rank);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: isSelected 
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade100,
        foregroundColor: isSelected
            ? Colors.white
            : Colors.grey.shade800,
        elevation: isSelected ? 4 : 2,
        shadowColor: isSelected 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
            : Colors.grey.withOpacity(0.3),
      ),
      child: Text(
        rank.symbol,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSuitSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: CardSuit.values.map((suit) {
        return _buildSuitButton(suit);
      }).toList(),
    );
  }

  Widget _buildSuitButton(CardSuit suit) {
    final bool isRed = suit == CardSuit.hearts || suit == CardSuit.diamonds;
    final bool isSelected = _selectedSuit == suit;
    final Color suitColor = isRed ? Colors.red.shade700 : Colors.black;
    
    return ElevatedButton(
      onPressed: () {
        _selectSuit(suit);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: isSelected 
            ? (isRed ? Colors.red.shade50 : Colors.grey.shade200)
            : Colors.grey.shade100,
        elevation: isSelected ? 4 : 2,
        shadowColor: isSelected 
            ? (isRed ? Colors.red.withOpacity(0.3) : Colors.black.withOpacity(0.2))
            : Colors.grey.withOpacity(0.3),
      ),
      child: Text(
        suit.symbol,
        style: TextStyle(
          fontSize: 24,
          color: isSelected 
              ? (isRed ? Colors.red.shade700 : Colors.black)
              : (isRed ? Colors.red.shade400 : Colors.grey.shade700),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAnalysisResults() {
    if (_firstCard == null || _secondCard == null) {
      return const SizedBox.shrink();
    }
    
    // Get hand name and type
    final handName = _getHandName();
    final winPercentage = _getWinPercentage();
    final strategy = _getStrategy();
    final handTier = _getHandTier();
    final outs = _calculateOuts();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hand name and type
        Text(
          handName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Win percentage and Hand Tier in the same row
        Row(
          children: [
            // Win percentage
            const Text(
              'Win %: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$winPercentage%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getColorForWinRate(winPercentage),
              ),
            ),
            
            const SizedBox(width: 24),
            
            // Hand tier
            const Text(
              'Tier: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$handTier ${_getTierDescription(handTier)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getColorForTier(handTier),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Outs information
        Row(
          children: [
            const Text(
              'Potential Outs: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$outs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getColorForOuts(outs),
              ),
            ),
            const SizedBox(width: 8),
            _buildOutsQualityIndicator(outs),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Outs are cards that can improve your hand on the flop, turn, or river',
              child: const Icon(Icons.info_outline, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Strategy
        const Text(
          'Recommended Strategy:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            strategy,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Outs explanation
        const Text(
          'Outs Explanation:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _getOutsExplanation(),
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Position advice
        _buildPositionAdvice(handTier),
      ],
    );
  }

  String _getHandName() {
    if (_firstCard == null || _secondCard == null) return '';
    
    // Sort cards by rank (higher first)
    final cards = [_firstCard!, _secondCard!];
    cards.sort((a, b) => b.rank.value.compareTo(a.rank.value));
    
    final firstRank = cards[0].rank;
    final secondRank = cards[1].rank;
    
    // Check if it's a pair
    if (firstRank == secondRank) {
      return 'Pocket ${_getPluralRankName(firstRank)}';
    }
    
    // Not a pair
    final suited = cards[0].suit == cards[1].suit;
    return '${_getRankName(firstRank)}-${_getRankName(secondRank)} ${suited ? 'Suited' : 'Offsuit'}';
  }

  String _getRankName(CardRank rank) {
    switch (rank) {
      case CardRank.ace: return 'Ace';
      case CardRank.king: return 'King';
      case CardRank.queen: return 'Queen';
      case CardRank.jack: return 'Jack';
      case CardRank.ten: return 'Ten';
      case CardRank.nine: return 'Nine';
      case CardRank.eight: return 'Eight';
      case CardRank.seven: return 'Seven';
      case CardRank.six: return 'Six';
      case CardRank.five: return 'Five';
      case CardRank.four: return 'Four';
      case CardRank.three: return 'Three';
      case CardRank.two: return 'Two';
    }
  }

  String _getPluralRankName(CardRank rank) {
    switch (rank) {
      case CardRank.ace: return 'Aces';
      case CardRank.king: return 'Kings';
      case CardRank.queen: return 'Queens';
      case CardRank.jack: return 'Jacks';
      case CardRank.ten: return 'Tens';
      case CardRank.nine: return 'Nines';
      case CardRank.eight: return 'Eights';
      case CardRank.seven: return 'Sevens';
      case CardRank.six: return 'Sixes';
      case CardRank.five: return 'Fives';
      case CardRank.four: return 'Fours';
      case CardRank.three: return 'Threes';
      case CardRank.two: return 'Twos';
    }
  }

  double _getWinPercentage() {
    if (_firstCard == null || _secondCard == null) return 0.0;
    
    final handName = _getHandName();
    
    // Lookup the win percentage based on the hand name
    // These are approximate values based on common poker statistics
    if (handName.contains('Pocket Aces')) return 85.2;
    if (handName.contains('Pocket Kings')) return 82.4;
    if (handName.contains('Pocket Queens')) return 80.1;
    if (handName.contains('Pocket Jacks')) return 77.5;
    if (handName.contains('Pocket Tens')) return 75.1;
    if (handName.contains('Pocket Nines')) return 72.1;
    if (handName.contains('Pocket Eights')) return 69.1;
    if (handName.contains('Pocket Sevens')) return 66.2;
    if (handName.contains('Pocket Sixes')) return 63.3;
    if (handName.contains('Pocket Fives')) return 60.3;
    if (handName.contains('Pocket Fours')) return 57.7;
    if (handName.contains('Pocket Threes')) return 54.6;
    if (handName.contains('Pocket Twos')) return 52.0;
    
    if (handName.contains('Ace-King Suited')) return 67.0;
    if (handName.contains('Ace-Queen Suited')) return 63.5;
    if (handName.contains('Ace-Jack Suited')) return 62.1;
    if (handName.contains('Ace-Ten Suited')) return 59.9;
    if (handName.contains('King-Queen Suited')) return 60.3;
    if (handName.contains('King-Jack Suited')) return 59.2;
    
    if (handName.contains('Ace-King Offsuit')) return 65.4;
    if (handName.contains('Ace-Queen Offsuit')) return 61.5;
    if (handName.contains('Ace-Jack Offsuit')) return 59.9;
    if (handName.contains('Ace-Ten Offsuit')) return 58.0;
    if (handName.contains('King-Queen Offsuit')) return 58.4;
    if (handName.contains('King-Jack Offsuit')) return 57.1;
    
    // Default for other hands based on card ranks and whether they're suited
    final cards = [_firstCard!, _secondCard!];
    cards.sort((a, b) => b.rank.value.compareTo(a.rank.value));
    
    final highRank = cards[0].rank.value;
    final lowRank = cards[1].rank.value;
    final suited = cards[0].suit == cards[1].suit;
    final connected = (highRank - lowRank) <= 3;
    
    if (suited && connected) return 55.0;
    if (suited) return 50.0;
    if (connected) return 47.0;
    if (highRank >= CardRank.queen.value) return 45.0;
    
    // Low unconnected offsuit cards
    return 40.0;
  }

  int _getHandTier() {
    final percentage = _getWinPercentage();
    
    if (percentage >= 80.0) return 1;
    if (percentage >= 70.0) return 2;
    if (percentage >= 60.0) return 3;
    if (percentage >= 55.0) return 4;
    if (percentage >= 50.0) return 5;
    if (percentage >= 45.0) return 6;
    if (percentage >= 40.0) return 7;
    return 8;
  }

  String _getStrategy() {
    final handName = _getHandName();
    final tier = _getHandTier();
    
    // Specific strategies for premium hands
    if (handName.contains('Pocket Aces') || handName.contains('Pocket Kings')) {
      return 'Raise from any position. Consider slow-playing in early position if the table is aggressive. Re-raise if someone raises before you.';
    }
    
    if (handName.contains('Pocket Queens') || handName.contains('Pocket Jacks')) {
      return 'Raise from any position, but be prepared to fold if the flop contains an Ace or King and there\'s significant action.';
    }
    
    if (handName.contains('Ace-King')) {
      return 'Raise from any position. This hand has strong potential but needs to improve on the flop to remain strong.';
    }
    
    // General strategies based on tier
    switch (tier) {
      case 1:
        return 'Premium hand - Raise from any position. Re-raise if someone raises before you.';
      case 2:
        return 'Strong hand - Raise from any position. Be cautious if the flop contains overcards.';
      case 3:
        return 'Solid hand - Raise from middle to late position. Call from early position.';
      case 4:
        return 'Speculative hand - Raise from late position. Call from middle position. Consider folding from early position.';
      case 5:
        return 'Marginal hand - Play cautiously from late position only. Consider folding from early and middle positions.';
      case 6:
        return 'Weak hand - Only play from late position if the pot is unraised. Fold from early and middle positions.';
      default:
        return 'Very weak hand - Generally fold pre-flop unless you\'re in the big blind and there\'s no raise.';
    }
  }

  String _getTierDescription(int tier) {
    switch (tier) {
      case 1:
        return '(Premium)';
      case 2:
        return '(Strong)';
      case 3:
        return '(Solid)';
      case 4:
        return '(Playable)';
      case 5:
        return '(Marginal)';
      default:
        return '(Weak)';
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

  Color _getColorForTier(int tier) {
    switch (tier) {
      case 1:
        return Colors.green.shade800;
      case 2:
        return Colors.green.shade600;
      case 3:
        return Colors.green.shade400;
      case 4:
        return Colors.amber.shade700;
      case 5:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Widget _buildOutsQualityIndicator(int outs) {
    String quality;
    Color backgroundColor;
    Color textColor;
    IconData icon;
    
    if (outs >= 15) {
      quality = 'EXCELLENT';
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
      icon = Icons.thumb_up;
    } else if (outs >= 10) {
      quality = 'GOOD';
      backgroundColor = Colors.lightGreen.shade100;
      textColor = Colors.lightGreen.shade800;
      icon = Icons.thumb_up_outlined;
    } else if (outs >= 6) {
      quality = 'MEDIUM';
      backgroundColor = Colors.amber.shade100;
      textColor = Colors.amber.shade800;
      icon = Icons.thumbs_up_down;
    } else if (outs >= 3) {
      quality = 'POOR';
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
      icon = Icons.thumb_down_outlined;
    } else {
      quality = 'BAD';
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
      icon = Icons.thumb_down;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            quality,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionAdvice(int tier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Position Advice:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPositionIndicator('Early', tier <= 2),
            const SizedBox(width: 8),
            _buildPositionIndicator('Middle', tier <= 4),
            const SizedBox(width: 8),
            _buildPositionIndicator('Late', tier <= 6),
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

  int _calculateOuts() {
    if (_firstCard == null || _secondCard == null) return 0;
    
    final cards = [_firstCard!, _secondCard!];
    cards.sort((a, b) => b.rank.value.compareTo(a.rank.value));
    
    final highRank = cards[0].rank;
    final lowRank = cards[1].rank;
    final suited = cards[0].suit == cards[1].suit;
    final isPair = highRank == lowRank;
    final rankDiff = highRank.value - lowRank.value;
    
    // Calculate outs based on hand type
    if (isPair) {
      // For a pair, we have 2 outs to make a set
      return 2;
    } else if (suited) {
      if (rankDiff == 1) {
        // Suited connector: Straight flush potential (9 outs) + pair potential (6 outs)
        return 15;
      } else if (rankDiff <= 3) {
        // Suited with gap: Flush potential (9 outs) + straight potential (6 outs) + pair potential (6 outs)
        return 21;
      } else {
        // Suited non-connector: Flush potential (9 outs) + pair potential (6 outs)
        return 15;
      }
    } else if (rankDiff == 1) {
      // Offsuit connector: Straight potential (8 outs) + pair potential (6 outs)
      return 14;
    } else if (rankDiff <= 3) {
      // Offsuit with gap: Straight potential (4-8 outs depending on gap) + pair potential (6 outs)
      return 10 + (3 - rankDiff) * 2;
    } else {
      // Offsuit non-connector: Only pair potential (6 outs)
      return 6;
    }
  }
  
  String _getOutsExplanation() {
    if (_firstCard == null || _secondCard == null) return '';
    
    final cards = [_firstCard!, _secondCard!];
    cards.sort((a, b) => b.rank.value.compareTo(a.rank.value));
    
    final highRank = cards[0].rank;
    final lowRank = cards[1].rank;
    final suited = cards[0].suit == cards[1].suit;
    final isPair = highRank == lowRank;
    final rankDiff = highRank.value - lowRank.value;
    
    final List<String> explanations = [];
    
    if (isPair) {
      explanations.add('• 2 outs to make a set (hitting the remaining two cards of your pair)');
    } else {
      explanations.add('• 6 outs to pair either of your hole cards (3 cards for each rank)');
      
      if (suited) {
        explanations.add('• 9 outs to make a flush draw (9 more cards of your suit)');
      }
      
      if (rankDiff == 1) {
        explanations.add('• 8 outs for a straight draw (4 cards to complete the straight on either end)');
      } else if (rankDiff <= 3) {
        explanations.add('• ${4 + (3 - rankDiff) * 2} potential straight outs (cards that could give you a straight draw)');
      }
    }
    
    explanations.add('\nRemember: The flop will reveal 3 community cards, giving you more information about your potential outs.');
    
    return explanations.join('\n');
  }
  
  Color _getColorForOuts(int outs) {
    if (outs >= 15) {
      return Colors.green.shade700;
    } else if (outs >= 10) {
      return Colors.green.shade500;
    } else if (outs >= 6) {
      return Colors.amber.shade700;
    } else {
      return Colors.orange;
    }
  }
}

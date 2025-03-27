import 'card.dart';

class StartingHand {
  final String name;
  final String description;
  final double winPercentage;
  final int tier;
  final List<PokerCard>? exampleCards;
  final String strategy;

  const StartingHand({
    required this.name,
    required this.description,
    required this.winPercentage,
    required this.tier,
    this.exampleCards,
    required this.strategy,
  });
}

// Pre-flop hand rankings based on common poker strategy
final List<StartingHand> preflopHandRankings = [
  StartingHand(
    name: 'Pocket Aces (AA)',
    description: 'The best starting hand in Hold\'em',
    winPercentage: 85.2,
    tier: 1,
    strategy: 'Raise from any position. Re-raise if someone raises before you.',
  ),
  StartingHand(
    name: 'Pocket Kings (KK)',
    description: 'Second best starting hand',
    winPercentage: 82.4,
    tier: 1,
    strategy: 'Raise from any position. Be cautious if an Ace appears on the flop.',
  ),
  StartingHand(
    name: 'Pocket Queens (QQ)',
    description: 'Third best starting hand',
    winPercentage: 80.1,
    tier: 1,
    strategy: 'Raise from any position. Be cautious if an Ace or King appears on the flop.',
  ),
  StartingHand(
    name: 'Ace-King Suited (AKs)',
    description: 'The best non-pair starting hand',
    winPercentage: 67.0,
    tier: 1,
    strategy: 'Raise from any position. Strong drawing hand with flush and straight potential.',
  ),
  StartingHand(
    name: 'Pocket Jacks (JJ)',
    description: 'Strong pair but vulnerable to overcards',
    winPercentage: 77.5,
    tier: 2,
    strategy: "Raise from any position, but be prepared to fold if the flop contains an Ace, King, or Queen and there's significant action.",
  ),
  StartingHand(
    name: 'Ace-King Offsuit (AKo)',
    description: 'Strong drawing hand',
    winPercentage: 65.4,
    tier: 2,
    strategy: 'Raise from any position. Needs to improve on the flop to remain strong.',
  ),
  StartingHand(
    name: 'Ace-Queen Suited (AQs)',
    description: 'Strong Ace with flush potential',
    winPercentage: 63.5,
    tier: 2,
    strategy: 'Raise from early and middle positions. Call or re-raise from late position.',
  ),
  StartingHand(
    name: 'Pocket Tens (TT)',
    description: 'Medium pair with good potential',
    winPercentage: 75.1,
    tier: 2,
    strategy: 'Raise from any position, but be cautious if the flop contains cards higher than Ten.',
  ),
  StartingHand(
    name: 'Ace-Jack Suited (AJs)',
    description: 'Decent Ace with flush potential',
    winPercentage: 62.1,
    tier: 3,
    strategy: 'Raise from middle to late position. Call from early position.',
  ),
  StartingHand(
    name: 'Pocket Nines (99)',
    description: 'Medium pair',
    winPercentage: 72.1,
    tier: 3,
    strategy: 'Raise from middle to late position. Call or fold from early position depending on table dynamics.',
  ),
  StartingHand(
    name: 'King-Queen Suited (KQs)',
    description: 'Connected high cards with flush potential',
    winPercentage: 60.3,
    tier: 3,
    strategy: 'Raise from middle to late position. Call from early position.',
  ),
  StartingHand(
    name: 'Ace-Ten Suited (ATs)',
    description: 'Decent Ace with flush potential',
    winPercentage: 59.9,
    tier: 3,
    strategy: 'Raise from late position. Call from middle position. Consider folding from early position.',
  ),
  StartingHand(
    name: 'Ace-Queen Offsuit (AQo)',
    description: 'Strong Ace but vulnerable',
    winPercentage: 61.5,
    tier: 3,
    strategy: 'Raise from middle to late position. Call from early position.',
  ),
  StartingHand(
    name: 'Pocket Eights (88)',
    description: 'Medium-small pair',
    winPercentage: 69.1,
    tier: 4,
    strategy: 'Raise from late position. Call from middle position. Consider folding from early position.',
  ),
  StartingHand(
    name: 'King-Jack Suited (KJs)',
    description: 'Connected high cards with flush potential',
    winPercentage: 59.2,
    tier: 4,
    strategy: 'Raise from late position. Call from middle position. Consider folding from early position.',
  ),
  StartingHand(
    name: '7-2 Offsuit',
    description: 'The worst starting hand in Hold\'em',
    winPercentage: 32.0,
    tier: 10,
    strategy: 'Fold from any position unless you want to bluff or play for fun.',
  ),
];

// Group hands by tier for easier display
Map<int, List<StartingHand>> getHandsByTier() {
  final Map<int, List<StartingHand>> handsByTier = {};
  
  for (var hand in preflopHandRankings) {
    if (!handsByTier.containsKey(hand.tier)) {
      handsByTier[hand.tier] = [];
    }
    handsByTier[hand.tier]!.add(hand);
  }
  
  return handsByTier;
}

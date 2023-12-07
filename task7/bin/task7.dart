import 'dart:io';

sealed class Hand {
  final List<int> cards;
  final int bid;

  Hand({required this.cards, required this.bid});

  int get value;

  @override
  String toString() => '{cards: $cards, bid: $bid}';
}

class FiveOfAKind extends Hand {
  FiveOfAKind({required super.cards, required super.bid});

  @override
  int get value => 6;
}

class FourOfAKind extends Hand {
  FourOfAKind({required super.cards, required super.bid});

  @override
  int get value => 5;
}

class FullHouse extends Hand {
  FullHouse({required super.cards, required super.bid});

  @override
  int get value => 4;
}

class ThreeOfAKind extends Hand {
  ThreeOfAKind({required super.cards, required super.bid});

  @override
  int get value => 3;
}

class TwoPair extends Hand {
  TwoPair({required super.cards, required super.bid});

  @override
  int get value => 2;
}

class OnePair extends Hand {
  OnePair({required super.cards, required super.bid});

  @override
  int get value => 1;
}

class HighCard extends Hand {
  HighCard({required super.cards, required super.bid});

  @override
  int get value => 0;
}

Hand parseHand(String line) {
  final [String cardsStr, String bidStr] = line.split(' ');
  final int bid = int.parse(bidStr);
  final Map<int, int> cardCounts = {};
  final List<int> individualCards = cardsStr
      .split('')
      .map((String card) => switch (card) {
            '2' => 0,
            '3' => 1,
            '4' => 2,
            '5' => 3,
            '6' => 4,
            '7' => 5,
            '8' => 6,
            '9' => 7,
            'T' => 8,
            'J' => 9,
            'Q' => 10,
            'K' => 11,
            'A' => 12,
            _ => throw Exception('unknown card'),
          })
      .toList();
  for (int individualCard in individualCards) {
    cardCounts.putIfAbsent(individualCard, () => 0);
    int currentCount = cardCounts[individualCard]!;
    cardCounts[individualCard] = currentCount + 1;
  }
  final List<int> countedCards = cardCounts.values.toList()..sort();
  // print(countedCards);
  return switch (countedCards) {
    [1, 1, 1, 1, 1] => HighCard(cards: individualCards, bid: bid),
    [1, 1, 1, 2] => OnePair(cards: individualCards, bid: bid),
    [1, 2, 2] => TwoPair(cards: individualCards, bid: bid),
    [1, 1, 3] => ThreeOfAKind(cards: individualCards, bid: bid),
    [2, 3] => FullHouse(cards: individualCards, bid: bid),
    [1, 4] => FourOfAKind(cards: individualCards, bid: bid),
    [5] => FiveOfAKind(cards: individualCards, bid: bid),
    _ => throw Exception('unknown hand'),
  };
}

void main(List<String> arguments) {
  final List<String> lines = loadInputData(arguments.first);
  final List<Hand> hands = lines.map((String line) => parseHand(line)).toList()
    ..sort((Hand a, Hand b) {
      bool areTheSameType = a.value == b.value;
      if (!areTheSameType) {
        return a.value.compareTo(b.value);
      }
      for (int i = 0; i < 5; i++) {
        if (a.cards[i] != b.cards[i]) {
          return a.cards[i].compareTo(b.cards[i]);
        }
      }
      throw Exception('failed to sort');
    });
  int winnings = 0;
  for (int i = 0; i < hands.length; i++) {
    winnings += hands[i].bid * (i + 1);
  }
  print(winnings);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

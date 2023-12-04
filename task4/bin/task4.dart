import 'dart:io';

class Card {
  final int id;
  final Set<int> winningNumbers;
  final Set<int> cardNumbers;
  late final int numberOfMatches;

  Card({
    required this.id,
    required this.winningNumbers,
    required this.cardNumbers,
  }) {
    final Set<int> matches = winningNumbers.intersection(cardNumbers);
    numberOfMatches = matches.length;
  }

  @override
  String toString() {
    return 'Card{id: $id, numberOfMatches: $numberOfMatches}';
  }
}

void main(List<String> arguments) {
  final List<String> lines = loadInputData(arguments.first);
  final List<Card> cards = parseCards(lines);
  final Map<Card, int> cardCount = {for (Card card in cards) card: 1};
  for (Card card in cards) {
    final int numberOfCopies = cardCount[card]!;
    for (int i = 0; i < card.numberOfMatches; i++) {
      final Card cardToCopy = cards[card.id + i];
      final int currentCount = cardCount[cardToCopy]!;
      cardCount[cardToCopy] = currentCount + numberOfCopies;
    }
  }
  print(cardCount.values.fold<int>(0, (sum, element) => sum + element));
}

List<Card> parseCards(List<String> lines) {
  final List<Card> cards = [];
  for (String line in lines) {
    final [String cardIdStr, String rest] = line.split(': ');
    final int id = int.parse(cardIdStr.split(' ').last);
    final [String winningNumbersStr, cardNumbersStr] = rest.split(' | ');
    final Iterable<String> unparsedWinningNumbers = winningNumbersStr.split(' ')
      ..removeWhere((element) => element.isEmpty);
    final Iterable<String> unparsedCardNumbers = cardNumbersStr.split(' ')..removeWhere((element) => element.isEmpty);
    final Set<int> winningNumbers = unparsedWinningNumbers.map((String number) => int.parse(number)).toSet();
    final Set<int> cardNumbers = unparsedCardNumbers.map((String number) => int.parse(number)).toSet();
    cards.add(Card(id: id, winningNumbers: winningNumbers, cardNumbers: cardNumbers));
  }
  return cards;
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

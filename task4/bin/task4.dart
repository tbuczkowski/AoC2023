import 'dart:io';
import 'dart:math';

class Card {
  final int id;
  final Set<int> winningNumbers;
  final Set<int> cardNumbers;

  Card({
    required this.id,
    required this.winningNumbers,
    required this.cardNumbers,
  });
}

void main(List<String> arguments) {
  final List<String> lines = loadInputData(arguments.first);
  final List<Card> cards = parseCards(lines);
  int sumOfPoints = 0;
  for (Card card in cards) {
    final Set<int> matches = card.winningNumbers.intersection(card.cardNumbers);
    final int numberOfMatches = matches.length;
    sumOfPoints += pow(2, numberOfMatches - 1).toInt();
  }
  print(sumOfPoints);
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

import 'dart:io';

final Map<String, int> gameConstraints = {
  'red': 12,
  'green': 13,
  'blue': 14,
};

int validGames = 0;

final RegExp handParser = RegExp(r'((\d+ green)|(\d+ blue)|(\d+ red))(,|$|;)');
final RegExp gameIdParser = RegExp(r'Game (\d+):');

(int, List<(int, int, int)>) parseGame(String game) {
  final int gameId = int.parse(gameIdParser.firstMatch(game)!.group(1)!);
  final List<String> hands = game.split(';');
  final List<(int, int, int)> parsedHands = [];
  for (String hand in hands) {
    final List<RegExpMatch> matches = handParser.allMatches(hand).toList();
    final Map<String, int> handMap = {
      'red': 0,
      'green': 0,
      'blue': 0,
    };
    for (RegExpMatch match in matches) {
      final String color = match.group(1)!;
      final [String quantity, String colorName] = color.split(' ');
      final int quantityInt = int.parse(quantity);
      handMap[colorName] = quantityInt;
    }
    parsedHands.add((handMap['red']!, handMap['green']!, handMap['blue']!));
  }
  return (gameId, parsedHands);
}

void main(List<String> arguments) {
  final List<String> input = loadInputData(arguments.first);
  for (String game in input) {
    final (int, List<(int, int, int)>) parsedGame = parseGame(game);
    bool validGame = true;
    for ((int, int, int) hand in parsedGame.$2) {
      if (hand.$1 > gameConstraints['red']! ||
          hand.$2 > gameConstraints['green']! ||
          hand.$3 > gameConstraints['blue']!) {
        validGame = false;
        break;
      }
    }
    if (validGame) {
      validGames += parsedGame.$1;
    }
  }
  print(validGames);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

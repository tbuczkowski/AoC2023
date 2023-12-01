import 'dart:io';

final RegExp numbers = RegExp(r'(?=([1-9]|one|two|three|four|five|six|seven|eight|nine))');

int _computeLine(String line) {
  String? firstChar, lastChar;
  final int length = line.length;
  for (int i = 0; i < length; i++) {
    final String forwardChar = line[i];
    final String backwardChar = line[length - i - 1];
    if (firstChar == null && forwardChar.contains(numbers)) {
      firstChar = forwardChar;
    }
    if (lastChar == null && backwardChar.contains(numbers)) {
      lastChar = backwardChar;
    }
    if (firstChar != null && lastChar != null) {
      break;
    }
  }
  return int.parse(firstChar! + lastChar!);
}

int _mapToDigit(String match) => switch (match) {
      '1' || 'one' => 1,
      '2' || 'two' => 2,
      '3' || 'three' => 3,
      '4' || 'four' => 4,
      '5' || 'five' => 5,
      '6' || 'six' => 6,
      '7' || 'seven' => 7,
      '8' || 'eight' => 8,
      '9' || 'nine' => 9,
      _ => throw Exception('Invalid number'),
    };

int _computeLine2(String line) {
  final matches = numbers.allMatches(line).toList();
  final int firstDigit = _mapToDigit(matches.first.group(1)!);
  final int lastDigit = _mapToDigit(matches.last.group(1)!);
  final int sum = firstDigit * 10 + lastDigit;
  print(sum);
  return sum;
}

Future<void> main(List<String> arguments) async {
  final List<String> input = loadInputData(arguments.first);
  final List<int> results = input.map((e) => _computeLine2(e)).toList();
  print(results.fold<int>(0, (int sum, int element) => sum + element));
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

import 'dart:io';

int computeHash(String word) {
  int currentValue = 0;
  for (int ascii in word.codeUnits) {
    currentValue += ascii;
    currentValue *= 17;
    currentValue %= 256;
  }
  return currentValue;
}

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);
  final List<String> input = lines.first.split(',');
  int sum = 0;
  for (String word in input) {
    sum += computeHash(word);
  }
  print(sum);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

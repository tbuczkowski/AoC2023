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

final List<List<({String key, int focalLength})>> boxes = [];

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);
  final List<String> input = lines.first.split(',');
  for (int i = 0; i < 256; i++) {
    boxes.add([]);
  }
  for (String instruction in input) {
    if (instruction.contains('-')) {
      final String key = instruction.split('-').first;
      final List<({String key, int focalLength})> box = boxes[computeHash(key)];
      final int index = box.indexWhere((({String key, int focalLength}) element) => element.key == key);
      if (index == -1) {
        continue;
      }
      box.removeAt(index);
      continue;
    }
    if (instruction.contains('=')) {
      final [String key, String focalLengthStr] = instruction.split('=');
      final List<({String key, int focalLength})> box = boxes[computeHash(key)];
      final int index = box.indexWhere((({String key, int focalLength}) element) => element.key == key);
      final lens = (key: key, focalLength: int.parse(focalLengthStr));
      if (index == -1) {
        box.add(lens);
      } else {
        box[index] = lens;
      }
    }
  }
  int sum = 0;
  for (int i = 0; i < 256; i++) {
    final List<({String key, int focalLength})> box = boxes[i];
    for (int j = 0; j < box.length; j++) {
      final ({String key, int focalLength}) lens = box[j];
      sum += (i + 1) * (j + 1) * lens.focalLength;
    }
  }
  print(sum);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

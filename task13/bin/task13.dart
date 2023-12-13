import 'dart:io';
import 'dart:math';

int computeAxis(List<String> axis) {
  int maxValue = 0;
  int index = 0;
  for (int i = 1; i < axis.length; i++) {
    int currentValue = 0;
    final int maxOffset = min(i, axis.length - i);
    for (int j = 0; j < maxOffset; j++) {
      final bool matchFound = axis[i + j] == axis[i - j - 1];
      if (matchFound) {
        currentValue++;
        continue;
      }
      break;
    }
    if (currentValue < maxOffset) {
      continue;
    }
    if (currentValue > maxValue) {
      maxValue = currentValue;
      index = i;
    }
  }
  return index;
}

int computeValue(List<String> horizontal, List<String> vertical) {
  // print(horizontal);
  // print(vertical);
  final int horizontalValue = computeAxis(horizontal);
  final int verticalValue = computeAxis(vertical);
  return verticalValue > horizontalValue ? verticalValue : horizontalValue * 100;
}

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);

  List<String> horizontal = [];
  List<String> vertical = [];
  int sum = 0;
  for (String line in lines) {
    if (line.isNotEmpty) {
      horizontal.add(line);
    }
    if (line.isEmpty) {
      final int xSize = horizontal.first.length;
      for (int i = 0; i < xSize; i++) {
        final StringBuffer buffer = StringBuffer();
        for (int j = 0; j < horizontal.length; j++) {
          buffer.write(horizontal[j][i]);
        }
        vertical.add(buffer.toString());
      }

      final int val = computeValue(horizontal, vertical);
      print(val);
      sum += val;
      horizontal = [];
      vertical = [];
    }
  }
  final int xSize = horizontal.first.length;
  for (int i = 0; i < xSize; i++) {
    final StringBuffer buffer = StringBuffer();
    for (int j = 0; j < horizontal.length; j++) {
      buffer.write(horizontal[j][i]);
    }
    vertical.add(buffer.toString());
  }

  final int val = computeValue(horizontal, vertical);
  print(val);
  sum += val;
  print(sum);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

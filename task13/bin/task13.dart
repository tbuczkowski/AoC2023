import 'dart:io';
import 'dart:math';

int computeAxis(List<String> axis) {
  int maxValue = 0;
  int index = 0;
  for (int i = 1; i < axis.length; i++) {
    int currentValue = 0;
    final int maxOffset = min(i, axis.length - i);
    bool hadDifference = false;
    for (int j = 0; j < maxOffset; j++) {
      final String line1 = axis[i + j];
      final String line2 = axis[i - j - 1];
      final bool matchFound = line1 == line2;
      if (matchFound) {
        currentValue++;
        continue;
      }
      int diff = 0;
      for (int k = 0; k < line1.length; k++) {
        if (line1[k] == line2[k]) {
          continue;
        }
        diff++;
        if (diff > 1) {
          break;
        }
      }
      if (diff == 1) {
        hadDifference = true;
        // print((i, j, axis));
        currentValue++;
        continue;
      }
      break;
    }
    if (currentValue < maxOffset) {
      continue;
    }
    if (hadDifference && currentValue > maxValue) {
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
  // print((horizontalValue, verticalValue));
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
      // print(val);
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

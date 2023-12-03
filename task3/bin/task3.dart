import 'dart:io';

late final List<List<String>> _grid;
final List<Sequence> _sequences = [];
final List<(int, int)> _gears = [];

class Sequence {
  final (int, int) startCoords;
  final int length;

  late final int value;
  late final bool isPartNumber;

  Sequence(this.startCoords, this.length) {
    String combinedDigits = '';
    for (int i = 0; i < length; i++) {
      final String digit = _grid[startCoords.$1][startCoords.$2 + i];
      combinedDigits += digit;
    }
    value = int.parse(combinedDigits);
    isPartNumber = _checkIfPartNumber();
  }

  bool _checkIfPartNumber() {
    for (int i = 0; i < length; i++) {
      final (int, int) currentCoords = (startCoords.$1, startCoords.$2 + i);
      for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
          final (int, int) neighborCoords = (currentCoords.$1 + x, currentCoords.$2 + y);
          if (neighborCoords.$1 >= _grid.length ||
              neighborCoords.$1 < 0 ||
              neighborCoords.$2 >= _grid[0].length ||
              neighborCoords.$2 < 0) {
            continue;
          }
          final String neighborSymbol = _grid[neighborCoords.$1][neighborCoords.$2];
          if (['.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(neighborSymbol)) {
            continue;
          }
          return true;
        }
      }
    }
    return false;
  }

  @override
  String toString() {
    return '{startCoords: $startCoords, length: $length, value: $value, isPartNumber:$isPartNumber}';
  }
}

void main(List<String> arguments) {
  final List<String> input = loadInputData(arguments.first);
  _grid = input.map((String line) => line.split('').toList(growable: false)).toList(growable: false);
  for (int y = 0; y < _grid.length; y++) {
    final List<String> row = _grid[y];
    int? sequenceStart;
    for (int x = 0; x < row.length; x++) {
      final String symbol = row[x];
      if (x == row.length - 1 && ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(symbol)) {
        if (sequenceStart != null) {
          _sequences.add(Sequence((y, sequenceStart!), x - sequenceStart! + 1));
          sequenceStart = null;
        }
      }
      if (x == row.length - 1 && symbol == '*') {
        _gears.add((y, x));
      }
      (switch (symbol) {
        '.' => () {
            if (sequenceStart != null) {
              _sequences.add(Sequence((y, sequenceStart!), x - sequenceStart!));
              sequenceStart = null;
            }
          },
        '0' || '1' || '2' || '3' || '4' || '5' || '6' || '7' || '8' || '9' => () {
            sequenceStart ??= x;
          },
        _ => () {
            if (sequenceStart != null) {
              _sequences.add(Sequence((y, sequenceStart!), x - sequenceStart!));
              sequenceStart = null;
            }
            if (symbol == '*') {
              _gears.add((y, x));
            }
          },
      })();
    }
  }
  _sequences.removeWhere((Sequence sequence) => !sequence.isPartNumber);
  // final int result = _sequences.fold(0, (int sum, Sequence sequence) => sum + sequence.value);
  int gearRatiosSum = 0;
  for ((int, int) gearCoords in _gears) {
    gearRatiosSum += _findGearRatio(gearCoords);
  }
  print(gearRatiosSum);
}

Sequence? _findSequenceForCoords((int, int) coords) {
  try {
    return _sequences.firstWhere(
      (Sequence sequence) =>
          coords.$1 == sequence.startCoords.$1 &&
          coords.$2 >= sequence.startCoords.$2 &&
          coords.$2 < sequence.startCoords.$2 + sequence.length,
    );
  } catch (e) {
    return null;
  }
}

int _findGearRatio((int, int) gearCoords) {
  final Set<Sequence> adjacentSequences = {};
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      final (int, int) neighborCoords = (gearCoords.$1 + x, gearCoords.$2 + y);
      if (neighborCoords.$1 >= _grid.length ||
          neighborCoords.$1 < 0 ||
          neighborCoords.$2 >= _grid[0].length ||
          neighborCoords.$2 < 0) {
        continue;
      }
      final Sequence? adjacentSequence = _findSequenceForCoords(neighborCoords);
      if (adjacentSequence != null) {
        adjacentSequences.add(adjacentSequence);
      }
    }
  }
  if (adjacentSequences.length == 1) {
    return 0;
  }
  return adjacentSequences.fold(1, (int result, Sequence sequence) {
    return result * sequence.value;
  });
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

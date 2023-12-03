import 'dart:io';

late final List<List<String>> _grid;
final List<Sequence> _sequences = [];

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
  int globalSum = 0;
  for (int y = 0; y < _grid.length; y++) {
    final List<String> row = _grid[y];
    int rowSum = 0;
    String rowSumStr = '';
    int? sequenceStart;
    for (int x = 0; x < row.length; x++) {
      final String symbol = row[x];
      if (x == row.length - 1 && ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(symbol)) {
        if (sequenceStart != null) {
          _sequences.add(Sequence((y, sequenceStart!), x - sequenceStart! + 1));
          rowSum += _sequences.last.isPartNumber ? _sequences.last.value : 0;
          rowSumStr += '+${_sequences.last.isPartNumber ? _sequences.last.value : 0}';
          sequenceStart = null;
        }
      }
      (switch (symbol) {
        '.' => () {
            if (sequenceStart != null) {
              _sequences.add(Sequence((y, sequenceStart!), x - sequenceStart!));
              rowSum += _sequences.last.isPartNumber ? _sequences.last.value : 0;
              rowSumStr += '+${_sequences.last.isPartNumber ? _sequences.last.value : 0}';
              sequenceStart = null;
            }
          },
        '0' || '1' || '2' || '3' || '4' || '5' || '6' || '7' || '8' || '9' => () {
            sequenceStart ??= x;
          },
        _ => () {
            if (sequenceStart != null) {
              _sequences.add(Sequence((y, sequenceStart!), x - sequenceStart!));
              rowSum += _sequences.last.isPartNumber ? _sequences.last.value : 0;
              sequenceStart = null;
            }
          },
      })();
    }
    globalSum += rowSum;
    print(rowSumStr + '=' + rowSum.toString());
  }
  _sequences.removeWhere((Sequence sequence) => !sequence.isPartNumber);
  // print(_sequences.fold<String>('', (String previousValue, element) => previousValue + element.toString() + '\n'));
  final int result = _sequences.fold(0, (int sum, Sequence sequence) => sum + sequence.value);
  print(result);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

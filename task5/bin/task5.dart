import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

class MapRecord {
  final int source;
  final int destination;
  final int length;

  MapRecord({
    required this.source,
    required this.destination,
    required this.length,
  });

  bool fitsThisRecord(int number) {
    if (number < source || number >= (source + length)) {
      return false;
    }
    return true;
  }

  int convert(int number) => number + (destination - source);
}

late final List<int> seeds;
final List<List<MapRecord>> maps = [];

void parseInput(List<String> lines) {
  final String seedsStr = lines.first.split(': ').last;
  seeds = seedsStr.split(' ').map((String number) => int.parse(number)).toList();
  lines.removeAt(0);
  lines.removeAt(0);
  int currentMapIndex = 0;
  maps.add([]);
  for (String line in lines) {
    if (line.contains('map:')) {
      continue;
    }
    if (line.isEmpty) {
      currentMapIndex++;
      maps.add([]);
      continue;
    }
    final [int destination, int source, int length] =
        line.split(' ').map((String number) => int.parse(number)).toList();
    maps[currentMapIndex].add(MapRecord(source: source, destination: destination, length: length));
  }
}

void main(List<String> arguments) {
  final List<String> lines = loadInputData(arguments.first);
  parseInput(lines);
  final List<int> locations = [];
  for (int seed in seeds) {
    int currentNumber = seed;
    for (List<MapRecord> map in maps) {
      final MapRecord? fittingRecord = map.firstWhereOrNull((MapRecord record) => record.fitsThisRecord(currentNumber));
      currentNumber = fittingRecord?.convert(currentNumber) ?? currentNumber;
    }
    locations.add(currentNumber);
  }
  print(locations.reduce(min));
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

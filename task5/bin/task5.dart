import 'dart:io';

import 'package:collection/collection.dart';

class SeedRange {
  final int start;
  final int length;

  SeedRange({
    required this.start,
    required this.length,
  });
}

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

final List<SeedRange> seedRanges = [];
final List<List<MapRecord>> maps = [];

void parseInput(List<String> lines) {
  final String seedsStr = lines.first.split(': ').last;
  final List<int> seeds = seedsStr.split(' ').map((String number) => int.parse(number)).toList();
  for (int i = 0; i < seeds.length; i += 2) {
    seedRanges.add(SeedRange(start: seeds[i], length: seeds[i + 1]));
  }
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
  int minLocation = 999999999999;
  for (SeedRange seedRange in seedRanges) {
    print('processing seed range ${seedRange.start}');
    for (int i = 0; i < seedRange.length; i++) {
      int currentNumber = seedRange.start + i;
      for (List<MapRecord> map in maps) {
        final MapRecord? fittingRecord =
            map.firstWhereOrNull((MapRecord record) => record.fitsThisRecord(currentNumber));
        currentNumber = fittingRecord?.convert(currentNumber) ?? currentNumber;
      }
      if (currentNumber < minLocation) {
        minLocation = currentNumber;
      }
    }
  }
  print(minLocation);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

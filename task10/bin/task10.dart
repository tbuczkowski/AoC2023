import 'dart:io';
import 'dart:math';

import 'package:compute/compute.dart';

Map<(int, int), int> computeDistanceMap((List<List<String>> grid, (int, int) start, (int, int) direction) param) {
  Map<(int, int), int> map = {};
  (int, int) previousCoords = param.$2;
  (int, int) currentCoords = param.$3;
  String currentSymbol = param.$1[currentCoords.$1][currentCoords.$2];
  int distance = 0;
  while (currentSymbol != 'S') {
    distance++;
    final List<(int, int)> nextSteps = switch (currentSymbol) {
      '|' => [
          (currentCoords.$1 - 1, currentCoords.$2),
          (currentCoords.$1 + 1, currentCoords.$2),
        ],
      '-' => [
          (currentCoords.$1, currentCoords.$2 - 1),
          (currentCoords.$1, currentCoords.$2 + 1),
        ],
      'L' => [
          (currentCoords.$1 - 1, currentCoords.$2),
          (currentCoords.$1, currentCoords.$2 + 1),
        ],
      'J' => [
          (currentCoords.$1 - 1, currentCoords.$2),
          (currentCoords.$1, currentCoords.$2 - 1),
        ],
      '7' => [
          (currentCoords.$1 + 1, currentCoords.$2),
          (currentCoords.$1, currentCoords.$2 - 1),
        ],
      'F' => [
          (currentCoords.$1 + 1, currentCoords.$2),
          (currentCoords.$1, currentCoords.$2 + 1),
        ],
      _ => throw '',
    };
    nextSteps.remove(previousCoords);
    map[currentCoords] = distance;
    previousCoords = currentCoords;
    currentCoords = nextSteps.first;
    currentSymbol = param.$1[currentCoords.$1][currentCoords.$2];
  }
  return map;
}

void main(List<String> arguments) async {
  List<List<String>> grid = [];
  final List<String> lines = loadInputData(arguments.first);
  late int startX;
  late int startY;
  for (String line in lines) {
    grid.add(line.split(''));
    if (grid.last.contains('S')) {
      startY = grid.length - 1;
      startX = grid.last.indexOf('S');
    }
  }
  final List<(int, int)> startDirections = [];
  if (grid[startY - 1][startX] case '7' || '|' || 'F') {
    startDirections.add((startY - 1, startX));
  }
  if (grid[startY][startX + 1] case '-' || 'J' || '7') {
    startDirections.add((startY, startX + 1));
  }
  if (grid[startY + 1][startX] case 'J' || '|' || 'L') {
    startDirections.add((startY + 1, startX));
  }
  if (grid[startY][startX - 1] case '-' || 'F' || 'L') {
    startDirections.add((startY, startX - 1));
  }
  final List<Future<Map<(int, int), int>>> futures = [];
  futures.add(compute(computeDistanceMap, (grid, (startY, startX), (startDirections.first))));
  futures.add(compute(computeDistanceMap, (grid, (startY, startX), (startDirections.last))));
  final List<Map<(int, int), int>> results = await Future.wait(futures);
  int maxDistance = 0;
  for ((int, int) step in results.first.keys) {
    final int value1 = results.first[step]!;
    final int value2 = results.last[step]!;
    final int m = min(value1, value2);
    if (m > maxDistance) {
      maxDistance = m;
    }
  }
  print(maxDistance);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

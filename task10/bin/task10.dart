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
  // futures.add(compute(computeDistanceMap, (grid, (startY, startX), (startDirections.last))));
  final Map<(int, int), int> results = await futures.first;
  final List<(int, int)> loop = results.keys.toList();
  loop.add((startY, startX));
  grid[startY][startX] = '-';
  final List<List<String>> grid2 = [
    for (int i = 0; i < grid.length * 2; i++) [for (int j = 0; j < grid.first.length * 2; j++) 'E']
  ];
  for (int y = 0; y < grid.length; y++) {
    for (int x = 0; x < grid.first.length; x++) {
      grid2[y * 2][x * 2] = grid[y][x];
    }
  }
  for ((int, int) coord in loop) {
    final String symbol = grid[coord.$1][coord.$2];
    grid2[coord.$1 * 2][coord.$2 * 2] = 'X';
    if (symbol == '|') {
      grid2[coord.$1 * 2 + 1][coord.$2 * 2] = 'X';
    } else if (symbol == '-') {
      grid2[coord.$1 * 2][coord.$2 * 2 + 1] = 'X';
    } else if (symbol == 'J') {
      // grid2[coord.$1 * 2 + 1][coord.$2 * 2] = 'X';
      // grid2[coord.$1 * 2 + 1][coord.$2 * 2 - 1] = 'X';
    } else if (symbol == 'F') {
      grid2[coord.$1 * 2][coord.$2 * 2 + 1] = 'X';
      grid2[coord.$1 * 2 + 1][coord.$2 * 2] = 'X';
    } else if (symbol == '7') {
      grid2[coord.$1 * 2 + 1][coord.$2 * 2] = 'X';
    } else if (symbol == 'L') {
      grid2[coord.$1 * 2][coord.$2 * 2 + 1] = 'X';
    }
  }

  final List<(int, int)> steps = [(0, 0)];
  while (steps.isNotEmpty) {
    final (int, int) step = steps.removeLast();
    grid2[step.$1][step.$2] = 'X';
    final String top = grid2[max(step.$1 - 1, 0)][step.$2];
    if (top != 'X' && step.$1 > 0) {
      steps.add((step.$1 - 1, step.$2));
    }
    final String bottom = grid2[min(step.$1 + 1, grid2.length - 1)][step.$2];
    if (bottom != 'X' && step.$1 < grid2.length - 1) {
      steps.add((step.$1 + 1, step.$2));
    }
    final String left = grid2[step.$1][max(step.$2 - 1, 0)];
    if (left != 'X' && step.$2 > 0) {
      steps.add((step.$1, step.$2 - 1));
    }
    final String right = grid2[step.$1][min(step.$2 + 1, grid2.first.length - 1)];
    if (right != 'X' && step.$2 < grid2.first.length - 1) {
      steps.add((step.$1, step.$2 + 1));
    }
    // print(steps);
  }
  // for (final l in grid2) {
  //   print(l.reduce((value, element) => value + element));
  // }
  print(grid2.expand((element) => element).where((element) => element != 'E' && element != 'X').length);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

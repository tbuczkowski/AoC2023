import 'dart:io';

import 'package:collection/collection.dart';

List<List<String>> tiltNorth(List<List<String>> grid) {
  for (int y = 0; y < grid.length; y++) {
    for (int x = 0; x < grid.first.length; x++) {
      final String char = grid[y][x];
      if (char != 'O') {
        continue;
      }
      for (int i = 0; i < y; i++) {
        final int index = y - i - 1;
        if (grid[index][x] != '.') {
          break;
        }
        grid[index + 1][x] = '.';
        grid[index][x] = 'O';
      }
    }
  }
  return grid;
}

List<List<String>> tiltWest(List<List<String>> grid) {
  for (int y = 0; y < grid.length; y++) {
    for (int x = 0; x < grid.first.length; x++) {
      final String char = grid[y][x];
      if (char != 'O') {
        continue;
      }
      for (int i = 0; i < x; i++) {
        final int index = x - i - 1;
        if (grid[y][index] != '.') {
          break;
        }
        grid[y][index + 1] = '.';
        grid[y][index] = 'O';
      }
    }
  }
  return grid;
}

List<List<String>> tiltSouth(List<List<String>> grid) {
  for (int y = grid.length - 1; y >= 0; y--) {
    for (int x = 0; x < grid.first.length; x++) {
      final String char = grid[y][x];
      if (char != 'O') {
        continue;
      }
      for (int i = 0; i < grid.length; i++) {
        final int index = y + i + 1;
        if (index >= grid.length || grid[index][x] != '.') {
          break;
        }
        grid[index - 1][x] = '.';
        grid[index][x] = 'O';
      }
    }
  }
  return grid;
}

List<List<String>> tiltEast(List<List<String>> grid) {
  for (int y = 0; y < grid.length; y++) {
    for (int x = grid.first.length - 1; x >= 0; x--) {
      final String char = grid[y][x];
      if (char != 'O') {
        continue;
      }
      for (int i = 0; i < grid.first.length; i++) {
        final int index = x + i + 1;
        if (index >= grid.first.length || grid[y][index] != '.') {
          break;
        }
        grid[y][index - 1] = '.';
        grid[y][index] = 'O';
      }
    }
  }
  return grid;
}

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);

  List<List<String>> grid = [];
  List<List<String>> originalGrid = [];
  int sum = 0;
  for (String line in lines) {
    grid.add(line.split(''));
    originalGrid.add(line.split(''));
  }
  final DeepCollectionEquality collectionEquality = DeepCollectionEquality();
  originalGrid = tiltEast(originalGrid);
  for (int i = 0; i < 1000; i++) {
    if (i % 5 == 0) {
      print(i);
    }
    grid = tiltNorth(grid);
    if (collectionEquality.equals(grid, originalGrid)) {
      print('cycleFound');
      print(i);
    }
    grid = tiltWest(grid);
    if (collectionEquality.equals(grid, originalGrid)) {
      print('cycleFound');
      print(i);
    }
    grid = tiltSouth(grid);
    if (collectionEquality.equals(grid, originalGrid)) {
      print('cycleFound');
      print(i);
    }
    grid = tiltEast(grid);
    if (collectionEquality.equals(grid, originalGrid)) {
      print('cycleFound');
      print(i);
    }
  }
  for (int i = 0; i < grid.length; i++) {
    final int multiplier = grid.length - i;
    sum += grid[i].where((element) => element == 'O').length * multiplier;
  }
  for (List<String> line in grid) {
    print(line.fold<String>("", (previousValue, element) => previousValue + element));
  }
  print(sum);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

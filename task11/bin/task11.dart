import 'dart:io';
import 'dart:math';

void main(List<String> arguments) async {
  final List<List<String>> grid = [];
  final List<String> lines = loadInputData(arguments.first);
  final int expansionFactor = 1000000;
  final List<int> rowsToExpand = [];
  int y = 0;
  for (String line in lines) {
    grid.add(line.split('').toList());
    if (grid.last.every((element) => element == '.')) {
      // grid.add([...grid.last]);
      rowsToExpand.add(y);
    }
    y++;
  }
  final List<int> colsToExpand = [];
  for (int x = 0; x < grid.first.length; x++) {
    bool onlyDots = true;
    for (int y = 0; y < grid.length; y++) {
      if (grid[y][x] != '.') {
        onlyDots = false;
        break;
      }
    }
    if (onlyDots) {
      colsToExpand.add(x);
    }
  }
  print(rowsToExpand);
  print(colsToExpand);
  // int colsAdded = 0;
  // for (int col in colsToExpand) {
  //   for (int y = 0; y < grid.length; y++) {
  //     grid[y].insert(col + colsAdded, '.');
  //   }
  //   colsAdded++;
  // }
  final List<({int y, int x})> galaxies = [];
  for (int y = 0; y < grid.length; y++) {
    for (int x = 0; x < grid.first.length; x++) {
      if (grid[y][x] == '#') {
        galaxies.add((y: y, x: x));
      }
    }
  }
  int distanceSum = 0;
  for (int i = 0; i < galaxies.length; i++) {
    ({int y, int x}) galaxy1 = galaxies[i];
    for (int j = i + 1; j < galaxies.length; j++) {
      ({int y, int x}) galaxy2 = galaxies[j];
      // print((i + 1, j + 1));
      // print((galaxy2.x - galaxy1.x + galaxy2.y - galaxy1.y).abs());
      final int expandedColsPassed = colsToExpand
          .where((element) => element > min(galaxy2.x, galaxy1.x) && element < max(galaxy2.x, galaxy1.x))
          .length;
      // print(expandedColsPassed);
      // if (galaxy1.x > galaxy2.x) {
      //   galaxy1 = (y: galaxy1.y, x: galaxy1.x - expandedColsPassed + expandedColsPassed * expansionFactor);
      // } else {
      //   galaxy2 = (y: galaxy2.y, x: galaxy2.x - expandedColsPassed + expandedColsPassed * expansionFactor);
      // }
      final int expandedRowsPassed = rowsToExpand
          .where((element) => element > min(galaxy2.y, galaxy1.y) && element < max(galaxy2.y, galaxy1.y))
          .length;
      // print(expandedRowsPassed);
      // if (galaxy1.y > galaxy2.y) {
      //   galaxy1 = (y: galaxy1.y - expandedRowsPassed + expandedRowsPassed * expansionFactor, x: galaxy1.x);
      // } else {
      //   galaxy2 = (y: galaxy2.y - expandedRowsPassed + expandedRowsPassed * expansionFactor, x: galaxy2.x);
      // }
      // print(galaxy1);
      // print(galaxy2);
      final int distance = (galaxy2.x - galaxy1.x).abs() -
          expandedColsPassed +
          (expandedColsPassed * expansionFactor) +
          (galaxy2.y - galaxy1.y).abs() -
          expandedRowsPassed +
          (expandedRowsPassed * expansionFactor);
      // print(distance);
      distanceSum += distance;
    }
  }
  print(distanceSum);

  // for (List<String> row in grid) {
  //   print(row.reduce((value, element) => value + element));
  // }
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

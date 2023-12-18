import 'dart:io';

import 'package:color/color.dart';

extension ColorExtension on String {
  Color toColor() {
    var hexColor = replaceAll("#", "");
    hexColor = hexColor.replaceAll("(", "");
    hexColor = hexColor.replaceAll(")", "");
    return HexColor(hexColor);
  }
}

typedef Coords = ({int x, int y});

List<List<Color?>> floodFill(List<List<Color?>> grid, Coords start) {
  final List<Coords> coordsToFill = [start];
  while (coordsToFill.isNotEmpty) {
    final Coords currentCoords = coordsToFill.removeLast();
    grid[currentCoords.y][currentCoords.x] = RgbColor.name('black');
    if (currentCoords.y - 1 > 0 && grid[currentCoords.y - 1][currentCoords.x] == null) {
      coordsToFill.add((x: currentCoords.x, y: currentCoords.y - 1));
    }
    if (currentCoords.y + 1 < grid.length && grid[currentCoords.y + 1][currentCoords.x] == null) {
      coordsToFill.add((x: currentCoords.x, y: currentCoords.y + 1));
    }
    if (currentCoords.x - 1 > 0 && grid[currentCoords.y][currentCoords.x - 1] == null) {
      coordsToFill.add((x: currentCoords.x - 1, y: currentCoords.y));
    }
    if (currentCoords.x + 1 < grid.first.length && grid[currentCoords.y][currentCoords.x + 1] == null) {
      coordsToFill.add((x: currentCoords.x + 1, y: currentCoords.y));
    }
  }
  return grid;
}

void main(List<String> arguments) async {
  Map<Coords, Color> nodes = {};
  final List<String> lines = loadInputData(arguments.first);
  Coords currentCoords = (x: 0, y: 0);
  int minX = 0;
  int minY = 0;
  int maxX = 0;
  int maxY = 0;
  for (String line in lines) {
    final [String direction, String distanceStr, String colorStr] = line.split(' ');
    final int distance = int.parse(distanceStr);
    final Color color = colorStr.toColor();
    for (int i = 0; i < distance; i++) {
      currentCoords = switch (direction) {
        'R' => (x: currentCoords.x + 1, y: currentCoords.y),
        'L' => (x: currentCoords.x - 1, y: currentCoords.y),
        'U' => (x: currentCoords.x, y: currentCoords.y - 1),
        'D' => (x: currentCoords.x, y: currentCoords.y + 1),
        _ => throw 'Error',
      };
      nodes[currentCoords] = color;
    }
    if (currentCoords.x < minX) {
      minX = currentCoords.x;
    }
    if (currentCoords.y < minY) {
      minY = currentCoords.y;
    }
    if (currentCoords.x > maxX) {
      maxX = currentCoords.x;
    }
    if (currentCoords.y > maxY) {
      maxY = currentCoords.y;
    }
  }
  final Map<Coords, Color> processedNodes =
      nodes.map((key, value) => MapEntry((x: key.x + minX.abs(), y: key.y + minY.abs()), value));
  List<List<Color?>> grid = List.generate(
      maxY + minY.abs() + 1, (y) => List.generate(maxX + minX.abs() + 1, (x) => processedNodes[(x: x, y: y)]));
  grid = floodFill(grid, (x: 100, y: 55));
  final int count = grid.fold<int>(
      0, (int sum, List<Color?> line) => sum + line.fold(0, (int sum, Color? color) => sum + (color == null ? 0 : 1)));
  for (List<Color?> line in grid) {
    print(line.fold<String>("", (String str, element) => str + (element == null ? '.' : '#')));
  }
  print(count);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

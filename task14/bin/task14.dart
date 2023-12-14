import 'dart:io';

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);

  List<List<String>> grid = [];
  int sum = 0;
  for (String line in lines) {
    grid.add(line.split(''));
  }
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
  for (int i = 0; i < grid.length; i++) {
    final int multiplier = grid.length - i;
    sum += grid[i].where((element) => element == 'O').length * multiplier;
  }
  print(sum);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

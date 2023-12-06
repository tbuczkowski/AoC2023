import 'dart:io';

int simulateRace(int time, int distanceToBeat) {
  int winningStrategies = 0;
  for (int i = 1; i < time - 1; i++) {
    final int distance = i * (time - i);
    if (distance > distanceToBeat) {
      winningStrategies++;
    }
  }
  return winningStrategies;
}

void main(List<String> arguments) {
  final [String timesStr, String distancesStr] = loadInputData(arguments.first);
  final List<int> times = timesStr
      .split(RegExp(r'Time:\s'))
      .last
      .split(' ')
      .where((String number) => number.isNotEmpty)
      .map((String number) => int.parse(number))
      .toList();
  final List<int> distances = distancesStr
      .split(RegExp(r'Distance:\s'))
      .last
      .split(' ')
      .where((String number) => number.isNotEmpty)
      .map((String number) => int.parse(number))
      .toList();
  int result = 1;
  for (int i = 0; i < times.length; i++) {
    result *= simulateRace(times[i], distances[i]);
  }
  print(result);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

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
  final List<String> times =
      timesStr.split(RegExp(r'Time:\s')).last.split(' ').where((String number) => number.isNotEmpty).toList();
  final List<String> distances =
      distancesStr.split(RegExp(r'Distance:\s')).last.split(' ').where((String number) => number.isNotEmpty).toList();
  // int result = 1;
  // for (int i = 0; i < times.length; i++) {
  //   result *= simulateRace(times[i], distances[i]);
  // }
  // print(result);
  final int combinedTime = int.parse(times.reduce((value, element) => value + element));
  final int combinedDistance = int.parse(distances.reduce((value, element) => value + element));
  print(simulateRace(combinedTime, combinedDistance));
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

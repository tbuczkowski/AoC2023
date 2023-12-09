import 'dart:io';

int processSequence(List<int> sequence) {
  final List<List<int>> differentials = [];
  List<int> last = [...sequence];
  while (differentials.isEmpty || differentials.last.any((element) => element != 0)) {
    differentials.add([]);
    for (int i = 1; i < last.length; i++) {
      differentials.last.add(last[i] - last[i - 1]);
    }
    last = [...differentials.last];
  }
  for (int i = differentials.length - 1; i >= 0; i--) {
    if (i == differentials.length - 1) {
      differentials[i].add(0);
    } else {
      differentials[i].insert(0, differentials[i].first - differentials[i + 1].first);
    }
  }
  // print(sequence);
  // print(differentials);
  // print(sequence.first - differentials.first.first);
  return sequence.first - differentials.first.first;
}

void main(List<String> arguments) {
  final List<String> lines = loadInputData(arguments.first);
  int sum = 0;
  for (String line in lines) {
    final List<int> numbers = line.split(' ').map((String number) => int.parse(number)).toList();
    sum += processSequence(numbers);
  }
  print(sum);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

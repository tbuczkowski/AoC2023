import 'dart:io';

import 'package:compute/compute.dart';

final Map<(List<String>, List<int>), int> cache = {};

Future<int> computeLine(({List<String> characters, List<int> sequence, int offset}) param) async {
  if (cache.containsKey((param.characters.sublist(param.offset), param.sequence))) {
    return cache[(param.characters.sublist(param.offset), param.sequence)]!;
  }
  if (param.characters.length == param.offset) {
    final int value = param.sequence.isEmpty || (param.sequence.length == 1 && param.sequence.first == 0) ? 1 : 0;
    if (value == 1) {
      // print(param);
    }
    // cache[(param.characters.sublist(param.offset), param.sequence)] = value;
    return value;
  }
  final String character = param.characters[param.offset];
  if (character == '.' &&
      param.offset > 0 &&
      param.characters[param.offset - 1] == '#' &&
      param.sequence.isNotEmpty &&
      param.sequence.first > 0) {
    cache[(param.characters.sublist(param.offset), param.sequence)] = 0;
    return 0;
  }
  if (character == '.' && (param.sequence.isEmpty || param.sequence.first != 0)) {
    final int value =
        await computeLine((characters: param.characters, sequence: param.sequence, offset: param.offset + 1));
    cache[(param.characters.sublist(param.offset), param.sequence)] = value;
    return value;
  } else if (character == '.' && param.sequence.first == 0) {
    final int value = await computeLine(
        (characters: param.characters, sequence: param.sequence.sublist(1), offset: param.offset + 1));
    cache[(param.characters.sublist(param.offset), param.sequence)] = value;
    return value;
  }
  if (character == '#') {
    if (param.sequence.isEmpty || param.sequence.first <= 0 || (param.sequence.first > param.characters.length)) {
      // print('returning because sequence failed');
      return 0;
    }
    final int value = await computeLine((
      characters: param.characters,
      sequence: [...param.sequence]..[0] = param.sequence[0] - 1,
      offset: param.offset + 1
    ));
    cache[(param.characters.sublist(param.offset), param.sequence)] = value;
    return value;
  }
  if (character == '?') {
    final List<String> v1 = [...param.characters]..[param.offset] = '.';
    final List<String> v2 = [...param.characters]..[param.offset] = '#';
    // print('splitting');
    final int sum = await computeLine((characters: v1, sequence: param.sequence, offset: param.offset)) +
        await computeLine((characters: v2, sequence: param.sequence, offset: param.offset));
    cache[(param.characters.sublist(param.offset), param.sequence)] = sum;
    // print('returning sum $sum');
    return sum;
  }
  // print('returning because no condition met');
  return 0;
}

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);
  final List<Future<int>> futures = [];
  for (String line in lines) {
    final [String rowStr, String sequenceStr] = line.split(' ');
    final List<String> row = rowStr.split('');
    final List<int> sequence = sequenceStr.split(',').map((e) => int.parse(e)).toList();
    final ({List<String> characters, List<int> sequence, int offset}) param = (
      characters: [...row, '?', ...row, '?', ...row, '?', ...row, '?', ...row],
      sequence: [...sequence, ...sequence, ...sequence, ...sequence, ...sequence],
      offset: 0
    );
    futures.add(compute(computeLine, param).then<int>((result) {
      print(result);
      return result;
    }));
  }
  final List<int> results = await Future.wait(futures);
  print(results);
  print(results.reduce((value, element) => value + element));
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

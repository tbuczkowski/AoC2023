final RegExp numbers = RegExp(r'[0-9]');

int _computeLine(String line) {
  String? firstChar, lastChar;
  final int length = line.length;
  for (int i = 0; i < length; i++) {
    final String forwardChar = line[i];
    final String backwardChar = line[length - i - 1];
    if (firstChar == null && forwardChar.contains(numbers)) {
      firstChar = forwardChar;
    }
    if (lastChar == null && backwardChar.contains(numbers)) {
      lastChar = backwardChar;
    }
    if (firstChar != null && lastChar != null) {
      break;
    }
  }
  return int.parse(firstChar! + lastChar!);
}

Future<void> main(List<String> arguments) async {
  // final List<int> results = await Future.wait(arguments.map((String line) => compute(_computeLine, line)).toList());
  final List<int> results = arguments.map((e) => _computeLine(e)).toList();
  print(results.fold<int>(0, (int sum, int element) => sum + element));
}

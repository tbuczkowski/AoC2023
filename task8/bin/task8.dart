import 'dart:io';

import 'package:dart_numerics/dart_numerics.dart';

class Node {
  final String id;
  final String left;
  final String right;

  Node({
    required this.id,
    required this.left,
    required this.right,
  });

  @override
  String toString() {
    return '{id: $id, left: $left, right: $right}';
  }
}

Map<String, Node> nodes = {};

void parseNode(String line) {
  var [String id, String rest] = line.split(' = ');
  rest = rest.replaceAll('(', '');
  rest = rest.replaceAll(')', '');
  final [String left, String right] = rest.split(', ');
  nodes[id] = Node(id: id, left: left, right: right);
}

void main(List<String> arguments) {
  final List<String> lines = loadInputData(arguments.first);
  final List<String> directions = lines.first.split('');
  lines.removeAt(0);
  lines.removeAt(0);
  for (String line in lines) {
    parseNode(line);
  }
  List<Node> currentNodes = nodes.values.where((Node node) => node.id.endsWith('Z')).toList();
  final List<Node> initialNodes = currentNodes.toList();
  final Map<Node, int> cycleFound = {};
  int stepCount = 0;
  while (!currentNodes.every((Node node) => node.id.endsWith('A'))) {
    if (cycleFound.length == initialNodes.length) {
      break;
    }
    final String direction = directions[stepCount % directions.length];
    // print((currentNodes, direction));
    final List<Node> nextNodes = [];
    for (int i = 0; i < currentNodes.length; i++) {
      if (direction == directions.first &&
          currentNodes[i] == initialNodes[i] &&
          cycleFound[currentNodes[i]] == null &&
          stepCount > 0) {
        cycleFound[currentNodes[i]] = stepCount;
        print((i, stepCount));
      }
      final String nextNode = switch (direction) {
        'L' => currentNodes[i].left,
        'R' => currentNodes[i].right,
        _ => throw Exception(),
      };
      nextNodes.add(nodes[nextNode]!);
    }
    currentNodes = nextNodes;
    stepCount++;
  }
  print(cycleFound.values.reduce((value, element) => leastCommonMultiple(value, element)));
  print(currentNodes);
  print(stepCount);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

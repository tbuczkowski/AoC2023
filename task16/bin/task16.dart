import 'dart:io';
import 'dart:math';

import 'package:compute/compute.dart';
import 'package:equatable/equatable.dart';

typedef Coords = ({int x, int y});

int processBeam((List<List<String>> grid, BeamNode startNode) param) {
  final Set<BeamNode> processedBeamNodes = {};
  final List<BeamNode> beamNodeProcessingQueue = [];
  beamNodeProcessingQueue.add(param.$2);
  while (beamNodeProcessingQueue.isNotEmpty) {
    final BeamNode? node =
        beamNodeProcessingQueue.removeLast().evaluate(param.$1, processedBeamNodes, beamNodeProcessingQueue);
    if (node != null) {
      processedBeamNodes.add(node);
    }
  }
  final Map<Coords, BeamNode> map = {};
  for (BeamNode node in processedBeamNodes) {
    map[node.coords] = node;
  }
  return map.length;
}

void tryAddBeamNode(Set<BeamNode> processedBeamNodes, List<BeamNode> beamNodeProcessingQueue, BeamNode node) {
  if (processedBeamNodes.contains(node)) {
    return;
  }
  beamNodeProcessingQueue.add(node);
}

class BeamNode extends Equatable {
  final Coords coords;
  final Coords source;
  final Coords _direction;

  BeamNode({
    required this.coords,
    required this.source,
  }) : _direction = (x: coords.x - source.x, y: coords.y - source.y);

  @override
  String toString() {
    return '{coords: $coords, source: $source, _direction: $_direction}';
  }

  BeamNode? evaluate(
      List<List<String>> grid, Set<BeamNode> processedBeamNodes, List<BeamNode> beamNodeProcessingQueue) {
    if (coords.x < 0 || coords.x >= grid.first.length || coords.y < 0 || coords.y >= grid.length) {
      return null;
    }
    final String symbol = grid[coords.y][coords.x];
    (switch ((symbol, _direction)) {
      ('.', _) || ('|', (x: 0, y: 1)) || ('|', (x: 0, y: -1)) || ('-', (x: 1, y: 0)) || ('-', (x: -1, y: 0)) => () {
          tryAddBeamNode(processedBeamNodes, beamNodeProcessingQueue,
              BeamNode(coords: (x: coords.x + _direction.x, y: coords.y + _direction.y), source: coords));
        },
      (r'\', (x: 1, y: 0)) || (r'\', (x: -1, y: 0)) || (r'/', (x: 0, y: 1)) || (r'/', (x: 0, y: -1)) => () {
          tryAddBeamNode(processedBeamNodes, beamNodeProcessingQueue,
              BeamNode(coords: (x: coords.x - _direction.y, y: coords.y + _direction.x), source: coords));
        },
      (r'\', (x: 0, y: 1)) || (r'\', (x: 0, y: -1)) || (r'/', (x: 1, y: 0)) || (r'/', (x: -1, y: 0)) => () {
          tryAddBeamNode(processedBeamNodes, beamNodeProcessingQueue,
              BeamNode(coords: (x: coords.x + _direction.y, y: coords.y - _direction.x), source: coords));
        },
      ('|', (x: 1, y: 0)) || ('|', (x: -1, y: 0)) || ('-', (x: 0, y: 1)) || ('-', (x: 0, y: -1)) => () {
          tryAddBeamNode(processedBeamNodes, beamNodeProcessingQueue,
              BeamNode(coords: (x: coords.x + _direction.y, y: coords.y - _direction.x), source: coords));
          tryAddBeamNode(processedBeamNodes, beamNodeProcessingQueue,
              BeamNode(coords: (x: coords.x - _direction.y, y: coords.y + _direction.x), source: coords));
        },
      _ => () {}
    })();
    return this;
  }

  @override
  List<Object?> get props => [coords, _direction];
}

void main(List<String> arguments) async {
  final List<List<String>> grid = [];
  final List<String> lines = loadInputData(arguments.first);
  for (String line in lines) {
    grid.add(line.split(''));
  }
  final List<Future<int>> futures = [];
  for (int i = 0; i < grid.length; i++) {
    futures.add(compute(processBeam, (grid, BeamNode(coords: (x: i, y: 0), source: (x: i, y: -1)))));
    futures.add(
        compute(processBeam, (grid, BeamNode(coords: (x: i, y: grid.length - 1), source: (x: i, y: grid.length)))));
    futures.add(compute(processBeam, (grid, BeamNode(coords: (x: 0, y: i), source: (x: -1, y: i)))));
    futures.add(
        compute(processBeam, (grid, BeamNode(coords: (x: grid.length - 1, y: i), source: (x: grid.length, y: i)))));
  }
  final List<int> results = await Future.wait(futures);
  print(results.reduce(max));
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

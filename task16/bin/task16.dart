import 'dart:io';

import 'package:equatable/equatable.dart';

final List<List<String>> grid = [];
final Set<BeamNode> processedBeamNodes = {};
final List<BeamNode> beamNodeProcessingQueue = [];

typedef Coords = ({int x, int y});

void tryAddBeamNode(BeamNode node) {
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

  void evaluate() {
    if (coords.x < 0 || coords.x >= grid.first.length || coords.y < 0 || coords.y >= grid.length) {
      return;
    }
    final String symbol = grid[coords.y][coords.x];
    (switch ((symbol, _direction)) {
      ('.', _) || ('|', (x: 0, y: 1)) || ('|', (x: 0, y: -1)) || ('-', (x: 1, y: 0)) || ('-', (x: -1, y: 0)) => () {
          tryAddBeamNode(BeamNode(coords: (x: coords.x + _direction.x, y: coords.y + _direction.y), source: coords));
        },
      (r'\', (x: 1, y: 0)) || (r'\', (x: -1, y: 0)) || (r'/', (x: 0, y: 1)) || (r'/', (x: 0, y: -1)) => () {
          tryAddBeamNode(BeamNode(coords: (x: coords.x - _direction.y, y: coords.y + _direction.x), source: coords));
        },
      (r'\', (x: 0, y: 1)) || (r'\', (x: 0, y: -1)) || (r'/', (x: 1, y: 0)) || (r'/', (x: -1, y: 0)) => () {
          tryAddBeamNode(BeamNode(coords: (x: coords.x + _direction.y, y: coords.y - _direction.x), source: coords));
        },
      ('|', (x: 1, y: 0)) || ('|', (x: -1, y: 0)) || ('-', (x: 0, y: 1)) || ('-', (x: 0, y: -1)) => () {
          tryAddBeamNode(BeamNode(coords: (x: coords.x + _direction.y, y: coords.y - _direction.x), source: coords));
          tryAddBeamNode(BeamNode(coords: (x: coords.x - _direction.y, y: coords.y + _direction.x), source: coords));
        },
      _ => () {}
    })();
    // print(beamNodeProcessingQueue);
    processedBeamNodes.add(this);
  }

  @override
  List<Object?> get props => [coords, _direction];
}

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);
  for (String line in lines) {
    grid.add(line.split(''));
  }
  beamNodeProcessingQueue.add(BeamNode(coords: (x: 0, y: 0), source: (x: -1, y: 0)));
  while (beamNodeProcessingQueue.isNotEmpty) {
    beamNodeProcessingQueue.removeLast().evaluate();
  }
  final Map<Coords, BeamNode> map = {};
  for (BeamNode node in processedBeamNodes) {
    map[node.coords] = node;
  }
  print(map.length);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

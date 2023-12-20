import 'dart:collection';
import 'dart:io';

final Map<String, LogicNode> nodes = {};

int highPulses = 0;
int lowPulses = 0;

final Queue<(String source, String destination, bool pulse)> pulsePropagationQueue = Queue();

sealed class LogicNode {
  final String key;
  final List<String> outputs;
  final Set<String> inputs = {};

  LogicNode({
    required this.key,
    required this.outputs,
  });

  void registerInput(String input) {
    inputs.add(input);
  }

  void emitPulse(bool pulse) {
    for (String output in outputs) {
      if (pulse) {
        highPulses++;
      } else {
        lowPulses++;
      }
      pulsePropagationQueue.add((key, output, pulse));
    }
  }

  void handlePulse(String source, bool pulse);
}

class Broadcaster extends LogicNode {
  Broadcaster({
    required super.key,
    required super.outputs,
  });

  @override
  void handlePulse(String source, bool pulse) {
    emitPulse(pulse);
  }
}

class FlipFlop extends LogicNode {
  bool isOn = false;

  FlipFlop({required super.key, required super.outputs});

  @override
  void handlePulse(String source, bool pulse) {
    if (pulse) {
      return;
    }
    isOn = !isOn;
    emitPulse(isOn);
  }
}

class Conjunction extends LogicNode {
  Map<String, bool> memory = {};

  Conjunction({required super.key, required super.outputs});

  @override
  void registerInput(String input) {
    super.registerInput(input);
    memory[input] = false;
  }

  @override
  void handlePulse(String source, bool pulse) {
    memory[source] = pulse;
    final bool everyInputHasHighPulse = memory.values.every((bool rememberedPulse) => rememberedPulse);
    emitPulse(!everyInputHasHighPulse);
  }
}

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);
  for (String line in lines) {
    final [String nodeDefinition, String outputs] = line.split(' -> ');
    final (String key, LogicNode node) = switch (nodeDefinition[0]) {
      '%' => (nodeDefinition.substring(1), FlipFlop(key: nodeDefinition.substring(1), outputs: outputs.split(', '))),
      '&' => (nodeDefinition.substring(1), Conjunction(key: nodeDefinition.substring(1), outputs: outputs.split(', '))),
      _ => (nodeDefinition, Broadcaster(key: nodeDefinition, outputs: outputs.split(', '))),
    };
    nodes[key] = node;
  }
  for (LogicNode node in nodes.values) {
    final List<String> outputs = node.outputs;
    for (String output in outputs) {
      nodes[output]?.registerInput(node.key);
    }
  }
  for (int i = 0; i < 999999999; i++) {
    lowPulses++;
    pulsePropagationQueue.add(('entrypoint', 'broadcaster', false));
    while (pulsePropagationQueue.isNotEmpty) {
      final (String source, String destination, bool pulse) = pulsePropagationQueue.removeFirst();
      // if (destination == 'rx') {
      //   print((source, destination, pulse));
      //   print(i);
      // }
      if (destination == 'vf' && pulse) {
        print((source, destination, pulse, i));
      }
      nodes[destination]?.handlePulse(source, pulse);
    }
  }
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

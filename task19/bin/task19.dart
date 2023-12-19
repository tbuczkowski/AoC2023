import 'dart:io';
import 'dart:math';

class Range {
  final int min;
  final int max;

  Range({required this.min, required this.max});

  @override
  String toString() {
    return '{min: $min, max: $max}';
  }

  int get possibilities => max - min + 1;
}

class Ruleset {
  final String key;
  final List<Rule> rules;

  Ruleset({required this.key, required this.rules});
}

class Rule {
  final String property;
  final String operator;
  final int value;
  final String returnValue;

  Rule({
    required this.property,
    required this.operator,
    required this.value,
    required this.returnValue,
  });
}

final Map<String, Ruleset> rulesets = {};

final RegExp rulesetRegExp = RegExp(r'([a-z]+)\{(.+)\}');
final RegExp ruleRegExp = RegExp(r'([xmas])([<>])(\d+)\:([a-zRA]+)');

final Range defaultRange = Range(min: 1, max: 4000);

Range mergeRange(Range a, Range b) {
  if (a.min == -1 || b.min == -1) {
    return Range(min: -1, max: -1);
  }
  final int newMin = max(a.min, b.min);
  final int newMax = min(a.max, b.max);
  if (newMin > newMax) {
    return Range(min: -1, max: -1);
  }
  return Range(min: newMin, max: newMax);
}

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);
  bool rulesetsLoaded = false;
  for (String line in lines) {
    if (line.isEmpty) {
      break;
    }
    if (!rulesetsLoaded) {
      final Match match = rulesetRegExp.firstMatch(line)!;
      final [String key, String rulesStr] = [match[1]!, match[2]!];
      final List<Rule> rules = rulesStr.split(',').map((String ruleStr) {
        final Match? match = ruleRegExp.firstMatch(ruleStr);
        if (match != null) {
          return Rule(
            property: match[1]!,
            operator: match[2]!,
            value: int.parse(match[3]!),
            returnValue: match[4]!,
          );
        }
        return Rule(property: '', operator: '', value: 0, returnValue: ruleStr);
      }).toList();
      rulesets[key] = Ruleset(key: key, rules: rules);
    }
  }

  final List<(Ruleset, Map<String, Range>)> rulesetsToEvaluate = [];
  final List<Map<String, Range>> acceptRanges = [];
  rulesetsToEvaluate.add((rulesets['in']!, {}));
  while (rulesetsToEvaluate.isNotEmpty) {
    final (Ruleset currentRuleset, Map<String, Range> entryRanges) = rulesetsToEvaluate.removeLast();
    // print((currentRuleset.key, entryRanges.combinations));
    final Map<String, Range> currentRanges = Map.from(entryRanges);
    for (Rule rule in currentRuleset.rules) {
      if (rule.operator.isEmpty) {
        if (rule.returnValue == 'A') {
          print(('Ae', currentRanges));
          acceptRanges.add(currentRanges);
          break;
        }
        if (rule.returnValue == 'R') {
          break;
        }
        rulesetsToEvaluate.add((rulesets[rule.returnValue]!, currentRanges));
        break;
      }
      if (rule.operator == '>') {
        final Map<String, Range> outgoingRanges = Map.from(currentRanges);
        final Range newOutgoingRange =
            mergeRange(Range(min: rule.value + 1, max: defaultRange.max), currentRanges[rule.property] ?? defaultRange);
        final Range newCurrentRange =
            mergeRange(Range(min: defaultRange.min, max: rule.value), currentRanges[rule.property] ?? defaultRange);
        currentRanges[rule.property] = newCurrentRange;
        if (newOutgoingRange.min == -1) {
          continue;
        }
        outgoingRanges[rule.property] = newOutgoingRange;
        if (rule.returnValue == 'A') {
          print(('A>', outgoingRanges));
          acceptRanges.add(outgoingRanges);
        } else if (rule.returnValue != 'R') {
          rulesetsToEvaluate.add((rulesets[rule.returnValue]!, outgoingRanges));
        }
      } else if (rule.operator == '<') {
        final Map<String, Range> outgoingRanges = Map.from(currentRanges);
        final Range newCurrentRange =
            mergeRange(Range(min: rule.value, max: defaultRange.max), currentRanges[rule.property] ?? defaultRange);
        final Range newOutgoingRange =
            mergeRange(Range(min: defaultRange.min, max: rule.value - 1), currentRanges[rule.property] ?? defaultRange);
        currentRanges[rule.property] = newCurrentRange;
        if (newOutgoingRange.min == -1) {
          continue;
        }
        outgoingRanges[rule.property] = newOutgoingRange;
        if (rule.returnValue == 'A') {
          print(('A<', outgoingRanges));
          acceptRanges.add(outgoingRanges);
        } else if (rule.returnValue != 'R') {
          rulesetsToEvaluate.add((rulesets[rule.returnValue]!, outgoingRanges));
        }
      }
    }
  }
  // print(acceptRanges.map((e) => e.combinations).toList());
  final double total =
      acceptRanges.fold<double>(0, (double sum, Map<String, Range> ranges) => sum + ranges.combinations);
  print(total);
}

List<Map<String, Range>> computeIntersections(List<Map<String, Range>> list) {
  List<Map<String, Range>> fullList = [...list];
  List<Map<String, Range>> intersections = [];
  for (int i = 0; i < fullList.length - 1; i++) {
    for (int j = i + 1; j < fullList.length; j++) {
      final Map<String, Range> a = fullList[i];
      final Map<String, Range> b = fullList[j];
      Map<String, Range>? intersection = a.computeIntersection(b);
      if (intersection != null) {
        intersections.add(intersection);
      }
    }
  }
  return intersections;
}

extension U on Map<String, Range> {
  num get combinations => ((this['x']?.possibilities ?? 4000) *
      (this['m']?.possibilities ?? 4000) *
      (this['a']?.possibilities ?? 4000) *
      (this['s']?.possibilities ?? 4000));

  Map<String, Range>? computeIntersection(Map<String, Range> other) {
    final Map<String, Range> result = {};
    for (String key in ['x', 'm', 'a', 's']) {}
    return result.values.any((element) => element.min == -1) ? null : result;
  }
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

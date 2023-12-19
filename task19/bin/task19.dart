import 'dart:io';

class Ruleset {
  final String key;
  final List<Rule> rules;

  Ruleset({required this.key, required this.rules});

  String evaluate(Map<String, int> part) {
    String? returnValue;
    for (Rule rule in rules) {
      returnValue = rule.evaluate(part);
      if (returnValue != null) {
        break;
      }
    }
    return returnValue!;
  }
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

  String? evaluate(Map<String, int> part) {
    if (operator.isEmpty) {
      return returnValue;
    }
    final int partPropertyValue = part[property]!;
    if (operator == '>' && partPropertyValue > value) {
      return returnValue;
    }
    if (operator == '<' && partPropertyValue < value) {
      return returnValue;
    }
    return null;
  }
}

final Map<String, Ruleset> rulesets = {};
final List<Map<String, int>> parts = [];
final List<Map<String, int>> acceptedParts = [];

final RegExp rulesetRegExp = RegExp(r'([a-z]+)\{(.+)\}');
final RegExp ruleRegExp = RegExp(r'([xmas])([<>])(\d+)\:([a-zRA]+)');

void main(List<String> arguments) async {
  final List<String> lines = loadInputData(arguments.first);
  bool rulesetsLoaded = false;
  for (String line in lines) {
    if (line.isEmpty) {
      rulesetsLoaded = true;
      continue;
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
    } else {
      final Map<String, int> part = {
        for (var property in line.substring(1, line.length - 1).split(','))
          property.split('=').first: int.parse(property.split('=').last)
      };
      parts.add(part);
    }
  }
  for (Map<String, int> part in parts) {
    late Ruleset ruleset;
    String result = 'in';
    while (result != 'A' && result != 'R') {
      ruleset = rulesets[result]!;
      result = ruleset.evaluate(part);
    }
    if (result == 'A') {
      acceptedParts.add(part);
    }
  }
  final int rating = acceptedParts.fold<int>(
    0,
    (int sum, Map<String, int> part) =>
        sum +
        part.values.fold<int>(
          0,
          (sum, int element) => sum + element,
        ),
  );
  print(acceptedParts);
  print(rating);
}

List<String> loadInputData(String filename) {
  final File file = File(filename);
  final List<String> lines = file.readAsLinesSync();
  return lines;
}

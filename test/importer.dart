import 'package:automator/characters/character.dart';
import 'package:automator/core/reader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Reader tests', () {
    test('Read from history file', () {
      String source = """
      create_country_leader = {
        name = "Rodrigo Duterte"
        ideology = social_democrat_subtype
        traits = { }
        expire = "2065.1.1"
      }
    """;
      List<String> lines = source.split('\n');
      List<String> names = Reader.readFromHistory(lines);
      expect(names.contains('Rodrigo Duterte'), true);
    });

    test('Read from localization file', () {
      String source = """
      PHI_Rodrigo_Duterte_hog_sde:0 "Rodrigo Duterte"
    """;

      List<String> lines = source.split('\n');
      List<Character> characters = Reader.readFromYAML(lines);
      expect(characters.where((c) => c.name == 'Rodrigo Duterte').length, 1);
    });

    test('Read from csv file', () {
      String source = "Rodrigo Duterte, Ferdinand Marcos Jr.";

      List<String> names = Reader.readFromCSV(source);
      expect(names.contains('Rodrigo Duterte'), true);
    });
  });
}

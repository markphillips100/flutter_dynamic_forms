import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:dynamic_forms_generator/dynamic_forms_generator.dart';
import 'package:test/test.dart';

void main() {
  test('registered builder generates model and parser from component YAML',
      () async {
    await testBuilder(
      dynamicFormsBuilder(const BuilderOptions({})),
      {
        'dynamic_forms_generator|lib/smoke_component.yaml': '''
type: smokeComponent
parentType: formElement
properties:
  label:
    type: string
''',
      },
      outputs: {
        'dynamic_forms_generator|lib/smoke_component.g.dart':
            decodedMatches(contains('class SmokeComponent')),
        'dynamic_forms_generator|lib/smoke_component_parser.g.dart':
            decodedMatches(contains('class SmokeComponentParser')),
      },
    );
  });

  test('registered builder generates enum model without parser output',
      () async {
    await testBuilder(
      dynamicFormsBuilder(const BuilderOptions({})),
      {
        'dynamic_forms_generator|lib/smoke_enum.yaml': '''
type: smokeEnum
parentType: enum
values:
  - firstValue
  - secondValue
''',
      },
      outputs: {
        'dynamic_forms_generator|lib/smoke_enum.g.dart':
            decodedMatches(contains('enum SmokeEnum')),
      },
    );
  });
}
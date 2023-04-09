import 'package:petitparser/petitparser.dart';

class ComponentTypeGrammarDefinition extends GrammarDefinition {
  final bool parseTypeDefinition;

  ComponentTypeGrammarDefinition({this.parseTypeDefinition = false});

  @override
  Parser start() {
    if (parseTypeDefinition) {
      return ref0(typeDefinitionExpression).end();
    }
    return ref0(typeExpression).end();
  }

  Parser typeExpression() =>
      ref0(identifier).flatten() &
      ref0(genericParameters).optional() &
      ref0(arraySymbol).optional() &
      ref0(nullableSymbol).optional();

  Parser typeDefinitionExpression() =>
      ref0(identifier).flatten() & ref0(genericDefinitionParameters).optional();

  Parser genericParameters() =>
      ref1(token, '<') & ref0(listOfTypes) & ref1(token, '>');

  Parser arraySymbol() => ref1(token, '[]');
  Parser nullableSymbol() => ref1(token, '?');

  Parser genericDefinitionParameters() =>
      ref1(token, '<') &
      ref0(listOfGenericDefinitionParameterTypes) &
      ref1(token, '>');

  Parser listOfTypes() =>
      (ref0(typeExpression) & ref1(token, ',')).star() & ref0(typeExpression);

  Parser listOfGenericDefinitionParameterTypes() =>
      (ref0(genericParameterTypeExpression) & ref1(token, ',')).star() &
      ref0(genericParameterTypeExpression);

  Parser genericParameterTypeExpression() =>
      ref0(identifier).flatten() &
      (ref1(token, 'extends') & ref0(typeExpression)).optional();

  Parser anyLetter() => letter();
  Parser anyDigit() => digit();

  Parser identifier() =>
      ref0(anyLetter) & (ref0(anyLetter) | ref0(anyDigit)).star();

  Parser token(Object input) {
    if (input is Parser) {
      return input.token().trim();
    } else if (input is String) {
      return token(input.length == 1 ? char(input) : string(input));
    } else if (input is Function) {
      return token(input);
    }
    throw ArgumentError.value(input, 'invalid token parser');
  }
}

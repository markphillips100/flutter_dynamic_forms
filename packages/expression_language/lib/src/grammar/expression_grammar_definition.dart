import 'package:petitparser/petitparser.dart';

class ExpressionGrammarDefinition extends GrammarDefinition {
  @override
  Parser start() => (ref(expression).end()).or(ref(failureState));

  Parser FALSE() => ref(token, 'false');
  Parser TRUE() => ref(token, 'true');
  Parser LETTER() => letter();
  Parser DIGIT() => digit();
  Parser failureState() =>
      (ref(expression).trim() & ref(fail).trim()) | ref(fail).trim();
  Parser fail() => any();
  Parser letterOrSpecialChar() => ref(LETTER) | ref(token, '_');

  Parser decimalNumber() =>
      ref(DIGIT) &
      ref(DIGIT).star() &
      char('.') &
      ref(DIGIT) &
      ref(DIGIT).star();
  Parser integerNumber() => ref(DIGIT) & ref(DIGIT).star();
  Parser singleLineString() =>
      char('"') & ref(stringContent).star() & char('"');
  Parser stringContent() => pattern('^"');
  Parser literal() => ref(
      token,
      ref(decimalNumber) |
          ref(integerNumber) |
          ref(TRUE) |
          ref(FALSE) |
          ref(singleLineString));
  Parser identifier() =>
      ref(letterOrSpecialChar) & (ref(letterOrSpecialChar) | ref(DIGIT)).star();

  Parser function() =>
      ref(identifier).flatten() &
      ref(token, '(') &
      ref(functionParameters).optional() &
      ref(token, ')');
  Parser functionParameters() =>
      (ref(expression) & ref(token, ',')).star() & ref(expression);

  Parser additiveOperator() => ref(token, '+') | ref(token, '-');
  Parser relationalOperator() =>
      ref(token, '>=') | ref(token, '>') | ref(token, '<=') | ref(token, '<');

  Parser equalityOperator() => ref(token, '==') | ref(token, '!=');
  Parser multiplicativeOperator() =>
      ref(token, '*') |
      ref(token, '/') |
      ref(token, '~') & ref(token, '/') |
      ref(token, '%');

  Parser unaryNegateOperator() => ref(token, '-') | ref(token, '!');

  Parser expressionInParentheses() =>
      ref(token, '(') & ref(expression) & ref(token, ')');

  Parser expression() => ref(conditionalExpression);

  Parser conditionalExpression() =>
      ref(logicalOrExpression) &
      (ref(token, '?') & ref(expression) & ref(token, ':') & ref(expression))
          .optional();

  Parser logicalOrExpression() =>
      ref(logicalAndExpression) &
      (ref(token, '||') & ref(logicalAndExpression)).star();

  Parser logicalAndExpression() =>
      ref(equalityExpression) &
      (ref(token, '&&') & ref(equalityExpression)).star();

  Parser equalityExpression() =>
      ref(relationalExpression) &
      (ref(equalityOperator) & ref(relationalExpression)).optional();

  Parser relationalExpression() =>
      ref(additiveExpression) &
      (ref(relationalOperator) & ref(additiveExpression)).optional();

  Parser additiveExpression() =>
      ref(multiplicativeExpression) &
      (ref(additiveOperator) & ref(multiplicativeExpression)).star();

  Parser multiplicativeExpression() =>
      ref(postfixOperatorExpression) &
      (ref(multiplicativeOperator) & ref(postfixOperatorExpression)).star();

  Parser postfixOperatorExpression() =>
      ref(unaryExpression) & (char('!').seq(char('=').not())).optional();

  Parser unaryExpression() =>
      ref(literal) |
      ref(expressionInParentheses) |
      ref(function) |
      ref(reference) |
      ref(unaryNegateOperator) & ref(unaryExpression);

  Parser reference() =>
      char('@') &
      ref(identifier).flatten() &
      (char('.') & ref(identifier).flatten()).star();

  Parser token(Object input) {
    if (input is Parser) {
      return input.token().trim();
    } else if (input is String) {
      return token(input.length == 1 ? char(input) : string(input));
    } else if (input is Function) {
      return token(ref(input));
    }
    throw ArgumentError.value(input, 'invalid token parser');
  }
}

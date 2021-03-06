import 'package:expression_language/expression_language.dart';

class EqualDurationExpression extends Expression<bool> {
  final Expression<Duration> left;
  final Expression<Duration> right;

  EqualDurationExpression(this.left, this.right);

  @override
  bool evaluate() {
    return left.evaluate() == right.evaluate();
  }

  @override
  List<Expression<dynamic>> getChildren() {
    return [
      left,
      right,
    ];
  }

  @override
  Expression<bool> clone(Map<String, ExpressionProviderElement> elementMap) {
    return EqualDurationExpression(
        left.clone(elementMap), right.clone(elementMap));
  }
}

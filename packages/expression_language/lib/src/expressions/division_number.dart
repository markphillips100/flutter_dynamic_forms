import 'package:expression_language/expression_language.dart';

class DivisionNumberExpression extends Expression<Number> {
  final Expression<Number> left;
  final Expression<Number> right;

  DivisionNumberExpression(this.left, this.right);

  @override
  Decimal evaluate() {
    var rightValue = right.evaluate();
    var epsilon = Decimal.parse('1e-15');
    if (rightValue.abs() < epsilon) {
      throw DivideByZeroException('Division by zero');
    }
    return left.evaluate() / right.evaluate();
  }

  @override
  Type getType() {
    return getTypeOfNumberExpression(left.getType(), right.getType());
  }

  @override
  List<Expression<dynamic>> getChildren() {
    return [
      left,
      right,
    ];
  }

  @override
  Expression<Number> clone(Map<String, ExpressionProviderElement> elementMap) {
    return DivisionNumberExpression(
        left.clone(elementMap), right.clone(elementMap));
  }
}

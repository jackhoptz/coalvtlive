enum ExpressionType {
  none,
  happy,
}

class ExpressionInfo {
  ExpressionInfo({
    required this.expressionUrl,
    required this.expression,
  });
  String expressionUrl;
  ExpressionType expression;
}

import 'package:dynamic_forms/dynamic_forms.dart';

import 'label.dart';

class LabelParser extends FormElementParser<Label> {
  @override
  String get name => 'label';

  @override
  FormElement getInstance() => Label();

  @override
  void fillProperties(
      Label label, ParserNode parserNode, Element? parent, parser) {
    super.fillProperties(label, parserNode, parent, parser);
    label..valueProperty = parserNode.getStringProperty('value');
  }
}

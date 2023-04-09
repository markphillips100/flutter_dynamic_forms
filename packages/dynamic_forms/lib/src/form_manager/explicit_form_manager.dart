import 'package:dynamic_forms/dynamic_forms.dart';

class ExplicitFormManager extends FormManager {
  ExplicitFormManager({
    required FormData formData,
  }) {
    fillFromFormData(formData);
  }
}

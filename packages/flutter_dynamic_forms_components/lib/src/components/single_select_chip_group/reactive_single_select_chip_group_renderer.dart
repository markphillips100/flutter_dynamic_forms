import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:rxdart/rxdart.dart';

class ReactiveSingleSelectChipGroupRenderer
    extends FormElementRenderer<SingleSelectChipGroup> {
  @override
  Widget render(
      SingleSelectChipGroup element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    List<Stream> streamsToReact = [];
    streamsToReact.addAll(element.choices.map((o) => o.isVisibleChanged));
    streamsToReact.add(element.propertyChanged);
    return StreamBuilder<List<SingleSelectChipChoice>>(
      initialData: element.choices,
      stream: element.choicesChanged,
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: MergeStream(
            snapshot.data!.map((child) => child.isVisibleChanged),
          ),
          builder: (context, _) => Wrap(
            children: element.choices
                .where((c) => c.isVisible)
                .map((choice) => renderer(choice, context))
                .toList(),
          ),
        );
      },
    );
  }
}

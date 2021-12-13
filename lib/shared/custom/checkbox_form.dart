import 'package:flutter/material.dart';

class CheckboxForm extends StatelessWidget {
  const CheckboxForm({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.enabled = true,
  }) : super(key: key);
  final bool value;
  final Function(bool?) onChanged;
  final Widget title;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              onChanged(!value);
            }
          : null,
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: title,
          )
        ],
      ),
    );
  }
}

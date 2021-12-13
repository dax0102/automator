import 'package:flutter/material.dart';

class SwitchForm extends StatelessWidget {
  const SwitchForm({
    Key? key,
    required this.checked,
    required this.onChanged,
    required this.title,
    this.enabled = true,
  }) : super(key: key);
  final bool checked;
  final Function(bool?) onChanged;
  final Widget title;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              onChanged(!checked);
            }
          : null,
      child: Row(
        children: [
          Expanded(
            child: title,
          ),
          Switch(
            value: checked,
            onChanged: enabled ? onChanged : null,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RadioForm<T> extends StatelessWidget {
  const RadioForm({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.enabled = true,
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);
  final T value;
  final T groupValue;
  final Function(T?) onChanged;
  final Widget title;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              onChanged(value);
            }
          : null,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: title,
            )
          ],
        ),
      ),
    );
  }
}
